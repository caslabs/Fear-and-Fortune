import { OnStart } from "@flamework/core";
import { Players, Workspace, UserInputService, ContextActionService } from "@rbxts/services";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import Remotes from "shared/remotes";

interface Attributes {}
// Define ToolData for the Rifle
//TODO: Prototype
type ToolData = {
	ammo: number;
	maxAmmo: number;
};
const canteenData: ToolData = {
	ammo: 3, // Change these values as per your needs
	maxAmmo: 3,
};

const PlayGunShakeEvent = Remotes.Server.Get("PlayGunShake");
const ToolPickupEvent = Remotes.Server.Get("ToolPickupEvent");
const ToolRemovedEvent = Remotes.Server.Get("ToolRemovedEvent");
const UpdateAmmoEvent = Remotes.Server.Get("UpdateAmmoEvent");
const AddThirstEvent = Remotes.Server.Get("AddThirst");
// TODO: is this good? Play 3D Spatial Sound
// Broken, only plays once and then never again...
const soundID = "7935556153"; //TODO:
const sound = `rbxassetid://${soundID}`;
const soundInstance = new Instance("Sound");
soundInstance.SoundId = sound;

@Component({
	tag: "CanteenTool",
	instanceGuard: t.instanceIsA("Tool"),
})
export class CanteenComponent extends BaseComponent<Attributes> implements OnStart {
	canteenData: ToolData; // Make rifleData a member variable
	fireConnected: boolean;
	isReleased: boolean;
	timeActivated: number | undefined; // Add this line
	hasDrunk: boolean;
	drinkAfter4Seconds: boolean;

	constructor() {
		super();

		this.canteenData = {
			ammo: 3, // Change these values as per your needs
			maxAmmo: 3,
		};

		this.isReleased = false;

		this.fireConnected = false;

		this.timeActivated = undefined; // And this line

		this.hasDrunk = false;

		this.drinkAfter4Seconds = false;
	}

	onStart() {
		print("Canteen Tool Component Initiated");
		const tool = this.instance as Tool;
		let timeActivated: number;

		tool.GetPropertyChangedSignal("Parent").Connect(() => {
			// If the tool is picked up by a player.
			if (tool.Parent?.IsA("Model") && Players.GetPlayerFromCharacter(tool.Parent as Model)) {
				const player = Players.GetPlayerFromCharacter(tool.Parent as Model);
				if (!player) {
					error("Player not found!");
				}

				// Check if the tool is already in the player's backpack.
				const playerBackpack = player.FindFirstChild("Backpack");
				if (playerBackpack && !playerBackpack.FindFirstChild(tool.Name)) {
					print("Tool is not in the player's backpack.");
					print(playerBackpack?.FindFirstChild(tool.Name));
					// Only send the ToolPickupEvent if the tool is not already in the backpack.
					ToolPickupEvent.SendToPlayer(player, player, tool, this.canteenData);
					UpdateAmmoEvent.SendToPlayer(player, this.canteenData.ammo);
				} else {
					print(playerBackpack?.FindFirstChild(tool.Name));
					print("Tool is already in the player's backpack.");
				}

				// Bind to mouse button 1 for PC users
				if (!this.fireConnected) {
					tool.Activated.Connect(() => {
						this.timeActivated = tick();
						this.isReleased = false;
						this.hasDrunk = false;

						while (!this.isReleased) {
							wait(1); // Wait for 1 second

							const currentTime = tick();
							const holdDuration = currentTime - this.timeActivated;

							if (holdDuration >= 4 && !this.hasDrunk) {
								this.drink(player);
								this.hasDrunk = true;
							}
						}
					});

					tool.Deactivated.Connect(() => {
						this.isReleased = true;

						// Calculate the duration for which the button was held
						const currentTime = tick();
						let holdDuration = 0;

						if (this.timeActivated !== undefined) {
							holdDuration = currentTime - this.timeActivated;
						}

						// Check if the button was held for less than 4 seconds
						if (holdDuration < 4 && !this.hasDrunk) {
							print("Button released too soon! Hold the button for 4 seconds to drink.");
						}
					});

					this.fireConnected = true;
				}
			}
		});
	}

	drink(player: Player) {
		print("Drank!");
		AddThirstEvent.SendToPlayer(player, 30);
	}

	attachTouchFunction(model: Model) {
		print("Canteen Active Initiated");
	}
}
