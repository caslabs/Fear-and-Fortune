import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { Players, RunService, PathfindingService } from "@rbxts/services";
import Remotes from "shared/remotes";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";

interface Attributes {}

//TODO: Find Units - i think its STUDS
const DETECTION_RADIUS = 50;
const PlayLocalSoundEvent = Remotes.Server.Get("PlayLocalSound");
const StopLocalSoundEvent = Remotes.Server.Get("StopLocalSound");

const PlayJumpScareZoomEvent = Remotes.Server.Get("PlayJumpScareZoom");
const StopJumpScareZoomEvent = Remotes.Server.Get("StopJumpScareZoom");
const StartChasingShakeEvent = Remotes.Server.Get("StartChasingShake");
const StopChasingShakeEvent = Remotes.Server.Get("StopChasingShake");

//Events
const DamagePlayerEvent = Remotes.Server.Get("DamagePlayer");
@Component({
	tag: "CROUCH_AI",
})
export class FollowAIComponent extends BaseComponent<Attributes> implements OnStart {
	private isFollowing = false;
	private lastFollowedPlayer: Player | undefined = undefined;
	private killedPlayers: Set<Player> = new Set();

	onStart(): void {
		print("Crouch AI Component Started");
		if (this.instance.IsA("Model") && !this.instance.PrimaryPart) {
			print("Unable to attach ProximityPrompt to Banshee because it has no PrimaryPart");
			return;
		}

		// Start updating path
		RunService.Heartbeat.Connect(() => {
			this.updatePath();
		});

		const humanoid = this.instance.FindFirstChild("Humanoid");
		if (humanoid && humanoid.IsA("Humanoid")) {
			humanoid.Touched.Connect((otherPart) => this.onTouch(otherPart));
			print("Touched Event Connected");
		}
	}

	private onTouch(otherPart: BasePart): void {
		// Find the Player instance associated with the character model
		const character = otherPart.Parent;
		const player = Players.GetPlayerFromCharacter(character);
		if (!player || this.killedPlayers.has(player)) {
			// Ignore if player has already been killed
			return;
		}

		const humanoid = character?.FindFirstChild("Humanoid");
		if (humanoid && humanoid.IsA("Humanoid")) {
			// It's a player! Subtract health.
			print("Killed Player!");
			player?.SetAttribute("LastDamageBy_Crouch", true);
			humanoid.TakeDamage(humanoid.MaxHealth);
			if (humanoid) {
				humanoid.TakeDamage(humanoid.MaxHealth);
				this.killedPlayers.add(player); // Mark player as killed
			}
		}
	}

	// Find the nearest player within a given radius
	private findNearestPlayer(): Player | undefined {
		const npcPosition = (this.instance as Model).PrimaryPart!.Position;

		let closestPlayer: Player | undefined = undefined;
		let closestDistance = DETECTION_RADIUS;

		for (const player of Players.GetPlayers()) {
			// eslint-disable-next-line roblox-ts/lua-truthiness
			if (player.GetAttribute("isCrouching")) {
				//Skip if player is crouching
				continue;
			}

			const character = player.Character;
			if (character) {
				const humanoidRootPart = character.FindFirstChild("HumanoidRootPart");
				if (humanoidRootPart && humanoidRootPart.IsA("BasePart")) {
					const playerPosition = humanoidRootPart.Position;
					const distance = npcPosition.sub(playerPosition).Magnitude;

					if (distance < closestDistance) {
						closestDistance = distance;
						closestPlayer = player;
					}
				}
			}
		}

		// Finite State Player
		if (closestPlayer) {
			if (closestPlayer !== this.lastFollowedPlayer) {
				this.lastFollowedPlayer = closestPlayer;

				if (!this.isFollowing) {
					this.isFollowing = true;
					print("Following");
					PlayLocalSoundEvent.SendToPlayer(closestPlayer, SoundKeys.SFX_CHASING_1, 4);
					PlayJumpScareZoomEvent.SendToPlayer(closestPlayer);
					StartChasingShakeEvent.SendToPlayer(closestPlayer);
				}
			}
		} else {
			if (this.isFollowing && this.lastFollowedPlayer) {
				this.isFollowing = false;
				print("Not Following");
				StopLocalSoundEvent.SendToPlayer(this.lastFollowedPlayer, SoundKeys.SFX_CHASING_1);
				StopJumpScareZoomEvent.SendToPlayer(this.lastFollowedPlayer);
				StopChasingShakeEvent.SendToPlayer(this.lastFollowedPlayer);
				this.lastFollowedPlayer = undefined; // It's important to reset this to undefined
			}
		}

		return closestPlayer;
	}

	// Calculate and update the path for the NPC
	private updatePath() {
		const npcHumanoid = (this.instance as Model).FindFirstChildOfClass("Humanoid");
		const targetPlayer = this.findNearestPlayer();

		if (npcHumanoid && targetPlayer) {
			const character = targetPlayer.Character;
			if (character) {
				const humanoidRootPart = character.FindFirstChild("HumanoidRootPart");
				if (humanoidRootPart && humanoidRootPart.IsA("BasePart")) {
					const path = PathfindingService.CreatePath();
					path.ComputeAsync((this.instance as Model).PrimaryPart!.Position, humanoidRootPart.Position);

					if (path.Status === Enum.PathStatus.Success) {
						const waypoints = path.GetWaypoints();
						npcHumanoid.MoveTo(waypoints[1].Position);
					}
				}
			}
		}
	}
}
