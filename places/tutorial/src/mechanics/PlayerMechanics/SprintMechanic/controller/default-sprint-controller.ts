/*
TODO: Playtest this mechanic? Default sprint forever.

import { Controller, OnStart, OnInit } from "@flamework/core";
import { ContextActionService, TweenService, Workspace } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";

const camera = Workspace.CurrentCamera!;
const tweenInfo = new TweenInfo(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In);

const sprintMultiplier = 1.45;
const baseSpeed = 16;
const maxSpeed = baseSpeed * sprintMultiplier;
const minSpeed = baseSpeed;

const maxFov = 85;
const minFov = 70;

const startSprintingState = Enum.UserInputState.Begin;
const stopSprintingState = Enum.UserInputState.End;


@Controller({})
export default class SprintController implements OnStart, OnInit {
	private isSprinting = false;

	constructor(private readonly characterController: CharacterController) {}


	public onInit(): void {}

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
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.Humanoid;
		if (!humanoid) return;

		humanoid.WalkSpeed = maxSpeed;
		this.isSprinting = true;
		print("Sprinting");

		this.updateFov(maxFov);
	}

	private stopSprinting() {
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.Humanoid;
		if (!humanoid) return;

		humanoid.WalkSpeed = minSpeed;
		this.isSprinting = false;
		print("Walking");

		this.updateFov(minFov);
	}

	private updateFov(newFov: number) {
		TweenService.Create(camera, tweenInfo, { FieldOfView: newFov }).Play();
	}
}

*/
export {};
