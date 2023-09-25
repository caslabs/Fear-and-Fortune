import { Controller, OnStart, OnInit } from "@flamework/core";
import { ContextActionService, TweenService, Workspace, Players } from "@rbxts/services";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import Signal from "@rbxts/signal";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import { Signals } from "shared/signals";
import Remotes from "shared/remotes";

const PlayerDeathSurvivalEvent = Remotes.Client.Get("PlayerDeathSurvival");
const AddThirstEvent = Remotes.Client.Get("AddThirst");
const AddExposureEvent = Remotes.Client.Get("AddExposure"); // Add this line

@Controller({})
export default class SurvivalController implements OnStart, OnInit {
	public maxHunger = 100;
	public hunger = this.maxHunger;
	public maxThirst = 100;
	public thirst = this.maxThirst;
	public maxExposure = 100;
	public exposure = this.maxExposure;
	public maxValues = {
		hunger: this.maxHunger,
		thirst: this.maxThirst,
		exposure: this.maxExposure,
	};

	public startTimes = {
		hunger: tick(),
		thirst: tick(),
		exposure: tick(),
	};

	public isNearHeatedSource = false;
	// Time for full depletion in seconds
	public fullDepletionTime = {
		hunger: 1800,
		thirst: 1200,
		exposure: 300,
	};

	// Harm variables
	public harmInterval = 5; // Harm every 5 seconds
	public harmAmount = 10; // Remove 10 health points

	constructor(public readonly characterController: CharacterController) {}

	public onInit(): void {}

	public onStart(): void {
		task.spawn(() => this.depleteStat("hunger"));
		task.spawn(() => this.depleteStat("thirst"));
		task.spawn(() => this.depleteStat("exposure"));

		AddThirstEvent.Connect((amount: number) => {
			this.thirst += amount;
			if (this.thirst > this.maxThirst) {
				this.thirst = this.maxThirst;
			}
			// Reset the start time for thirst
			this.startTimes.thirst = tick();
			Signals.ThirstUpdate.Fire(Players.LocalPlayer, this.thirst);
		});

		AddExposureEvent.Connect((isHeated: boolean) => {
			this.isNearHeatedSource = isHeated;
			// Update the start time for exposure
			this.startTimes.exposure = tick();
		});
	}

	public async depleteStat(stat: "hunger" | "thirst" | "exposure"): Promise<void> {
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.FindFirstChildOfClass("Humanoid");

		while (humanoid && humanoid.Health > 0) {
			const elapsedTime = tick() - this.startTimes[stat];

			if (stat === "exposure" && this.isNearHeatedSource) {
				this.exposure += (0.1 / this.fullDepletionTime[stat]) * this.maxExposure;
				if (this.exposure > this.maxExposure) {
					this.exposure = this.maxExposure;
				}
			} else {
				this[stat] = this.maxValues[stat] - (elapsedTime / this.fullDepletionTime[stat]) * this.maxValues[stat];
				if (this[stat] < 0) {
					this[stat] = 0;
				}
			}

			if (this[stat] <= 0) {
				humanoid.Health -= this.harmAmount;
				if (humanoid.Health <= 0) {
					print(`${Players.LocalPlayer.Name} died from ${stat}.`);
					PlayerDeathSurvivalEvent.SendToServer();
					break;
				}
			}

			if (stat === "hunger") {
				Signals.HungerUpdate.Fire(Players.LocalPlayer, this.hunger);
			} else if (stat === "thirst") {
				Signals.ThirstUpdate.Fire(Players.LocalPlayer, this.thirst);
			} else if (stat === "exposure") {
				Signals.ExposureUpdate.Fire(Players.LocalPlayer, this.exposure);
			}

			await Promise.delay(0.1);
		}
	}

	private async harmPlayer(): Promise<void> {
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.FindFirstChildOfClass("Humanoid");
		while (humanoid && humanoid.Health > 0) {
			humanoid.Health -= this.harmAmount;
			if (humanoid.Health <= 0) {
				print(`${Players.LocalPlayer.Name} died from thirst, hunger, or exposure.`);
				PlayerDeathSurvivalEvent.SendToServer();
				break;
			}

			await Promise.delay(this.harmInterval);
		}
	}
}
