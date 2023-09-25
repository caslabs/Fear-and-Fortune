import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import { Players, Workspace } from "@rbxts/services";
import { RunService, DataStoreService } from "@rbxts/services";
import Make from "@rbxts/make";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";
import ProfileService from "@rbxts/profileservice";

//TODO: Test if successful_expeditions is counted
interface ProfileData {
	successful_expeditions: number;
}

const profileTemplate: ProfileData = {
	successful_expeditions: 0,
};

//TODO: Test if new datastore works
const profileStore = ProfileService.GetProfileStore<ProfileData>("PlayerData", profileTemplate);

interface Attributes {}
//TODO: Test if successful_expeditions is counted
@Component({
	tag: "ExitPortalPlacementTrigger",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class ExitPortalActivationComponent extends BaseComponent<Attributes> implements OnStart {
	//TODO: Check if this datastore works
	private ExpeditionData = DataStoreService.GetOrderedDataStore("ExpeditionLeaderboard");

	constructor(private readonly inventorySystem: InventorySystemService) {
		super();
	}
	onStart() {
		print("ExitPortalActivation Structure Component Initiated");
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
			ObjectText: "Activate Exit Portal",
			ActionText: "Perform Ritual",
			Parent: this.instance.IsA("Model") ? this.instance.PrimaryPart : this.instance,
			HoldDuration: 5,
		});
	}

	placeDown(player: Player) {
		// eslint-disable-next-line roblox-ts/lua-truthiness
		if (!this.inventorySystem.checkItemInInventory(player, "CultRune")) {
			//TODO: Inform audio and visual que to player
			print(`Player ${player.Name} does not have a CultRune in their inventory`);
			return;
		}

		print("Attempting to place down ExitPortalActivation");

		// Must have ExitPortalActivation instance under the ExitPortalActivationTrigger
		const ExitPortalActivation = this.instance.FindFirstChild("ExitPortalBase");

		if (ExitPortalActivation && ExitPortalActivation.IsA("BasePart")) {
			//TODO: Make a better inventory system
			// Remove ExitPortalActivation from the player's inventory, for ALL players
			this.inventorySystem.removeItemFromInventory(player, "CultRune");

			// Make ExitPortalActivation Appear
			ExitPortalActivation.CanCollide = true;
			ExitPortalActivation.Transparency = 0;

			//Put ExitPortal from Workspace ontop of ExitPortalActivation
			const ExitPortal = Workspace.FindFirstChild("ExitPortal")?.Clone();

			//TODO: Apparently i need to recraete our Exit Portal Trigger?
			if (ExitPortal && ExitPortal.IsA("Model")) {
				ExitPortal.Parent = ExitPortalActivation;

				//Place 5 studs on top of ExitPortal
				ExitPortal.SetPrimaryPartCFrame(ExitPortalActivation.CFrame.add(new Vector3(0, 5, 0)));
			} else {
				warn("Could not find ExitPortal");
			}

			print("[INFO] ExitPortalActivation placed down");

			// TODO: is this good? Play 3D Spatial Sound
			// Broken, only plays once and then never again...
			const soundID = "13983704227";
			const sound = `rbxassetid://${soundID}`;
			const soundInstance = new Instance("Sound");
			soundInstance.SoundId = sound;
			soundInstance.Parent = ExitPortalActivation;
			soundInstance.Volume = 7;
			soundInstance.MaxDistance = 10;
			soundInstance.Play();
		} else {
			print("Could not find ExitPortalActivation");
		}
	}
}
