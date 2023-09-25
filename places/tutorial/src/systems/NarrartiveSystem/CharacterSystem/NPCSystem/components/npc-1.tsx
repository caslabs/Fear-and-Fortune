import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import Make from "@rbxts/make";
import { t } from "@rbxts/t";
import Roact from "@rbxts/roact";
import DialogueBox from "systems/NarrartiveSystem/DialogueSystem/manager/dialogue-box";
import { Players } from "@rbxts/services";

const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

interface Attributes {}
@Component({
	tag: "NPC-1Trigger",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class NPCComponent extends BaseComponent<Attributes> implements OnStart {
	onStart() {
		const agentModel = this.instance as Model;
		const humanoidRootPart = agentModel.FindFirstChild("Torso") as BasePart;
		print("NPC-1 Component Initiated");
		print(`NPC-1 Component Initiated on ${this.instance.Name} (${this.instance.ClassName})`);
		if (!t.instanceIsA("BasePart")(humanoidRootPart)) {
			print("Unable to find HumanoidRootPart in the NPC-1 model");
			return;
		}

		print("Found part:", humanoidRootPart.Name); // Add this line to print the found part's name

		const prompt = this.attachProximityPrompt(humanoidRootPart);
		print(`NPC-1 prompt enabled`);
		this.maid.GiveTask(
			prompt.Triggered.Connect(() => {
				// Trigger Random Dialogue event
				// TODO: design database for random dialogues
				const handle: Roact.Tree = Roact.mount(
					<screengui Key={"DialogueBoxScreen"} IgnoreGuiInset={true} ResetOnSpawn={false}>
						<DialogueBox title={""} description={"Hello, fellow adventurer..."} image={""} />
					</screengui>,
					PlayerGui,
				);
				wait(5);
				Roact.unmount(handle);
			}),
		);
	}

	attachProximityPrompt(humanoidRootPart: BasePart) {
		return Make("ProximityPrompt", {
			ObjectText: "The Stange One",
			ActionText: "Talk",
			Parent: humanoidRootPart,
		});
	}
}
