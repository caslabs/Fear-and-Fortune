import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";

interface Attributes {}

@Component({
	tag: "CrateTrigger",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class CrateComponent extends BaseComponent<Attributes> implements OnStart {
	constructor(private readonly inventorySystem: InventorySystemService) {
		super();
	}

	onStart() {
		print("Crate Object Component Initiated");
		if (this.instance.IsA("Model") && !this.instance.PrimaryPart) {
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart");
			return;
		}
		const prompt = this.attachProximityPrompt();
		this.maid.GiveTask(
			prompt.Triggered.Connect((player) => {
				//Grab Crate
				this.grab(player);
			}),
		);
	}

	attachProximityPrompt() {
		return Make("ProximityPrompt", {
			ObjectText: "Crate",
			ActionText: "Grab",
			Parent: this.instance.IsA("Model") ? this.instance.PrimaryPart : this.instance,
			HoldDuration: 1,
		});
	}

	grab(player: Player) {
		//TODO: Need a Energy System - Food / Water ?
		this.inventorySystem.addItemToInventory(player, "Berry");
		print("[INFO] Grabbing Crate");
		this.instance.Destroy();
	}
}
