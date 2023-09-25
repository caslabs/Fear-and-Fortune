/*
import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import { Players } from "@rbxts/services";
import { AIJumpscareManager } from "shared/AISystem/AIManager/Enemies/AIJumpscareManager";
import PlayerStateController from "mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/character-states-controller";
import { AIPsychologicalManager } from "shared/AISystem/AIManager/Enemies/AIPsychologicalManager";

interface Attributes {}


@Component({
	tag: "PSYCHOLOGICAL_AI",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class EnemyComponent extends BaseComponent<Attributes> implements OnStart {
	constructor(private readonly playerStateController: PlayerStateController) {
		super();
	}

	onStart() {
		print("ENEMY Component Initiated");
		print(`ENEMY Component Initiated on ${this.instance.Name} (${this.instance.ClassName})`);

		const agentModel = this.instance as Model;
		if (agentModel && agentModel.FindFirstChildOfClass("Humanoid")) {
			print("AIJumpscare Test");
			const aiJumpscareManager = AIPsychologicalManager.getInstance(this.playerStateController); // Use AIJumpscareManager
			aiJumpscareManager.createJumpscareAgent(agentModel); // Use createChaser method from AIJumpscareManager
			print("Executed Jumpscare Agent Brain!");
		} else {
			print("Unable to find Model with Humanoid");
		}
	}
}
*/
export {};
