import { Controller, OnStart, OnInit } from "@flamework/core";
import { ContextActionService, Players } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import Remotes from "shared/remotes";

//TODO: Is Self Damage a useful mechanic?

const _SpawnBehindPlayerEvent = Remotes.Client.Get("_SpawnBehindPlayer");
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
		//ContextActionService.BindAction(this.actionName, (_, state) => this.handleInput(state), false, Enum.KeyCode.V);

		this.characterController.onCharacterAdded.Connect((character) => this.bindToDamageSelf(character));
		this.characterController.onCharacterRemoved.Connect(() => this.unbindFromDamageSelf());
	}

	private handleInput(state: Enum.UserInputState) {
		if (state !== Enum.UserInputState.Begin) {
			return;
		}

		_SpawnBehindPlayerEvent.SendToServer(Players.LocalPlayer);
		print("[AMBUSH] Spawned behind player!");
	}

	private bindToDamageSelf(character: Model) {
		this.unbindFromDamageSelf();
		ContextActionService.BindAction(this.actionName, (_, state) => this.handleInput(state), false, Enum.KeyCode.G);
	}

	private unbindFromDamageSelf() {
		ContextActionService.UnbindAction(this.actionName);
	}
}
