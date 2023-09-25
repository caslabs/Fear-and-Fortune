import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";

interface Attributes {}

const AddExposureEvent = Remotes.Server.Get("AddExposure"); // Add this line
@Component({
	tag: "CampFireTrigger",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class CampFireComponent extends BaseComponent<Attributes> implements OnStart {
	private debounce = false;
	private playersInProximity: Set<Player> = new Set(); // add this line

	onStart() {
		if (this.instance.IsA("Model") && !this.instance.PrimaryPart) {
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart");
			return;
		}

		const part = this.instance as Model;

		const radius = new Instance("NumberValue");
		radius.Value = 10;
		radius.Name = "Radius";
		radius.Parent = part;

		const proximityPart = new Instance("Part");
		proximityPart.Name = "ProximityPart";
		proximityPart.Anchored = true;
		proximityPart.CanCollide = false;
		proximityPart.Transparency = 1;
		proximityPart.Shape = Enum.PartType.Cylinder;
		proximityPart.Orientation = new Vector3(0, 0, 90);
		proximityPart.Size = new Vector3(radius.Value * 2, radius.Value * 2, radius.Value * 2);
		proximityPart.Position = part.PrimaryPart!.Position;
		proximityPart.Parent = part;
		proximityPart.Touched.Connect((hit) => this.playerEntered(hit));
		proximityPart.TouchEnded.Connect((hit) => this.playerLeft(hit));

		print("CampFireComponent initialized");
	}

	playerEntered(hit: BasePart) {
		if (this.debounce) return;
		this.debounce = true;
		const character = hit.Parent;
		const player = Players.GetPlayerFromCharacter(character);
		if (player && !this.playersInProximity.has(player)) {
			this.playersInProximity.add(player);
			print(`${player.Name} entered the radius.`);
			AddExposureEvent.SendToPlayer(player, true);
		}
		this.debounce = false;
	}

	playerLeft(hit: BasePart) {
		if (this.debounce) return;
		this.debounce = true;
		const character = hit.Parent;
		const player = Players.GetPlayerFromCharacter(character);
		if (player && this.playersInProximity.has(player)) {
			this.playersInProximity.delete(player);
			print(`${player.Name} left the radius.`);
			AddExposureEvent.SendToPlayer(player, false);
		}
		this.debounce = false;
	}
}
