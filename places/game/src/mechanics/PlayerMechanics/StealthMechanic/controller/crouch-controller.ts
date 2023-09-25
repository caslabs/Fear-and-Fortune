import { Controller, OnStart, OnInit } from "@flamework/core";
import { UserInputService, RunService, ReplicatedStorage, ContextActionService } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import Remotes from "shared/remotes";

const isCrouchingEvent = Remotes.Client.Get("IsCrouching");
@Controller({})
export default class CrouchController implements OnInit, OnStart {
	private canCrawl = false;
	private animPlay?: AnimationTrack;

	constructor(private readonly characterController: CharacterController) {}

	onInit(): void {
		print("CrouchController initialized");
	}

	onStart(): void {
		print("CrouchController started");

		const character = this.characterController.getCurrentCharacter();
		const animation = ReplicatedStorage.FindFirstChild("Crawl") as Animation;
		const hum = character!.FindFirstChildOfClass("Humanoid");
		if (hum) {
			this.animPlay = hum.LoadAnimation(animation!);
		}

		ContextActionService.BindAction("Crouch", (_, state) => this.handleInput(state), false, Enum.KeyCode.C);
	}

	private handleInput(state: Enum.UserInputState) {
		if (state === Enum.UserInputState.Begin) {
			this.startCrouch();
		} else if (state === Enum.UserInputState.End) {
			this.stopCrouch();
		}
	}

	private startCrouch() {
		const character = this.characterController.getCurrentCharacter();
		const hum = character!.FindFirstChildOfClass("Humanoid");
		if (hum) {
			this.canCrawl = true;
			hum.HipHeight = 1;
			hum.WalkSpeed = 7;
			hum.JumpPower = 0;
			this.animPlay?.Play();
			print("Crouch");
			isCrouchingEvent.SendToServer(true);
		}
	}

	private stopCrouch() {
		const character = this.characterController.getCurrentCharacter();
		const hum = character!.FindFirstChildOfClass("Humanoid");
		if (hum) {
			this.canCrawl = false;
			hum.HipHeight = 2;
			hum.WalkSpeed = 14;
			hum.JumpPower = 50;
			this.animPlay?.Stop();
			print("No Crouch");
			isCrouchingEvent.SendToServer(false);
		}
	}
}
