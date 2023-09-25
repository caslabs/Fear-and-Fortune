import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import { Players, ReplicatedStorage } from "@rbxts/services";
import { RunService } from "@rbxts/services";
import Make from "@rbxts/make";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";

interface Attributes {}

@Component({
	tag: "LadderTrigger",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class LadderComponent extends BaseComponent<Attributes> implements OnStart {
	constructor(private readonly inventorySystem: InventorySystemService) {
		super();
	}
	onStart() {
		print("Ladder Structure Component Initiated");
		if (this.instance.IsA("Model") && !this.instance.PrimaryPart) {
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart");
			return;
		}
		const prompt = this.attachProximityPrompt();
		this.maid.GiveTask(
			prompt.Triggered.Connect((player) => {
				//Place Down
				this.placeDown(player);
			}),
		);
	}

	attachProximityPrompt() {
		return Make("ProximityPrompt", {
			ObjectText: "Place Down Ladder",
			ActionText: "Place Down",
			Parent: this.instance.IsA("Model") ? this.instance.PrimaryPart : this.instance,
			HoldDuration: 5,
		});
	}

	placeDown(player: Player) {
		// eslint-disable-next-line roblox-ts/lua-truthiness
		if (!this.inventorySystem.checkItemInInventory(player, "Ladder")) {
			print(`Player ${player.Name} does not have a ladder in their inventory`);
			return;
		}

		print("Attempting to place down ladder");

		// Must have Ladder instance under the LadderTrigger
		const ladder = this.instance.FindFirstChild("Ladder");

		if (ladder && ladder.IsA("BasePart")) {
			//TODO: Make a better inventory system
			// Remove ladder from the player's inventory, for ALL players
			this.inventorySystem.removeItemFromInventory(player, "Ladder");

			// Make Ladder appear
			ladder.CanCollide = true;
			ladder.Transparency = 0;
			print("[INFO] Ladder placed down");
			// TODO: is this good? Play 3D Spatial Sound
			// Broken, only plays once and then never again...
			const sound = "9114154635";
			const soundInstance = Make("Sound", {
				SoundId: `rbxassetid://${sound}`,
				Parent: ladder,
				Volume: 1,
				MaxDistance: 25,
				RollOffMode: Enum.RollOffMode.InverseTapered,
			});
			soundInstance.Play();
		} else {
			print("Could not find ladder");
		}
	}
}
