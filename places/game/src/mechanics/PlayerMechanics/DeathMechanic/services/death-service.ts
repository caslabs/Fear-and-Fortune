import { OnStart, Service } from "@flamework/core";
import Make from "@rbxts/make";
import { Players, Workspace, RunService } from "@rbxts/services";
import Remotes from "shared/remotes";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";
import Maid from "@rbxts/maid";
const baseplate = Workspace.WaitForChild("TutorialNode").WaitForChild("Baseplate") as BasePart;

interface DeathRule {
	condition: (lastPosition: Vector3, player: Player) => boolean;
	message: string;
	hint: string;
}

const deathRules: DeathRule[] = [
	{
		condition: (lastPosition) => lastPosition.Y < baseplate.Position.Y,
		message: "You fell to your death",
		hint: "Try not to fall next time...",
	},
	{
		condition: (lastPosition, player) => player.GetAttribute("JustReset") as boolean,
		message: "Another soul claimed...",
		hint: "You took the easy way out",
	},

	{
		condition: (lastPosition, player) => player.GetAttribute("LastDamagedByAI") as boolean,
		message: "You died to the Eyeless",
		hint: "Try not to look at it again... ",
	},

	{
		condition: (lastPosition, player) => player.GetAttribute("LastDamageByBanshee") as boolean,
		message: "You died to the Banshee",
		hint: "Save up your energy before confrontation... ",
	},

	{
		condition: (lastPosition, player) => player.GetAttribute("LastDamageBy_Crouch") as boolean,
		message: "You died to the _Crouch",
		hint: "Avoid noises by crouching...",
	},

	{
		condition: (lastPosition, player) => player.GetAttribute("LastDamageBySurvival") as boolean,
		message: "You died by your own hands",
		hint: "Try maintain your hunger and thirst...",
	},
	// Add more rules here...
	// TODO: Add the entities here
];

function CloneMe(char: Model) {
	// a function that clones a player
	char.Archivable = true;
	const clone = char.Clone();
	char.Archivable = false;

	// Remove the Humanoid, which removes the health bar
	const humanoid = clone.FindFirstChild("Humanoid") as Humanoid;
	humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff;
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
	humanoid.BreakJointsOnDeath = false;
	// Remove the BillboardGui, which removes the player name above the character
	const head = clone.FindFirstChild("Head") as Part;
	if (head) {
		const billboardGui = head.FindFirstChild("BillboardGui") as BillboardGui;
		if (billboardGui) {
			billboardGui.Destroy();
		}
	}
	return clone;
}
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
const PlayerDeathEvent = Remotes.Server.Get("PlayerDeathEvent");
const PlayerDeathSurvivalEvent = Remotes.Server.Get("PlayerDeathSurvival");
@Service({})
export default class DeathMechanic implements OnStart {
	private maid = new Maid();
	constructor(private readonly inventorySystem: InventorySystemService) {}
	attachProximityPrompt(instance: Part | Model, ignorePlayer: Player) {
		// checking for undefined
		if (instance) {
			const prompt = Make("ProximityPrompt", {
				ObjectText: "HumanMeat",
				ActionText: "Harvest",
				Parent: instance.IsA("Model") ? instance : instance,
				HoldDuration: 1,
			});

			// Disable prompt for ignorePlayer
			Players.PlayerAdded.Connect((player) => {
				if (player === ignorePlayer) {
					prompt.Enabled = false;
				}
			});

			return prompt;
		}
	}

	grab(instance: Part | Model, player: Player) {
		//TODO: Make a better Inventory System
		// This would add "WeirwoodSilver" to ALL players' inventories. Good mechanic?
		this.inventorySystem.addItemToInventory(player, "HumanMeat");
		print("[INFO] Grabbing Human Meat");
		if (instance) {
			// checking for undefined
			instance.Destroy();
		}
	}

	onStart(): void {
		print("DeathMechanic Service started");

		Players.PlayerAdded.Connect((player) => {
			player.SetAttribute("JustReset", false);
			player.SetAttribute("LastDamageBySurvival", false);

			PlayerDeathSurvivalEvent.Connect(() => {
				player.SetAttribute("LastDamageBySurvival", true);
				print("PlayerDeathSurvivalEvent triggered");
			});

			player.CharacterAdded.Connect((character) => {
				const humanoid = character.WaitForChild("Humanoid") as Humanoid;
				humanoid.BreakJointsOnDeath = false;
				const instance = character.FindFirstChild("HumanoidRootPart") as Part; // here, we set instance

				// Record the last known health of the character.
				let lastHealth: number = humanoid.Health;

				// Record the last known position of the character every second.
				let lastPosition: Vector3;
				const recording = RunService.Heartbeat.Connect(() => {
					if (character.PrimaryPart) {
						lastPosition = character.PrimaryPart.Position;
						lastHealth = humanoid.Health;
					}
				});

				humanoid.Died.Connect(() => {
					recording.Disconnect();
					// Create a clone of the player's character
					// Create a clone of the player's character

					// If the player's health dropped rapidly (e.g., within a single frame), they probably reset their character.
					if (lastHealth === humanoid.MaxHealth) {
						//player.SetAttribute("JustReset", true);
					}

					const inventory = this.inventorySystem.getInventory(player);
					// eslint-disable-next-line roblox-ts/lua-truthiness
					if (inventory) {
						const dropRadius = 5; // radius around the player's death position where items will be dropped
						inventory.forEach((quantity, item) => {
							for (let i = 0; i < quantity; i++) {
								// calculate a random position around the player to drop the item
								const dropPosition = lastPosition.add(
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
						});

						// clear the player's local inventory
						inventory.clear();
					}

					for (const rule of deathRules) {
						if (rule.condition(lastPosition, player)) {
							print(`${player.Name} ${rule.message}.`);
							print(`hint: ${rule.hint}`);

							// Ping to Client to show the death screen
							PlayerDeathEvent.SendToPlayer(player, player, rule.message, rule.hint);

							// Ping to Client to show the death screen
							PlayerDeathEvent.SendToPlayer(player, player, rule.message, rule.hint);

							print(`Cloning character for ${player.Name}`);
							//const characterClone = character.Clone() as Model;

							const characterClone = CloneMe(character);

							// Nudge the player's dead body

							if (!characterClone) {
								warn(`Failed to clone character for ${player.Name}`);
								return;
							}
							characterClone.SetPrimaryPartCFrame(new CFrame(lastPosition));
							characterClone.Parent = Workspace;
							const descendants = characterClone.GetDescendants();
							for (let i = 0; i < descendants.size(); i++) {
								const desc = descendants[i];
								if (desc.IsA("Motor6D") && desc.Parent) {
									const part0 = desc.Part0;
									const jointName = desc.Name;

									if (part0) {
										const socket = new Instance("BallSocketConstraint");

										const attachment0Instance =
											desc.Parent.FindFirstChild(`${jointName}Attachment`) ||
											desc.Parent.FindFirstChild(`${jointName}RigAttachment`);
										const attachment1Instance =
											part0.FindFirstChild(`${jointName}Attachment`) ||
											part0.FindFirstChild(`${jointName}RigAttachment`);

										if (attachment0Instance && attachment1Instance) {
											(socket as BallSocketConstraint).Attachment0 =
												attachment0Instance as Attachment;
											(socket as BallSocketConstraint).Attachment1 =
												attachment1Instance as Attachment;
											socket.Parent = desc.Parent;
											desc.Destroy();
										}
									}
								}
							}
							if (character !== undefined) {
								player.Character = undefined;
								character.ClearAllChildren();
								character.Destroy();
							}

							// Nudge the player's dead body

							// If PrimaryPart is not set, set it to HumanoidRootPart

							// Add the ProximityPrompt to the clone
							const prompt = this.attachProximityPrompt(characterClone, player);
							if (prompt) {
								this.maid.GiveTask(
									prompt.Triggered.Connect((otherPlayer) => {
										this.grab(characterClone, otherPlayer); // Call the grab function when triggered
										characterClone.Destroy(); // Remove the clone after the ProximityPrompt is triggered
									}),
								);
							}

							break; // Stop checking other rules once we find one that applies
						}
					}

					player.SetAttribute("JustReset", false); // Reset attribute after death is processed
					player.SetAttribute("LastDamagedByAI", false); // Reset attribute after death is processed
				});
			});
		});
	}
}
