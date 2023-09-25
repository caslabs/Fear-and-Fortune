import { OnStart } from "@flamework/core";
import { Players, Workspace, UserInputService, ContextActionService } from "@rbxts/services";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import Remotes from "shared/remotes";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";

interface Attributes {}
// Define ToolData for the Rifle
//TODO: Prototype
type ToolData = {
	ammo: number;
	maxAmmo: number;
};
const canteenData: ToolData = {
	ammo: 3, // Change these values as per your needs
	maxAmmo: 3,
};

const PlayGunShakeEvent = Remotes.Server.Get("PlayGunShake");
const ToolPickupEvent = Remotes.Server.Get("ToolPickupEvent");
const ToolRemovedEvent = Remotes.Server.Get("ToolRemovedEvent");
const UpdateAmmoEvent = Remotes.Server.Get("UpdateAmmoEvent");
const AddThirstEvent = Remotes.Server.Get("AddThirst");
// TODO: is this good? Play 3D Spatial Sound
// Broken, only plays once and then never again...
const soundID = "7935556153"; //TODO:
const sound = `rbxassetid://${soundID}`;
const soundInstance = new Instance("Sound");
soundInstance.SoundId = sound;

const animationInstance = new Instance("Animation");
animationInstance.AnimationId = "rbxassetid://567480700O";

const treeHitSound = new Instance("Sound");
treeHitSound.SoundId = "rbxassetid://159798370";
treeHitSound.Volume = 10;
treeHitSound.RollOffMaxDistance = 10;

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

@Component({
	tag: "AxeToolTriggerService",
	instanceGuard: t.instanceIsA("Tool"),
})
export class AxeService extends BaseComponent<Attributes> implements OnStart {
	canteenData: ToolData; // Make rifleData a member variable
	fireConnected: boolean;
	isReleased: boolean;

	//cooldown mechanic
	private lastSwing: number;
	private swingCooldown: number;

	constructor(private readonly inventorySystem: InventorySystemService) {
		super();

		this.canteenData = {
			ammo: 3, // Change these values as per your needs
			maxAmmo: 3,
		};

		this.isReleased = false;

		this.fireConnected = false;

		this.lastSwing = 0;
		this.swingCooldown = 1;
	}

	onStart() {
		print("Axe Tool Component Initiated");
		const tool = this.instance as Tool;
		let timeActivated: number;

		tool.GetPropertyChangedSignal("Parent").Connect(() => {
			// Loop through all the parts of the tool and set CanCollide to false
			for (const part of tool.GetDescendants()) {
				if (part.IsA("BasePart")) {
					part.CanCollide = false;
				}
			}

			// If the tool is picked up by a player.
			if (tool.Parent?.IsA("Model") && Players.GetPlayerFromCharacter(tool.Parent as Model)) {
				const player = Players.GetPlayerFromCharacter(tool.Parent as Model);
				if (!player) {
					error("Player not found!");
				}

				// Check if the tool is already in the player's backpack.
				const playerBackpack = player.FindFirstChild("Backpack");
				if (playerBackpack && !playerBackpack.FindFirstChild(tool.Name)) {
					print("Tool is not in the player's backpack.");
					print(playerBackpack?.FindFirstChild(tool.Name));
					// Only send the ToolPickupEvent if the tool is not already in the backpack.
					ToolPickupEvent.SendToPlayer(player, player, tool, this.canteenData);
					UpdateAmmoEvent.SendToPlayer(player, this.canteenData.ammo);
				} else {
					print(playerBackpack?.FindFirstChild(tool.Name));
					print("Tool is already in the player's backpack.");
				}

				// Bind to mouse button 1 for PC users
				if (!this.fireConnected) {
					tool.Activated.Connect(() => {
						const timeActivated = tick(); // Record the time when the tool is activated
						this.swing(player);
					});

					this.fireConnected = true;
				}
			}
		});
	}

	swing(player: Player) {
		const currentTime = tick();
		//cooldown check
		if (currentTime - this.lastSwing < this.swingCooldown) {
			print("Cooldown");
			return;
		}

		//Update the last swing
		this.lastSwing = currentTime;
		print("Swing Cooldown: ", this.lastSwing);

		//Load Animation onto Player
		const humanoid = player.Character?.FindFirstChildOfClass("Humanoid");
		if (humanoid) {
			const animator = humanoid.FindFirstChildOfClass("Animator");
			if (animator) {
				const animationTrack = animator.LoadAnimation(animationInstance);
				animationTrack.Play();
				print("SWING BABY SWING");
			}
		}

		const tool = this.instance as Tool;
		const hitbox = tool.FindFirstChild("Hitbox") as Part;
		if (hitbox) {
			this.checkCollision(hitbox);
		}

		print("Swing!");
	}

	checkCollision(hitbox: Part) {
		// Get the size of the hitbox
		const size = hitbox.Size;

		// Get the CFrame of the hitbox
		const cframe = hitbox.CFrame;

		// Create the OverlapParams
		const overlapParams = new OverlapParams();
		overlapParams.FilterType = Enum.RaycastFilterType.Blacklist;
		overlapParams.FilterDescendantsInstances = [this.instance]; // Ignore the tool itself
		overlapParams.MaxParts = math.huge;

		// Get all parts in the Overlap space
		const parts = Workspace.GetPartsInPart(hitbox, overlapParams);

		for (const part of parts) {
			// Make sure the part is not part of the tool
			if (part.Parent !== this.instance.Parent) {
				// The part belongs to another player, so it was touched by the hitbox
				print(part.Name + " was touched by the hitbox");
				//get position

				//IronWoodTree
				if (part.Name === "IronWoodTree") {
					const item = "IronWood";
					const ironWoodPart = part as Part;
					const dropRadius = 5; // radius around the player's death position where items will be dropped

					const soundID = "159798328";
					const sound = `rbxassetid://${soundID}`;
					const soundInstance = new Instance("Sound");
					soundInstance.SoundId = sound;
					soundInstance.Parent = this.instance;
					soundInstance.Volume = 7;
					soundInstance.MaxDistance = 10;
					soundInstance.Play();

					// eslint-disable-next-line roblox-ts/lua-truthiness
					if (!part.GetAttribute("hitCount")) {
						part.SetAttribute("hitCount", 1);
					} else {
						// Increment the hit count
						let currentHitCount = part.GetAttribute("hitCount") as number;
						part.SetAttribute("hitCount", ++currentHitCount);
						treeHitSound.Play();
						print("Hit Count: ", part.GetAttribute("hitCount") as number);

						// Check if hit count is enough to destroy the tree
						if ((part.GetAttribute("hitCount") as number) >= 3) {
							// Your drop items code...
							for (let i = 0; i < 3; i++) {
								// calculate a random position around the player to drop the item
								const dropPosition = ironWoodPart.Position.add(
									new Vector3(
										math.random() * dropRadius - dropRadius / 2,
										0,
										math.random() * dropRadius - dropRadius / 2,
									),
								);

								// create the physical item
								const { model, prompt } = createPhysicalItem(item, dropPosition);

								// connect the trigger to the prompt
								prompt.Triggered.Connect((otherPlayer) => {
									this.inventorySystem.addItemToInventory(otherPlayer, item); // assuming the item has a Name property
									model.Destroy();
								});
							}
							// Destroy the part
							part.Destroy();
						}
					}
				}

				//Wood
				if (part.Name === "WoodTree") {
					const item = "Wood";
					const woodPart = part as Part;
					const leafPart = part as Part;
					const leafItem = "Leaf";
					const dropRadius = 5; // radius around the player's death position where items will be dropped
					// eslint-disable-next-line roblox-ts/lua-truthiness

					const soundID = "159798328";
					const sound = `rbxassetid://${soundID}`;
					const soundInstance = new Instance("Sound");
					soundInstance.SoundId = sound;
					soundInstance.Parent = this.instance;
					soundInstance.Volume = 7;
					soundInstance.MaxDistance = 10;
					soundInstance.Play();
					// eslint-disable-next-line roblox-ts/lua-truthiness
					if (!part.GetAttribute("hitCount")) {
						part.SetAttribute("hitCount", 1);
					} else {
						// Increment the hit count
						let currentHitCount = part.GetAttribute("hitCount") as number;
						part.SetAttribute("hitCount", ++currentHitCount);
						treeHitSound.Play();

						// Check if hit count is enough to destroy the tree
						if ((part.GetAttribute("hitCount") as number) >= 3) {
							// Your drop items code...
							for (let i = 0; i < 3; i++) {
								// calculate a random position around the player to drop the item
								const dropPosition = woodPart.Position.add(
									new Vector3(
										math.random() * dropRadius - dropRadius / 2,
										0,
										math.random() * dropRadius - dropRadius / 2,
									),
								);

								// create the physical item
								const { model, prompt } = createPhysicalItem(item, dropPosition);

								// connect the trigger to the prompt
								prompt.Triggered.Connect((otherPlayer) => {
									this.inventorySystem.addItemToInventory(otherPlayer, item); // assuming the item has a Name property
									model.Destroy();
								});
							}

							// Your drop items code...
							for (let i = 0; i < 3; i++) {
								// calculate a random position around the player to drop the item
								const dropPosition = leafPart.Position.add(
									new Vector3(
										math.random() * dropRadius - dropRadius / 2,
										0,
										math.random() * dropRadius - dropRadius / 2,
									),
								);

								// create the physical item
								const { model, prompt } = createPhysicalItem(leafItem, dropPosition);

								// connect the trigger to the prompt
								prompt.Triggered.Connect((otherPlayer) => {
									this.inventorySystem.addItemToInventory(otherPlayer, leafItem); // assuming the item has a Name property
									model.Destroy();
								});
							}

							// Destroy the part
							part.Parent?.Destroy();
							part.Destroy();
						}
					}
				}
			}
		}
	}
}
