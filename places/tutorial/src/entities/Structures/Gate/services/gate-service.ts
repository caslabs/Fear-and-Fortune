import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import { Players, ReplicatedStorage } from "@rbxts/services";
import { RunService } from "@rbxts/services";
import Make from "@rbxts/make";

interface Attributes {}

//TODO: Refactor this to be a generic door component
@Component({
	tag: "Gate",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class GateComponent extends BaseComponent<Attributes> implements OnStart {
	onStart() {
		print("Gate Component Initiated");
		if (this.instance.IsA("Model") && !this.instance.PrimaryPart) {
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart");
			return;
		}
		const prompt = this.attachProximityPrompt();
		this.maid.GiveTask(
			prompt.Triggered.Connect((player) => {
				//Open Door
				this.moveDoor();
			}),
		);
	}

	attachProximityPrompt() {
		return Make("ProximityPrompt", {
			ObjectText: "Gate",
			ActionText: "Open",
			Parent: this.instance.IsA("Model") ? this.instance.PrimaryPart : this.instance,
		});
	}

	moveDoor() {
		print("[INFO] Attempting to move door");
		if (this.instance.IsA("Model") && (this.instance as Model).PrimaryPart) {
			const primaryPart = (this.instance as Model).PrimaryPart as BasePart;
			primaryPart.Anchored = false;
			primaryPart.SetNetworkOwner();
			RunService.Heartbeat.Connect(() => {
				primaryPart.Position = primaryPart.Position.add(new Vector3(0, 0, 0.1));
			});
			print("[INFO] Moving Door");
		} else if (this.instance.IsA("BasePart")) {
			const basePart = this.instance as BasePart;
			basePart.Anchored = false;
			basePart.SetNetworkOwner();
			RunService.Heartbeat.Connect(() => {
				basePart.Position = basePart.Position.add(new Vector3(0, 0, 0.1));
			});
			print("[INFO] Moving Door2");
		}
	}
}
