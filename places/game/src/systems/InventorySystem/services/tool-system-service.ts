/* eslint-disable roblox-ts/lua-truthiness */
import { BaseComponent, Component, Components } from "@flamework/components";
import { OnStart, Service, OnInit, Dependency } from "@flamework/core";
import { Players, ServerStorage, Workspace } from "@rbxts/services";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";
import { t } from "@rbxts/t";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import { CooldownManager, ToolActionContext, ToolConfig, ToolDataConfig, ToolFunction } from "./items-config";

const ToolPickupEvent = Remotes.Server.Get("ToolPickupEvent");

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

const cooldownManager = new CooldownManager();

export const FunctionMap: { [key: string]: ToolFunction } = {
	chopTree: () => {
		print("A tree has been chopped!");
	},

	hitPlayer: () => {
		// Implement friendly fire?
		print("A player has been hit!");
	},

	hitEntity: () => {
		print("An entity has been hit!");
	},

	swing: (context: ToolActionContext) => {
		const { lastActionTime, player, action, tool } = context;

		const animationInstance = new Instance("Animation");
		animationInstance.AnimationId = `rbxassetid://${action.animationId}`;

		const currentTime = tick();
		const lastSwingTime = lastActionTime.get(player) || 0;

		if (currentTime - lastSwingTime < tonumber(action.cooldownBehavior?.duration || 0)!) {
			print("Cooldown");
			return;
		}

		lastActionTime.set(player, currentTime); // Update the last swing time for the player
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

		const hitbox = tool.FindFirstChild("Hitbox") as Part;
		if (hitbox) {
			// Create the OverlapParams
			const overlapParams = new OverlapParams();
			overlapParams.FilterType = Enum.RaycastFilterType.Blacklist;
			overlapParams.FilterDescendantsInstances = [tool]; // Ignore the tool itself
			overlapParams.MaxParts = math.huge;

			// Get all parts in the Overlap space
			const parts = Workspace.GetPartsInPart(hitbox, overlapParams);

			for (const part of parts) {
				// Make sure the part is not part of the tool
				if (part.Parent !== tool.Parent) {
					// The part belongs to another player, so it was touched by the hitbox
					print(part.Name + " was touched by the hitbox");
					//get position

					/*
					Design a collision system
					*/
					// If in action.collision
					if (action.collisions?.find((c) => c.type === part.Name)) {
						const item = action.collisions?.find((c) => c.type === part.Name)!.type;
						const ironWoodPart = part as Part;
						const dropRadius = 5; // radius around the player's death position where items will be dropped

						//TODO: use sound system
						const soundID = action.collisions?.find((c) => c.type === part.Name)?.soundId[0];
						const sound = `rbxassetid://${soundID}`;
						const soundInstance = new Instance("Sound");
						soundInstance.SoundId = sound;
						soundInstance.Parent = tool;
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
							print("Hit Count: ", part.GetAttribute("hitCount") as number);

							// Check if hit count is enough to destroy the tree
							if ((part.GetAttribute("hitCount") as number) >= 3) {
								// Your drop items code...
								for (let i = 0; i < action.collisions!.find((c) => c.type === part.Name)!.amount; i++) {
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
										Signals.AddItem.Fire(otherPlayer, item);
										model.Destroy();
									});
								}
								// Destroy the part
								part.Destroy();
							}
						}
					}
				}
			}
		}
	},

	deploy: (context: ToolActionContext) => {
		print("Deploying");
	},

	fire: (context: ToolActionContext) => {
		print("Firing");
	},

	heal: (context: ToolActionContext) => {
		print("Healing");
	},

	build: (context: ToolActionContext) => {
		print("Building");
	},

	// Add more functions as needed...
};

/*
Statically define, dynamically point to behavior (e.g. swing, shoot, etc.)
dynamic dispatch Tool
*/
@Component({
	instanceGuard: t.instanceIsA("Tool"),
})
export class DynamicTool extends BaseComponent<Attributes> implements OnStart {
	fireConnected: boolean;
	isReleased: boolean;

	private lastActionTime: Map<Player, number>;

	constructor() {
		super();

		this.isReleased = false;
		this.fireConnected = false;
		this.lastActionTime = new Map<Player, number>();
	}

	onStart() {
		// If you wish to have more logic during tool start
		print("Dynamic Tool component started");
		const tool = this.instance as Tool;
		tool.GetPropertyChangedSignal("Parent").Connect(() => {
			this.handleTool(tool);
		});
	}

	private handleTool(tool: Tool) {
		if (tool.Parent?.IsA("Model") && Players.GetPlayerFromCharacter(tool.Parent as Model)) {
			for (const part of tool.GetDescendants()) {
				if (part.IsA("BasePart")) {
					part.CanCollide = false;
				}
			}

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
				ToolPickupEvent.SendToPlayer(player, player, tool);
			} else {
				print(playerBackpack?.FindFirstChild(tool.Name));
				print("Tool is already in the player's backpack.");
			}

			// Bind to mouse button 1 for PC users
			if (!this.fireConnected) {
				tool.Activated.Connect(() => {
					const config = ToolDataConfig.find((c) => c.name === tool.Name);
					if (config) {
						for (const action of config.actions) {
							const func = FunctionMap[action.functionId];
							print("Function: ", func);
							if (func && !cooldownManager.isActionOnCooldown(action, player)) {
								const context: ToolActionContext = {
									lastActionTime: this.lastActionTime,
									player: player,
									action: action,
									tool: this.instance as Tool,
								};
								func(context);
								cooldownManager.updateCooldown(action, player);
							}
						}
					}
				});

				this.fireConnected = true;
			}
		}
	}
}

interface Attributes {}
@Service({})
export default class ToolBootloaderService implements OnInit {
	constructor() {}

	public onInit(): void | Promise<void> {
		print("ToolBootloader Service Initialized");
		this.loadTools();
	}

	loadTools() {
		for (const config of ToolDataConfig) {
			this.loadTool(config);
		}
	}

	private loadTool(config: ToolConfig) {
		const toolItem = ServerStorage.FindFirstChild(config.tool)?.Clone() as Tool; // Cast it to the Tool type
		if (toolItem) {
			toolItem.Name = config.name;
			toolItem.Parent = Workspace;

			// Add the component
			const components = Dependency<Components>();
			components.addComponent<DynamicTool>(toolItem);
			print("Added component to", config.name);
		}
	}
}
