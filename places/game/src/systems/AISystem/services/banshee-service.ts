import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { Players, RunService, PathfindingService, Workspace } from "@rbxts/services";
import Remotes from "shared/remotes";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";

interface Attributes {}

//TODO: Find Units - i think its STUDS
const DETECTION_RADIUS = 50;
const PlayLocalSoundEvent = Remotes.Server.Get("PlayLocalSound");
const StopLocalSoundEvent = Remotes.Server.Get("StopLocalSound");

const PlayJumpScareZoomEvent = Remotes.Server.Get("PlayJumpScareZoom");
const StopJumpScareZoomEvent = Remotes.Server.Get("StopJumpScareZoom");
const StartChasingShakeEvent = Remotes.Server.Get("StartChasingShake");
const StopChasingShakeEvent = Remotes.Server.Get("StopChasingShake");

function createPhysicalItem(item: string, position: Vector3) {
	// assuming the item has a Model property that refers to a Roblox model ID
	const model = new Instance("Part");
	model.Parent = Workspace;
	model.Position = position;

	// create and configure the ProximityPrompt for the item
	const prompt = new Instance("ProximityPrompt");
	prompt.ObjectText = item; // assuming the item has a Name property
	prompt.ActionText = "Pick up";
	prompt.Parent = model;

	// return the model and prompt for further use
	return { model, prompt };
}

//Events
const DamagePlayerEvent = Remotes.Server.Get("DamagePlayer");
@Component({
	tag: "Banshee",
})
export class BansheeComponent extends BaseComponent<Attributes> implements OnStart {
	private isFollowing = false;
	private lastFollowedPlayer: Player | undefined = undefined;
	private isDead = false; // Add this line

	constructor(private readonly inventorySystem: InventorySystemService) {
		super();
	}
	onStart(): void {
		print("Banshee Component Started");
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
			humanoid.Died.Connect(() => this.onDeath()); // Listen for the Humanoid.Died event

			print("Touched Event Connected");
		}
	}

	private onTouch(otherPart: BasePart): void {
		const character = otherPart.Parent;
		const humanoid = character?.FindFirstChild("Humanoid");
		if (humanoid && humanoid.IsA("Humanoid")) {
			// It's a player! Subtract health.
			print("Touched Player!");
			humanoid.Health -= 5;

			// Find the Player instance associated with the character model
			const player = Players.GetPlayerFromCharacter(character);

			//Guard - if player is alive, prevent error of fidning attribute of a non-existent player
			// If the player was found, set the attribute
			if (player) {
				// Make sure the player instance is still valid
				if (player.IsA("Player")) {
					player.SetAttribute("LastDamageByBanshee", true);
				}
			}
		}
	}

	// Find the nearest player within a given radius
	private findNearestPlayer(): Player | undefined {
		const npcPosition = (this.instance as Model).PrimaryPart!.Position;

		let closestPlayer: Player | undefined = undefined;
		let closestDistance = DETECTION_RADIUS;

		for (const player of Players.GetPlayers()) {
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
		if (this.isDead) {
			return;
		}

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

	private onDeath(): void {
		print("Banshee Died");
		this.isDead = true; // Add this line
		if (this.lastFollowedPlayer) {
			this.isFollowing = false;
			print("Not Following");
			StopLocalSoundEvent.SendToPlayer(this.lastFollowedPlayer, SoundKeys.SFX_CHASING_1);
			StopJumpScareZoomEvent.SendToPlayer(this.lastFollowedPlayer);
			StopChasingShakeEvent.SendToPlayer(this.lastFollowedPlayer);
			this.lastFollowedPlayer = undefined; // It's important to reset this to undefined
		}

		// Let's drop a loot
		const dropPosition = (this.instance as Model).PrimaryPart!.Position;
		const { model, prompt } = createPhysicalItem("BansheeResidue", dropPosition); // Assuming "BansheeLoot" is the name of the item
		prompt.Triggered.Connect((otherPlayer) => {
			this.inventorySystem.addItemToInventory(otherPlayer, "BansheeResidue", 1);
			model.Destroy();
		});
	}
}
