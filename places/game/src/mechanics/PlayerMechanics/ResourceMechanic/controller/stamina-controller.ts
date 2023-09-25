import { Controller, OnStart, OnInit } from "@flamework/core";
import { ContextActionService, TweenService, Workspace, Players } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import Signal from "@rbxts/signal";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import { Signals } from "shared/signals";

const maxStamina = 100;
const staminaDecrease = 10; // Stamina spent per jump
const staminaIncrease = 1; // Stamina recovery per walking interval
const staminaDecreaseInterval = 0.1; // Interval for stamina decrease
const staminaIncreaseInterval = 0.1; // Interval for stamina increase
const staminaRecoveryThreshold = maxStamina * 0.5; // Recovery threshold

const jumpDelay = 1; // Delay between jumps

export const StaminaUpdate = new Signal<(player: Player, stamina: number) => void>();

@Controller({})
export default class StaminaController implements OnStart, OnInit {
	public maxStamina = 100;
	public stamina = this.maxStamina;
	public staminaDecreaseInterval = 0.1; // Interval for stamina decrease
	public staminaIncreaseInterval = 0.1; // Interval for stamina increase
	public staminaRecoveryThreshold = this.maxStamina * 0.5; // Recovery threshold
	public hasStaminaDepleted = false;

	constructor(public readonly characterController: CharacterController) {}

	public onInit(): void {}

	public onStart(): void {
		Signals.jumpingStateChanged.Connect((isJumping: boolean) => {
			if (isJumping) {
				task.spawn(() => this.staminaUpdate(-10)); // Stamina decrease while jumping
			} else {
				task.spawn(() => this.staminaUpdate(1)); // Stamina increase while walking
			}
		});

		Signals.onStartStamina.Connect((isSprinting: boolean) => {
			if (isSprinting) {
				task.spawn(() => this.staminaUpdate(-1)); // Stamina decrease while sprinting
			} else {
				task.spawn(() => this.staminaUpdate(1)); // Stamina increase while walking
			}
		});
	}

	public async staminaUpdate(staminaChange: number) {
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.FindFirstChildOfClass("Humanoid");

		// Don't decrease stamina if it's already depleted
		if (this.hasStaminaDepleted && staminaChange < 0) return;

		this.stamina += staminaChange;
		if (this.stamina <= 0) {
			this.stamina = 0;
			this.hasStaminaDepleted = true; // Prevents jumping and sprinting until full recovery

			SoundSystemController.playSound(SoundKeys.SFX_STAMINA_LOW_BREATHING, 10);
		} else if (this.stamina >= this.maxStamina) {
			this.stamina = this.maxStamina;
		}

		StaminaUpdate.Fire(Players.LocalPlayer, this.stamina);

		if (this.stamina >= this.staminaRecoveryThreshold) {
			this.hasStaminaDepleted = false; // Allows jumping and sprinting again
		}

		await Promise.delay(this.hasStaminaDepleted ? this.staminaIncreaseInterval : this.staminaDecreaseInterval);
	}
}
