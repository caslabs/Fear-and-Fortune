import { Controller, OnStart, OnInit } from "@flamework/core";
import { UserInputService, Workspace, Players } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import StaminaController from "./stamina-controller";
import { Signals } from "shared/signals";

const jumpDelay = 3; // Delay between jumps

@Controller({})
export default class JumpController implements OnInit, OnStart {
	private canJump = true; // Can the player jump
	private originalJumpPower: number | undefined;

	constructor(
		private readonly characterController: CharacterController,
		private readonly staminaController: StaminaController,
	) {}

	public onInit(): void {
		Signals.jumpingStateChanged.Connect((isJumping: boolean) => {
			if (isJumping) {
				task.spawn(() => this.staminaController.staminaUpdate(-10)); // Stamina decrease while jumping
			} else {
				task.spawn(() => this.staminaController.staminaUpdate(1)); // Stamina increase while walking
			}
		});
	}

	public onStart(): void {
		print("Stamina Jump Controller started");

		UserInputService.JumpRequest.Connect(() => {
			this.handleJumpRequest();
		});
	}

	private handleJumpRequest() {
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.FindFirstChildOfClass("Humanoid");
		if (!humanoid || !this.canJump) return;

		this.canJump = false; // Disable jumping
		this.originalJumpPower = humanoid.JumpPower;
		humanoid.JumpPower = 11; // Disable JumpPower

		// Handle jump and delay asynchronously
		this.jumpAndDelay(humanoid);
	}

	private async jumpAndDelay(humanoid: Humanoid) {
		// Wait for the jump delay
		await Promise.delay(jumpDelay);

		// Ensure the humanoid and originalJumpPower are still valid
		// eslint-disable-next-line roblox-ts/lua-truthiness
		if (!humanoid || !this.originalJumpPower) return;

		// Enable jumping again
		humanoid.JumpPower = 0; // Disable JumpPower
		this.canJump = true;
	}
}
