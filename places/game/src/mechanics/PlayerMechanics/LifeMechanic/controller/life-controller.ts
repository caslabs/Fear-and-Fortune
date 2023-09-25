import { Controller, OnStart, OnInit } from "@flamework/core";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import Signal from "@rbxts/signal";
import Remotes from "shared/remotes";
import { HUDController } from "mechanics/PlayerMechanics/UIMechanic/controller/hud-controller";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";
const ToggleRespawn = Remotes.Client.Get("ToggleRespawn");

@Controller({})
export default class LifeMechanic implements OnStart, OnInit {
	private playerLives = 1;
	public readonly livesChanged = new Signal<(lives: number) => void>();
	private isDying = false;

	constructor(
		private readonly characterController: CharacterController,
		private readonly hudController: HUDController,
		private readonly musicSystemController: MusicSystemController,
	) {}

	/** @hidden */
	public onInit(): void {}

	/** @hidden */
	public onStart(): void {
		this.characterController.onCharacterAdded.Connect(() => {
			const character = this.characterController.getCurrentCharacter();
			const humanoid = character?.Humanoid;
			if (!humanoid) return;

			this.isDying = false;
			this.monitorHealth(humanoid);
		});

		this.characterController.onCharacterRemoved.Connect(() => {
			if (this.playerLives <= 0) {
				this.playerLives = 1; // Reset the player's lives when their character is removed
			}
		});

		if (this.characterController.getCurrentCharacter()) {
			const humanoid = this.characterController.getCurrentCharacter()?.Humanoid;
			if (humanoid) this.monitorHealth(humanoid);
		}
	}

	private monitorHealth(humanoid: Humanoid) {
		humanoid.HealthChanged.Connect((newHealth: number) => {
			if (newHealth <= 0 && !this.isDying) {
				this.isDying = true;
				this.playerLives -= 1;
				print(`Player has ${this.playerLives} lives left.`);

				if (this.playerLives <= 0) {
					print("Player has lost all lives.");
					this.livesChanged.Fire(this.playerLives);
					const respawnEnabled = this.playerLives > 0;
					ToggleRespawn.SendToServer(respawnEnabled);
				}
			}
		});
	}
}
