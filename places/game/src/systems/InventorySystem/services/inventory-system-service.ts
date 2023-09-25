import { Service, OnInit, OnStart } from "@flamework/core";
import Remotes from "shared/remotes";
import { Players, Workspace } from "@rbxts/services";
import ProfileService from "@rbxts/profileservice";
import { Profile } from "@rbxts/profileservice/globals";
import { ProfileSystemMechanic } from "mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service";
import { Signals } from "shared/signals";

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

const UpdateInventoryEvent = Remotes.Server.Get("UpdateInventory");
const DropItemFromInventoryEvent = Remotes.Server.Get("DropItemFromInventory");
const EquipItemFromInventoryEvent = Remotes.Server.Get("EquipItemFromInventory");
const ToolPickupEvent = Remotes.Server.Get("ToolPickupEvent");

@Service({
	loadOrder: 99999,
})
export class InventorySystemService implements OnInit, OnStart {
	constructor(private readonly profileService: ProfileSystemMechanic) {}

	private inventories = new Map<Player, Map<string, number>>();

	onInit() {
		print("InventorySystem service started");
		const addItemToAllInventoriesEvent = Remotes.Server.Get("AddItemToAllInventories");
		addItemToAllInventoriesEvent.Connect((player: Player, item: string) => this.addItemToAllInventories(item));
	}

	onStart() {
		print("InventorySystem service started bruh");

		Players.PlayerAdded.Connect((player: Player) => {
			this.inventories.set(player, new Map<string, number>());

			//For playtesting purposes, give AxeTool by default
			this.addItemToInventory(player, "AxeTool");
		});

		Players.PlayerAdded.Connect(async (player) => {
			player.Chatted.Connect((message) => this._onPlayerChat(player, message));
		});

		Players.PlayerRemoving.Connect((player: Player) => {
			const isExtracted = player.GetAttribute("HasExtracted");
			if (isExtracted === true) {
				this.saveInventory(player);
			} else {
				print("[INFO] Player left without extracting. Not saving data");
			}
		});

		print("InventorySystem service started");

		//Add Item
		const AddItemToInventoryEvent = Remotes.Server.Get("AddItemToInventory");

		AddItemToInventoryEvent.Connect((player: Player, item: string) => {
			if (player) {
				this.addItemToInventory(player, item, 1);
			}
		});

		//Drop Item
		DropItemFromInventoryEvent.Connect((player: Player, item: string) => {
			if (player) {
				this.dropItemFromInventory(player, item);
			}
		});

		//Equip Item
		EquipItemFromInventoryEvent.Connect((player: Player, item: string) => {
			if (player) {
				this.equipItemFromInventory(player, item);
			}
		});

		//Add Item
		Signals.AddItem.Connect((player: Player, item: string) => {
			if (player) {
				this.addItemToInventory(player, item, 1);
			}
		});
	}

	public getInventory(player: Player): Map<string, number> | undefined {
		return this.inventories.get(player);
	}

	async loadInventory(player: Player) {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}
		if (profile && profile.IsActive()) {
			const inventoryData = profile.Data.inventory;
			for (const [item, quantity] of pairs(inventoryData)) {
				this.addItemToInventory(player, tostring(item), quantity);
			}
		}
	}

	async saveInventory(player: Player) {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}

		if (profile && profile.IsActive()) {
			const inventory = this.inventories.get(player);
			if (inventory) {
				inventory.forEach((quantity, item) => {
					// eslint-disable-next-line roblox-ts/lua-truthiness
					if (profile!.Data.inventory[item]) {
						profile!.Data.inventory[item] += quantity;
					} else {
						profile!.Data.inventory[item] = quantity;
					}
				});
				profile.Release();
			}
		}
	}

	public addItemToInventory(player: Player, item: string, quantity = 1) {
		let inventory = this.inventories.get(player);
		if (!inventory) {
			inventory = new Map<string, number>();
			this.inventories.set(player, inventory);
		}
		// eslint-disable-next-line roblox-ts/lua-truthiness
		const currentQuantity = inventory.get(item) || 0;
		inventory.set(item, currentQuantity + quantity);
		print("[INVENTORY] currentQuantity)", currentQuantity);
		print("[INVENTORY] quantity)", quantity);
		print("[INVENTORY] currentQuantity + quantity)", currentQuantity + quantity);

		//Check if PickupSound Sound Instance is not yet available

		UpdateInventoryEvent.SendToPlayer(player, player, item, "add", currentQuantity + quantity);
	}

	removeItemFromInventory(player: Player, item: string) {
		const inventory = this.inventories.get(player);
		if (inventory) {
			// eslint-disable-next-line roblox-ts/lua-truthiness
			const currentQuantity = inventory.get(item) || 0;
			if (currentQuantity > 1) {
				inventory.set(item, currentQuantity - 1);
				UpdateInventoryEvent.SendToPlayer(player, player, item, "remove", currentQuantity - 1);
			} else {
				inventory.delete(item);
				UpdateInventoryEvent.SendToPlayer(player, player, item, "remove", 0);
			}
		}
	}

	checkItemInInventory(player: Player, item: string) {
		const inventory = this.inventories.get(player);
		return inventory ? inventory.has(item) : false;
	}

	addItemToAllInventories(item: string, quantity = 1) {
		for (const [player] of pairs(this.inventories)) {
			this.addItemToInventory(player, item, quantity);
		}
	}

	removeItemFromAllInventories(item: string) {
		for (const [player] of pairs(this.inventories)) {
			this.removeItemFromInventory(player, item);
		}
	}

	fire(player: Player) {
		print("Swing!");
	}

	equipItemFromInventory(player: Player, item: string) {
		//Remove Item from Inventory
		if (this.checkItemInInventory(player, item)) {
			this.removeItemFromInventory(player, item);
		}
		print("Item Equipped: ", item);

		//Get the script
		const toolName = item + "Trigger";
		print("Tool Name: ", toolName);
		print("tool", Workspace.FindFirstChild(toolName));

		print("Equip Tool Initiated");
		// Add the tool to the player's backpack and destroy the instance in the Workspace.
		const tool = Workspace.FindFirstChild(toolName)?.Clone() as Tool;
		tool.Parent = Workspace;
		tool.Name = toolName;
		tool.Parent = player.Character;
		print("Tool Parent: ", tool.Parent);

		print("Tool created", tool);

		print(tool.Name);

		if (tool.Parent?.IsA("Model")) {
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
		} else {
			print("Tool does not have a parent or is not a model");
		}
	}

	dropItemFromInventory(player: Player, item: string) {
		if (this.checkItemInInventory(player, item)) {
			this.removeItemFromInventory(player, item);
		}

		const character = player.Character;
		if (character) {
			const primaryPart = character.PrimaryPart;

			if (primaryPart) {
				const lastPosition = primaryPart.Position;

				//Drop Physical Block
				const dropRadius = 1; // radius around the player's death position where items will be dropped
				const dropPosition = lastPosition.add(
					new Vector3(
						math.random() * dropRadius - dropRadius / 2,
						0,
						math.random() * dropRadius - dropRadius / 2,
					),
				);

				const { model, prompt } = createPhysicalItem(item, dropPosition);
				print("POOPED ITEM");
				prompt.Triggered.Connect((otherPlayer) => {
					this.addItemToInventory(otherPlayer, item); // assuming the item has a Name property
					model.Destroy();
				});
			} else {
				// Handle cases where PrimaryPart is undefined
				print("Primary part is not defined for the character");
			}
		} else {
			// Handle cases where the character is not available
			print("Character is not available for the player");
		}

		print("Dropped Item");
	}

	private dropItem(item: string, position: Vector3) {
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

	private _onPlayerChat(player: Player, message: string) {
		//TODO: DEV ONLY CAN START THE GAME
		if (player.UserId === 11697914) {
			// Give player a specific item using /give <item>
			const [command, item] = message.split(" ");
			if (command === "/give") {
				this.addItemToInventory(player, item);
			}
		} else {
			print("Not a dev! Sorry!");
		}
	}
}
