import { OnStart } from "@flamework/core";
import { Players, Workspace, UserInputService, ContextActionService, RunService } from "@rbxts/services";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import Roact from "@rbxts/roact";
import DrinkBar from "ui/components/drink-bar";
import { Signals } from "shared/signals";
interface Attributes {}
// Define ToolData for the Rifle
//TODO: Prototype

const animationInstance = new Instance("Animation");
animationInstance.AnimationId = "rbxassetid://14299421654";
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

@Component({
	tag: "CanteenToolTriggerController",
	instanceGuard: t.instanceIsA("Tool"),
})
export class CanteenToolTrigger extends BaseComponent<Attributes> implements OnStart {
	holdStartTick?: number;
	holdDurationTimer?: RBXScriptConnection;

	onStart() {
		print("Canteen Tool Controller Component Initiated");
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

		const handle: Roact.Tree = Roact.mount(
			<screengui Key={"DrinkBarScreen"} IgnoreGuiInset={true} ResetOnSpawn={false} DisplayOrder={-999}>
				<DrinkBar durationD={0} isVisible={false} />
			</screengui>,
			PlayerGui,
		);

		tool.Equipped.Connect(() => {
			print("Tool Equipped");
			Signals.showDrinkBar.Fire(true);
		});

		tool.Activated.Connect(() => {
			Signals.showDrinkBar.Fire(true);
			print("Tool Activated Locally");
			this.holdStartTick = tick();
			animationTrack?.Play();

			this.holdDurationTimer = RunService.Heartbeat.Connect(() => {
				const holdDuration = tick() - (this.holdStartTick ?? 0);
				const normalizedDuration = math.clamp(holdDuration / 4, 0, 1) * 100;
				Signals.updateDrinkBar.Fire(normalizedDuration);
			});
		});

		tool.Deactivated.Connect(() => {
			print("Tool Deactivated Locally");
			this.holdDurationTimer?.Disconnect();
			Signals.updateDrinkBar.Fire(0);
			Signals.showDrinkBar.Fire(false);
			animationTrack?.Stop();
		});

		tool.Unequipped.Connect(() => {
			print("Tool Unequipped");
			Signals.showDrinkBar.Fire(false);
			animationTrack?.Stop();
		});
	}
}
