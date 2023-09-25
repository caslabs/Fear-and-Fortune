import { Service, OnStart, OnInit } from "@flamework/core";
import { Players, UserInputService, RunService, ReplicatedStorage, ContextActionService } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import Remotes from "shared/remotes";

@Service({})
export default class CrouchService implements OnInit, OnStart {
	constructor() {}

	onInit(): void {
		print("CrouchService initialized");
	}

	onStart(): void {
		Players.PlayerAdded.Connect((player) => {
			player.SetAttribute("isCrouching", false);
		});

		const isCrouchingEvent = Remotes.Server.Get("IsCrouching");

		isCrouchingEvent.Connect((player: Player, isCrouching: boolean) => {
			// Update the player's crouching state
			player.SetAttribute("isCrouching", isCrouching);
		});

		print("CrouchService started");
	}
}
