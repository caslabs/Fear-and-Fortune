import { Controller, OnStart, OnInit } from "@flamework/core";
import { UserInputService, Players } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import Signal from "@rbxts/signal";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import { Signals } from "shared/signals";
import Remotes from "shared/remotes";

const MoraleUpdateEvent = Signals.MoraleUpdate;

@Controller({})
export default class MoraleController implements OnStart, OnInit {
	public morale = 0;
	constructor(public readonly characterController: CharacterController) {}

	public onInit(): void {
		/*
		//TODO: Implement this later
		UserInputService.InputBegan.Connect((input) => {
			if (input.KeyCode === Enum.KeyCode.M) {
				this.increaseMorale();
			}
		});

	*/
	}

	public onStart(): void {}

	private async increaseMorale(): Promise<void> {
		this.morale++;
		await this.updateMorale();
		print(`Player ${Players.LocalPlayer.Name}'s morale increased to: ${this.morale}`);
	}

	private async updateMorale(): Promise<void> {
		MoraleUpdateEvent.Fire(Players.LocalPlayer, this.morale);
	}
}
