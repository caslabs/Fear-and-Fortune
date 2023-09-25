import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";
import { Signals } from "shared/signals";
interface Attributes {}

@Component({
	tag: "CraftTableStructureTrigger",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class CraftingTableComponent extends BaseComponent<Attributes> implements OnStart {
	constructor() {
		super();
	}
	onStart() {
		print("CraftingTable Object Component Initiated");
		if (this.instance.IsA("Model") && !this.instance.PrimaryPart) {
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart");
			return;
		}
		const prompt = this.attachProximityPrompt();
		this.maid.GiveTask(
			prompt.Triggered.Connect((player) => {
				//Grab CraftingTable
				this.interact(player);
			}),
		);
	}

	attachProximityPrompt() {
		return Make("ProximityPrompt", {
			ObjectText: "Crafting Table",
			ActionText: "Craft",
			Parent: this.instance.IsA("Model") ? this.instance.PrimaryPart : this.instance,
			HoldDuration: 1,
		});
	}

	interact(player: Player) {
		Signals.OpenCraft.Fire();
		print("[CRAFT] Opening CraftingTable");
	}
}
