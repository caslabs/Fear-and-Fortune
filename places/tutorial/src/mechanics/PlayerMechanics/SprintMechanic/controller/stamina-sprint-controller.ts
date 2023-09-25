import { Controller, OnStart, OnInit } from "@flamework/core";
import { ContextActionService, TweenService, Workspace, Players } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import Signal from "@rbxts/signal";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
const camera = Workspace.CurrentCamera!;
const tweenInfo = new TweenInfo(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In);

//TODO: Make this data driven
const sprintMultiplier = 1.45;
const baseSpeed = 16;
const maxSpeed = baseSpeed * sprintMultiplier;
const minSpeed = baseSpeed;

//TODO: Used to be 85, find a good animation for running in first person
const maxFov = 90;
const minFov = 70;

const startSprintingState = Enum.UserInputState.Begin;
const stopSprintingState = Enum.UserInputState.End;

const maxStamina = 100;
const staminaDecrease = 1;
const staminaIncrease = 1;
const staminaDecreaseInterval = 0.1; // time unit in seconds
const staminaIncreaseInterval = 0.1; // time unit in seconds
const staminaRecoveryThreshold = maxStamina * 0.5; // Change the multiplier according to your design

// Create signals for the stamina and sprinting state
export const StaminaUpdate = new Signal<(player: Player, stamina: number) => void>();
const sprintingStateChanged = new Signal<(isSprinting: boolean) => void>();
//TODO: Implement "Keep Playing until Stop" based on Events
const BreathingSound = new Instance("Sound");
BreathingSound.SoundId = "rbxassetid://" + 13868760809;
BreathingSound.Parent = game.GetService("SoundService");
BreathingSound.Volume = 2;

@Controller({})
export default class SprintController implements OnStart, OnInit {
	private isSprinting = false;
	private stamina = maxStamina;
	private hasStaminaDepleted = false;

	constructor(private readonly characterController: CharacterController) {}

	/** @hidden */
	public onInit(): void {
		// Connect a function that changes the stamina according to the sprinting state
		sprintingStateChanged.Connect((isSprinting: boolean) => {
			if (isSprinting) {
				task.spawn(() => this.sprintingStaminaUpdate());
			} else {
				task.spawn(() => this.walkingStaminaUpdate());
			}
		});
	}
	/** @hidden */
	public onStart(): void {
		ContextActionService.BindAction("Sprint", (_, s) => this.handleInput(s), true, Enum.KeyCode.LeftShift);

		this.characterController.onCharacterAdded.Connect(() => {
			if (!this.isSprinting) return;
			this.startSprinting();
		});
	}

	private handleInput(state: Enum.UserInputState) {
		if (state === startSprintingState) {
			this.startSprinting();
		} else if (state === stopSprintingState) {
			this.stopSprinting();
		}
	}

	private startSprinting() {
		// Prevent sprinting if stamina has depleted fully
		if (this.hasStaminaDepleted) {
			return;
		}

		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.Humanoid;
		if (!humanoid) return;

		const runningSound = character?.HumanoidRootPart.FindFirstChild("Running") as Sound;
		if (runningSound) {
			runningSound.PlaybackSpeed = 1.5; // Change the pitch
			print("Running");
		} else {
			print("No running sound");
		}

		humanoid.WalkSpeed = maxSpeed;
		this.isSprinting = true;
		sprintingStateChanged.Fire(true);
		BreathingSound.Play();
		print("[STATE] Sprinting");
	}

	private stopSprinting() {
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.Humanoid;
		if (!humanoid) return;

		const runningSound = character?.HumanoidRootPart.FindFirstChild("Running") as Sound;
		if (runningSound) {
			runningSound.PlaybackSpeed = 1.3; // Change the pitch
			print("Running");
		} else {
			print("No running sound");
		}

		humanoid.WalkSpeed = minSpeed;
		this.isSprinting = false;
		sprintingStateChanged.Fire(false);
		BreathingSound.Stop();
		print("[STATE] Walking");
	}

	private async sprintingStaminaUpdate() {
		// Decrease stamina while sprinting
		while (this.isSprinting && this.stamina > 0) {
			this.stamina -= staminaDecrease;
			StaminaUpdate.Fire(Players.LocalPlayer, this.stamina);
			await Promise.delay(staminaDecreaseInterval);
		}

		// Stamina has fully depleted
		if (this.stamina <= 0) {
			this.stopSprinting();
			this.hasStaminaDepleted = true; // Prevents sprinting until full recovery

			//Stop Running Breathing and Play intense breathing sound
			BreathingSound.Stop();
			SoundSystemController.playSound(SoundKeys.SFX_STAMINA_LOW_BREATHING, 10);
		}
	}

	private async walkingStaminaUpdate() {
		// Increase stamina while walking
		while (!this.isSprinting && this.stamina < maxStamina) {
			this.stamina += staminaIncrease;
			StaminaUpdate.Fire(Players.LocalPlayer, this.stamina);
			await Promise.delay(staminaIncreaseInterval * 2); // Doubles the delay for stamina recovery
		}

		// Stamina has recovered to threshold
		if (this.stamina >= staminaRecoveryThreshold) {
			this.hasStaminaDepleted = false; // Allows sprinting again
		}
	}
}
