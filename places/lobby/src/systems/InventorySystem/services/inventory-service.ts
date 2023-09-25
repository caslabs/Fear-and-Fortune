import { Service, OnStart } from "@flamework/core";
import Remotes from "shared/remotes";
import { Players } from "@rbxts/services";
import { ProfileSystemMechanic } from "mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service";

const UpdateInventoryEvent = Remotes.Server.Get("UpdateInventory");
const UpdateInventoryTradingEvent = Remotes.Server.Get("UpdateInventoryTrading");

export interface InventoryItemData {
	name: string;
	color?: Color3;
	desc?: string;
	quantity: number;
}

@Service({
	loadOrder: 99999,
})
export class InventorySystemService implements OnStart {
	private inventories = new Map<Player, Map<string, number>>();

	constructor(private readonly profileService: ProfileSystemMechanic) {}

	onStart() {
		print("InventorySystem service started");

		Players.PlayerAdded.Connect(async (player: Player) => {
			let profile = this.profileService.getProfile(player);
			while (!profile) {
				await Promise.delay(1); // wait for 1 second before retrying
				profile = this.profileService.getProfile(player);
			}

			if (profile) {
				const inventoryData = profile.Data.inventory;
				for (const [item, quantity] of pairs(inventoryData)) {
					print("[INVENTORY] Adding " + item + " x " + tostring(quantity) + " to inventory");
					this.updateInventory(player, tostring(item), quantity);
				}
			} else {
				print("[INVENTORY] Failed to load profile for " + player.Name);
			}
		});

		Players.PlayerRemoving.Connect((player: Player) => {
			const inventory = this.inventories.get(player);
			if (inventory) {
				const profile = this.profileService?.getProfile(player);
				if (profile && profile.IsActive()) {
					for (const [item, quantity] of pairs(inventory)) {
						profile.Data.inventory[item] = quantity;
					}
					profile.Release();
				}
				this.inventories.delete(player);
			}
		});
	}

	updateInventory(player: Player, item: string, quantity: number) {
		let inventory = this.inventories.get(player);
		if (!inventory) {
			inventory = new Map<string, number>();
			this.inventories.set(player, inventory);
		}
		inventory.set(item, quantity);
		print(quantity);

		//if quantity is 0, remove from inventory
		if (quantity > 0) {
			print("adding item to inventory " + item + " x " + quantity);

			UpdateInventoryEvent.SendToPlayer(player, player, item, "add", quantity);
			UpdateInventoryTradingEvent.SendToPlayer(player, player, item, "add", quantity);
		} else {
			print("removing item to inventory " + item + " x " + quantity);
			UpdateInventoryEvent.SendToPlayer(player, player, item, "remove", quantity);
			UpdateInventoryTradingEvent.SendToPlayer(player, player, item, "remove", quantity);
		}
	}

	addItemToInventory(player: Player, item: string) {
		const inventory = this.inventories.get(player);
		if (inventory) {
			// eslint-disable-next-line roblox-ts/lua-truthiness
			let quantity = inventory.get(item) || 0;
			quantity++;
			this.updateInventory(player, item, quantity);
		}
	}

	removeItemFromInventory(player: Player, item: string) {
		const inventory = this.inventories.get(player);
		if (inventory && inventory.has(item)) {
			// eslint-disable-next-line roblox-ts/lua-truthiness
			let quantity = inventory.get(item) || 0;
			quantity = quantity > 0 ? quantity - 1 : 0;
			this.updateInventory(player, item, quantity);
		}
	}

	getInventory(player: Player): Map<string, number> | undefined {
		return this.inventories.get(player);
	}

	checkItemInInventory(player: Player, item: string) {
		const inventory = this.inventories.get(player);
		return inventory ? inventory.has(item) : false;
	}

	//Trading System
	setInventory(player: Player, newData: { [key: string]: number }) {
		print("new stash data 4.1 " + newData);
		// Clear the current inventory

		const inventory = this.inventories.get(player);
		// Iterate through the new data and add it to the inventory
		/*
			["EldritchStone"] = -1,
			["HumanHeart"] = 2,
			["HumanMeat"] = -1
		*/
		for (const [item, quantity] of pairs(newData)) {
			print("[OOGA] " + item + " x " + tostring(quantity));
			this.updateInventory(player, tostring(item), quantity);
		}

		print("[AFTER TRADE] " + inventory);
		print("[INVENTORY] Set inventory for " + player.Name);
	}
}
