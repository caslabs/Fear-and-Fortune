import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";

interface Attributes {}

@Component({
	tag: "ChestTrigger",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class ChestComponent extends BaseComponent<Attributes> implements OnStart {
	constructor(private readonly inventorySystem: InventorySystemService) {
		super();
	}

	onStart() {
		print("Chest Object Component Initiated");
		if (this.instance.IsA("Model") && !this.instance.PrimaryPart) {
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart");
			return;
		}
		const prompt = this.attachProximityPrompt();
		this.maid.GiveTask(
			prompt.Triggered.Connect((player) => {
				//Grab Chest
				this.grab(player);
			}),
		);
	}

	attachProximityPrompt() {
		return Make("ProximityPrompt", {
			ObjectText: "Chest",
			ActionText: "Grab",
			Parent: this.instance.IsA("Model") ? this.instance.PrimaryPart : this.instance,
			HoldDuration: 1,
		});
	}

	grab(player: Player) {
		//TODO: Make a better Inventory System
		// This would add "Chest" to ALL players' inventories. Good mechanic?
		this.inventorySystem.addItemToInventory(player, "GoldAmulet");
		print("[INFO] Grabbing Chest");
		this.instance.Destroy();
	}
}
