// client/controller/sanity-mechanic-controller.ts
import { ContextActionService } from "@rbxts/services";
import { Controller, OnInit, OnStart } from "@flamework/core";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";

const DecreaseSanityEvent = Remotes.Client.Get("DecreaseSanityEvent");

@Controller({})
export default class SanityMechanicController implements OnStart, OnInit {
	/** @hidden */
	public onInit(): void {}

	/** @hidden */
	public onStart(): void {
		print("SanityMechanic Controller started");

		//TODO: Spamming H (or updating to the Sanity Component under HUD will lag the player)
		/*
		ContextActionService.BindAction(
			"DecreaseSanity",
			(_, state) => {
				if (state === Enum.UserInputState.Begin) {
					// Fire the DecreaseSanityEvent to the server game state
					DecreaseSanityEvent.SendToServer(Players.LocalPlayer);
				}
			},
			false,
			Enum.KeyCode.H,
		);
		*/
	}
}
