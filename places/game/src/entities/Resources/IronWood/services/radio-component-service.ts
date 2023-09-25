import { OnStart } from "@flamework/core";
import { Players, Workspace, RunService } from "@rbxts/services";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import TaskSystemService from "systems/TaskSystem/services/task-service";

interface Attributes {}

//TODO: Experimental
@Component({
	tag: "RadioTrigger",
	instanceGuard: t.instanceIsA("Model"),
})
export class RadioComponent extends BaseComponent<Attributes> implements OnStart {
	private staringStartTime: Map<Player, number> = new Map();
	private previousStaringState: Map<Player, boolean> = new Map();
	private players: Player[] = [];
	constructor(private readonly taskSystem: TaskSystemService) {
		super();
	}

	onStart() {
		this.players = Players.GetPlayers(); // Get initial player list
		Players.PlayerAdded.Connect((player) => this.players.push(player)); // Player joins game
		Players.PlayerRemoving.Connect((player) => {
			this.players = this.players.filter((p) => p !== player); // Player leaves game
			this.previousStaringState.delete(player); // Clean up map
			this.staringStartTime.delete(player); // Clean up map
		});

		RunService.Heartbeat.Connect(() => this.update()); // Equivalent to onUpdate
		print("Radio Component Started");
	}

	private update() {
		this.players.forEach((player) => {
			if (player.Character) {
				const head = player.Character.FindFirstChild("Head") as BasePart | undefined;

				if (head) {
					const cameraPosition = head.Position;
					const direction = head.CFrame.LookVector;
					if (cameraPosition && direction) {
						const ray = new Ray(cameraPosition, direction.mul(100)); // Multiply by desired distance
						const ignoreList = [player.Character];
						const params = new RaycastParams();
						params.FilterDescendantsInstances = ignoreList;
						params.FilterType = Enum.RaycastFilterType.Blacklist;
						const result = Workspace.Raycast(ray.Origin, ray.Direction, params);
						if (result && result.Instance.IsDescendantOf(this.instance)) {
							// player is staring at the radio
							if (!this.previousStaringState.get(player)) {
								print("Player is staring at the radio");
								this.previousStaringState.set(player, true);
							}
							if (!this.staringStartTime.has(player)) {
								this.staringStartTime.set(player, tick());
							} else if (tick() - this.staringStartTime.get(player)! >= 10) {
								// player has been staring at the radio for 10 seconds
								print("Radio ACTIVATED");
								this.staringStartTime.delete(player);
								this.taskSystem.startNextObjective();
							}
						} else {
							// player is not staring at the radio
							if (this.previousStaringState.get(player)) {
								print("Player is not staring at the radio");
								this.previousStaringState.set(player, false);
							}
							this.staringStartTime.delete(player);
						}
					} else {
						error("Camera position or direction not found");
					}
				} else {
					error("Head not found");
				}
			} else {
				error("Character not found");
			}
		});
	}
}
