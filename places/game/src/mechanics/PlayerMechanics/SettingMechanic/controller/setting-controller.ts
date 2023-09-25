import { Controller, OnInit, OnStart } from "@flamework/core";
import LifeMechanic from "mechanics/PlayerMechanics/LifeMechanic/controller/life-controller";
import { HUDController } from "mechanics/PlayerMechanics/UIMechanic/controller/hud-controller";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";
import { Players } from "@rbxts/services";
const Player = Players.LocalPlayer;

const DEFAULT_SETTING_PROFILE = {
	Audio: {
		Music: 10,
		Ambience: 10,
		Sound: 10,
	},
	//FOV
	Game: {
		FOV: 70,
	},
};

@Controller()
export default class SettingController implements OnInit, OnStart {
	onInit(): void {}

	onStart(): void {
		print("Started setting");
	}

	private loadSettingProfile() {
		print("Transitioning to spectating...");
	}
}
