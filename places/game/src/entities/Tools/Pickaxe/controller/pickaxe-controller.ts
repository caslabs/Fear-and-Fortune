import { OnStart } from "@flamework/core";
import { Players, Workspace, UserInputService, ContextActionService } from "@rbxts/services";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";

interface Attributes {}
// Define ToolData for the Rifle
//TODO: Prototype

const animationInstance = new Instance("Animation");
animationInstance.AnimationId = "rbxassetid://14314972060";

@Component({
	tag: "PickaxeToolTriggerController",
	instanceGuard: t.instanceIsA("Tool"),
})
export class PickaxeToolTrigger extends BaseComponent<Attributes> implements OnStart {
	onStart() {
		print("Pickaxe Tool Controller Component Initiated");
		const tool = this.instance as Tool;
		const player = Players.LocalPlayer;
		let animationTrack: AnimationTrack;

		const humanoid = player.Character?.FindFirstChildOfClass("Humanoid");
		if (humanoid) {
			const animator = humanoid.FindFirstChildOfClass("Animator");
			if (animator) {
				animationTrack = animator.LoadAnimation(animationInstance);
			}
		}

		tool.Equipped.Connect(() => {
			print("Tool Equipped");
			animationTrack.Play();
		});

		tool.Unequipped.Connect(() => {
			print("Tool Unequipped");
			animationTrack.Stop();
		});
	}
}
