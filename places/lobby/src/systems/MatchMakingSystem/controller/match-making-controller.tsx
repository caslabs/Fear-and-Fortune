import { Controller, OnStart } from "@flamework/core";
import CameraMechanic from "mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller";
import { HUDController } from "mechanics/PlayerMechanics/UIMechanic/controller/hud-controller";
import { Players, StarterGui, UserInputService, HttpService } from "@rbxts/services";
import { Signals } from "shared/signals";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import Remotes from "shared/remotes";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";
import { MusicData, MusicKeys } from "systems/AudioSystem/MusicSystem/manager/MusicData";
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

@Controller({
	loadOrder: 99999, // Try to make this run last
})
export class EventFlowController implements OnStart {
	// Viva la asynchronous control flow or task-based programming!
	constructor(private readonly hudController: HUDController, private readonly cameraMechanic: CameraMechanic) {}

	onStart(): void {
		print("Match Making Controller started");
	}
}
