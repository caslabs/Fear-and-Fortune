import { Controller, OnStart, OnInit } from "@flamework/core";
import { ContextActionService } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";

//TODO: Is Self Damage a useful mechanic?
@Controller({})
export default class SelfDamageController implements OnInit, OnStart {
	//TODO: Of course, the player shouldn't damage themselves, but this is just a handler to other mechanics
	private actionName = "DamageSelf";

	constructor(private readonly characterController: CharacterController) {}

	onInit(): void {
		print("SelfDamageController initialized");
	}

	onStart(): void {
		print("SelfDamageController started");
		//ContextActionService.BindAction(this.actionName, (_, state) => this.handleInput(state), false, Enum.KeyCode.G);

		this.characterController.onCharacterAdded.Connect((character) => this.bindToDamageSelf(character));
		this.characterController.onCharacterRemoved.Connect(() => this.unbindFromDamageSelf());
	}

	private handleInput(state: Enum.UserInputState) {
		if (state !== Enum.UserInputState.Begin) {
			return;
		}

		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.FindFirstChildOfClass("Humanoid");

		if (humanoid) {
			humanoid.Health -= 10;
		}
	}

	private bindToDamageSelf(character: Model) {
		this.unbindFromDamageSelf();
		ContextActionService.BindAction(this.actionName, (_, state) => this.handleInput(state), false, Enum.KeyCode.G);
	}

	private unbindFromDamageSelf() {
		ContextActionService.UnbindAction(this.actionName);
	}
}
