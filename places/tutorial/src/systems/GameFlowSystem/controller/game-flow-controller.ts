import { Controller, OnInit, OnStart } from "@flamework/core";
import { UserInputService, ReplicatedStorage } from "@rbxts/services";
import LifeMechanic from "mechanics/PlayerMechanics/LifeMechanic/controller/life-controller";
import { HUDController } from "mechanics/PlayerMechanics/UIMechanic/controller/hud-controller";
import Remotes from "shared/remotes";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";

@Controller()
export default class GameFlowSystemController implements OnInit, OnStart {
	constructor(
		private readonly lifeMechanic: LifeMechanic,
		private readonly hudController: HUDController,
		private readonly musicSystem: MusicSystemController,
	) {} // Inject LifeMechanic

	onInit(): void {}

	onStart(): void {
		print("GameFlowSystem Controller started");

		// Connect to the livesChanged signal
		this.lifeMechanic.livesChanged.Connect((lives) => {
			if (lives <= 0) {
				this.transitionToSpectating();
			}
		});
	}

	private transitionToSpectating() {
		print("Transitioning to spectating...");

		// Spectating Experience
		this.hudController.switchToSpectateHUD();
	}

	private transitionToPlaying() {
		print("Transitioning to playing...");
		//TODO: Somehow the player has more lives...
		// Enable Respawn
		// Transition to PlayHUD()
	}
}
