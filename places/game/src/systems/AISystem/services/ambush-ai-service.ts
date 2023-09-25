import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { Players, RunService, PathfindingService, Workspace } from "@rbxts/services";
import Remotes from "shared/remotes";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";

interface Attributes {}

const _SpawnBehindPlayerEvent = Remotes.Server.Get("_SpawnBehindPlayer");

@Component({
	tag: "AMBUSH_AI",
})
export class AmbushAIComponent extends BaseComponent<Attributes> implements OnStart {
	private isRunningAway = false;
	private targetPlayer: Player | undefined = undefined;
	private runningAwayTimer = 0;
	private previousState: string | undefined = undefined;

	onStart(): void {
		print("Ambush AI Component Started");

		//Test to Spawn Behind Player
		_SpawnBehindPlayerEvent.Connect((player) => {
			this.spawnBehindPlayer(player);
			print("[AMBUSH] Spawned success!");
		});

		// Start updating path
		RunService.Heartbeat.Connect((dt) => {
			this.updatePath(dt);
		});
	}

	private spawnBehindPlayer(player: Player): void {
		const character = player.Character;
		const humanoidRootPart = character?.FindFirstChild("HumanoidRootPart");

		if (humanoidRootPart && humanoidRootPart.IsA("BasePart")) {
			const spawnDirection = humanoidRootPart.CFrame.LookVector.mul(-1);
			const spawnDistance = 10; // adjust this to control how far behind the player the AI spawns

			const ray = new Ray(humanoidRootPart.Position, spawnDirection.mul(spawnDistance));
			const [hitPart, hitPosition] = Workspace.FindPartOnRayWithIgnoreList(ray, [this.instance]);

			if (this.instance.IsA("Model") && this.instance.PrimaryPart && hitPosition) {
				this.instance.SetPrimaryPartCFrame(new CFrame(hitPosition));
			}
		}

		this.targetPlayer = player;
		this.isRunningAway = false;
		this.runningAwayTimer = 0;
	}

	private updatePath(dt: number): void {
		const npcHumanoid = (this.instance as Model).FindFirstChildOfClass("Humanoid");
		const player = this.targetPlayer;

		if (npcHumanoid && player) {
			const character = player.Character;
			if (character) {
				const humanoidRootPart = character.FindFirstChild("HumanoidRootPart");
				if (humanoidRootPart && humanoidRootPart.IsA("BasePart")) {
					const path = PathfindingService.CreatePath();

					if (this.isRunningAway) {
						// Run away from the player
						const runAwayDirection = humanoidRootPart.CFrame.LookVector.mul(-1);
						const runAwayDistance = 50; // adjust this to control how far the AI runs away

						path.ComputeAsync(
							(this.instance as Model).PrimaryPart!.Position,
							humanoidRootPart.Position.add(runAwayDirection.mul(runAwayDistance)),
						);
					} else {
						// Chase the player
						path.ComputeAsync((this.instance as Model).PrimaryPart!.Position, humanoidRootPart.Position);
					}

					if (path.Status === Enum.PathStatus.Success) {
						const waypoints = path.GetWaypoints();
						npcHumanoid.MoveTo(waypoints[1].Position);
					}

					// Check if the player is looking at the AI
					const cameraCFrame = Workspace.CurrentCamera?.CFrame;
					if (cameraCFrame) {
						const playerLookVector = cameraCFrame.LookVector;
						const aiToPlayer = humanoidRootPart.Position.sub(
							(this.instance as Model).PrimaryPart!.Position,
						);

						if (aiToPlayer.Unit.Dot(playerLookVector.Unit) > 0) {
							// Player is looking at the AI
							if (!this.isRunningAway) {
								this.isRunningAway = true;
								this.runningAwayTimer = 0; // reset the timer when start running away
								if (this.previousState !== "runningAway") {
									print("[AMBUSH] Is Running Away"); // print the message when it starts running away
									this.previousState = "runningAway";
								}
							} else {
								this.runningAwayTimer += dt; // update the timer
								if (this.runningAwayTimer >= 3) {
									this.instance.Destroy(); // destroy the AI after 3 seconds of running away
								}
							}

							// Run away from the player directly
							const runAwayDirection = humanoidRootPart.CFrame.LookVector.mul(-1);
							const runAwayDistance = 5; // adjust this to control how far the AI runs away
							const runAwayPosition = (this.instance as Model).PrimaryPart!.Position.add(
								runAwayDirection.mul(runAwayDistance),
							);
							npcHumanoid.MoveTo(runAwayPosition);
						} else {
							// Player is not looking at the AI
							if (this.isRunningAway) {
								if (this.previousState !== "chasing") {
									print("[AMBUSH] Is Chasing"); // print the message when it starts chasing
									this.previousState = "chasing";
								}
							}
							this.isRunningAway = false;

							// Chase the player directly
							npcHumanoid.MoveTo(humanoidRootPart.Position);
						}
					}
				}
			}
		}
	}
}
