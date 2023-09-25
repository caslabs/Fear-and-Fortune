import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";
import Remotes from "shared/remotes";
import { Players, Workspace, UserInputService, ContextActionService } from "@rbxts/services";

interface Attributes {}

const PlayGunShakeEvent = Remotes.Server.Get("PlayGunShake");
const ToolPickupEvent = Remotes.Server.Get("ToolPickupEvent");
const ToolRemovedEvent = Remotes.Server.Get("ToolRemovedEvent");
const UpdateAmmoEvent = Remotes.Server.Get("UpdateAmmoEvent");
let activatedConnection: RBXScriptConnection | undefined;

const animationInstance = new Instance("Animation");
animationInstance.AnimationId = "rbxassetid://567480700O";

type ToolData = {
	ammo: number;
	maxAmmo: number;
};

const rifleData: ToolData = {
	ammo: 8, // Change these values as per your needs
	maxAmmo: 8,
};

@Component({
	tag: "AxeTrigger",
	instanceGuard: t.instanceIsA("Model"),
})
export class AxeModelComponent extends BaseComponent<Attributes> implements OnStart {
	constructor(private readonly inventorySystem: InventorySystemService) {
		super();
	}
	attachProximityPrompt() {
		return Make("ProximityPrompt", {
			ObjectText: "Makeshift Axe",
			ActionText: "Grab",
			Parent: this.instance.IsA("Model") ? this.instance.PrimaryPart : this.instance,
			HoldDuration: 1,
		});
	}

	grab(player: Player) {
		print("Axe Tool Component Initiated");
		// Add to inventory
		this.inventorySystem.addItemToInventory(player, "AxeTool");
		this.instance.Destroy();
	}

	onStart() {
		print("Rifle Tool Component Initiated");
		const tool = this.instance as Tool;

		print("Rifle Object Component Initiated");

		if (this.instance.IsA("Model") && !this.instance.PrimaryPart) {
			print("Unable to attach ProximityPrompt to RifleComponent because it has no PrimaryPart");
			return;
		}
		const prompt = this.attachProximityPrompt();
		this.maid.GiveTask(
			prompt.Triggered.Connect((player) => {
				//Grab IronWood
				this.grab(player);
			}),
		);
	}
}
