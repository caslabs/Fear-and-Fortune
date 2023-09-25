import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import Make from "@rbxts/make";
import { t } from "@rbxts/t";
import Roact from "@rbxts/roact";
import DialogueBox from "systems/NarrartiveSystem/DialogueSystem/manager/dialogue-box";
import { Players, RunService } from "@rbxts/services";
import { getIsCurrentlyOpen, setIsCurrentlyOpen } from "ui/Pages/Shop/shop-manager";
import { Signals } from "shared/signals";

const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

interface Attributes {}

@Component({
	tag: "NPC-Merchant",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class NPCComponent extends BaseComponent<Attributes> implements OnStart {
	onStart() {
		const agentModel = this.instance as Model;
		const humanoidRootPart = agentModel.FindFirstChild("Body") as BasePart;
		const bodyGyro = new Instance("BodyGyro");
		bodyGyro.Parent = humanoidRootPart;
		const distanceToLookAtPlayer = 99999999; // Define the distance from which the NPC will start looking at the player

		print("NPC-1 Component Initiated");
		print(`NPC-1 Component Initiated on ${this.instance.Name} (${this.instance.ClassName})`);
		if (!t.instanceIsA("BasePart")(humanoidRootPart)) {
			print("Unable to find HumanoidRootPart in the NPC-1 model");
			return;
		}

		print("Found part:", humanoidRootPart.Name);

		const prompt = this.attachProximityPrompt(humanoidRootPart);
		print(`Merchant prompt enabled`);
		this.maid.GiveTask(
			prompt.Triggered.Connect(() => {
				print("Shop UI triggered");
				if (getIsCurrentlyOpen() === false) {
					Signals.switchToShopHUD.Fire();
					setIsCurrentlyOpen(true);
				}
			}),
		);

		//TODO: Polish the stare behavior
		RunService.Heartbeat.Connect(() => {
			const playerCharacter = Player.Character;
			if (playerCharacter) {
				const playerHumanoidRootPart = playerCharacter.FindFirstChild("HumanoidRootPart");
				if (playerHumanoidRootPart && playerHumanoidRootPart.IsA("BasePart")) {
					const distanceToPlayer = humanoidRootPart.Position.sub(playerHumanoidRootPart.Position).Magnitude;
					if (distanceToPlayer <= distanceToLookAtPlayer) {
						bodyGyro.CFrame = CFrame.lookAt(humanoidRootPart.Position, playerHumanoidRootPart.Position);
					}
				}
			}
		});
	}

	attachProximityPrompt(humanoidRootPart: BasePart) {
		return Make("ProximityPrompt", {
			ObjectText: "The Caregiver",
			ActionText: "Talk",
			Parent: humanoidRootPart,
			MaxActivationDistance: 20,
		});
	}
}
