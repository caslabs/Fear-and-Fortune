import { Controller, OnStart, OnInit } from "@flamework/core";
import { ContextActionService, TweenService, Workspace, Players } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import Signal from "@rbxts/signal";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import { Signals } from "shared/signals";
import StaminaController from "./stamina-controller";
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

// Create signals for the stamina and sprinting state

//TODO: Implement "Keep Playing until Stop" based on Events
const BreathingSound = new Instance("Sound");
BreathingSound.SoundId = "rbxassetid://" + 13868760809;
BreathingSound.Parent = game.GetService("SoundService");
BreathingSound.Volume = 2;

@Controller({})
export default class SprintController implements OnStart, OnInit {
	private isSprinting = false;
	private hasStaminaDepleted = false;
	private lastPosition: Vector3 | undefined;

	constructor(
		private readonly characterController: CharacterController,
		private readonly staminaController: StaminaController,
	) {}

	/** @hidden */
	public onInit(): void {
		// Connect a function that changes the stamina according to the sprinting state
		Signals.onStartStamina.Connect((isSprinting: boolean) => {
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

		this.lastPosition = character?.HumanoidRootPart.Position; // Save initial position

		const runningSound = character?.HumanoidRootPart.FindFirstChild("Running") as Sound;
		if (runningSound) {
			runningSound.PlaybackSpeed = 1.5; // Change the pitch
			print("Running");
		} else {
			print("No running sound");
		}

		humanoid.WalkSpeed = maxSpeed;
		this.isSprinting = true;
		Signals.onStartStamina.Fire(true);
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
		Signals.onStartStamina.Fire(false);
		BreathingSound.Stop();
		print("[STATE] Walking");
	}

	private async sprintingStaminaUpdate() {
		const character = this.characterController.getCurrentCharacter();

		// Decrease stamina while sprinting
		while (this.isSprinting && this.staminaController.stamina > 0) {
			if (character?.HumanoidRootPart.Position !== this.lastPosition) {
				// Check if player is moving
				this.staminaController.stamina -= 1;
				Signals.StaminaUpdate.Fire(Players.LocalPlayer, this.staminaController.stamina);
			}

			this.lastPosition = character?.HumanoidRootPart.Position; // Update last known position

			await Promise.delay(this.staminaController.staminaDecreaseInterval);
		}

		// Stamina has fully depleted
		if (this.staminaController.stamina <= 0) {
			this.stopSprinting();
			this.hasStaminaDepleted = true; // Prevents sprinting until full recovery

			//Stop Running Breathing and Play intense breathing sound
			BreathingSound.Stop();
			SoundSystemController.playSound(SoundKeys.SFX_STAMINA_LOW_BREATHING, 10);
		}
	}

	private async walkingStaminaUpdate() {
		// Increase stamina while walking
		while (!this.isSprinting && this.staminaController.stamina < this.staminaController.maxStamina) {
			this.staminaController.stamina += 1;
			Signals.StaminaUpdate.Fire(Players.LocalPlayer, this.staminaController.stamina);
			await Promise.delay(this.staminaController.staminaIncreaseInterval * 2); // Doubles the delay for stamina recovery
		}

		// Stamina has recovered to threshold
		if (this.staminaController.stamina >= this.staminaController.staminaRecoveryThreshold) {
			this.hasStaminaDepleted = false; // Allows sprinting again
		}
	}
}
