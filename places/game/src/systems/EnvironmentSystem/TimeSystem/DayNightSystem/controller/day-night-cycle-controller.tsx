import { UserInputService, Lighting, Players } from "@rbxts/services";
import { Controller, OnInit, OnStart } from "@flamework/core";
import Roact from "@rbxts/roact";
import DayIndicator from "ui/screens/day-indicator";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import soundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";

const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");
@Controller({})
export class DayNightCycleController implements OnInit, OnStart {
	constructor(private readonly soundSystemController: SoundSystemController) {}
	onInit() {
		print("DayNightCycleController initiated");
	}

	onStart() {
		print("DayNightCycleController started");
		this._handleInput();
	}

	_handleInput() {
		/*
		UserInputService.InputBegan.Connect((input) => {
			if (input.KeyCode === Enum.KeyCode.J) {
				this.startNextDay();
			}
		});
		*/
		print("[DAY CONTROLLER] Added _handleInput");
	}

	public startNextDay() {
		print("[DAY CONTROLLER] Next Day Starting");
		soundSystemController.playSound(SoundKeys.SFX_DAY_1, 10);
		const handle: Roact.Tree = Roact.mount(
			<screengui Key={"LandMarkNotification"} IgnoreGuiInset={true} ResetOnSpawn={false} DisplayOrder={9999999}>
				<DayIndicator title={"Day 1"} />
			</screengui>,
			PlayerGui,
		);

		wait(8.3);
		Roact.unmount(handle);
		soundSystemController.playSound(SoundKeys.SFX_INTRO, 10);
	}
}
