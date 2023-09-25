import { Service, OnInit } from "@flamework/core";
import Remotes from "shared/remotes";

const UpdateInventoryEvent = Remotes.Server.Get("UpdateInventory");

@Service({})
export class InventorySystemService implements OnInit {
	// Each player has a set of items that are simply strings
	//TODO: Upgrade to a more robust inventory system, works for playtesting for now
	private inventories = new Map<Player, Set<string>>();

	onInit() {
		print("InventorySystem service started");

		const addItemToAllInventoriesEvent = Remotes.Server.Get("AddItemToAllInventories");
		addItemToAllInventoriesEvent.Connect((player: Player, item: string) => this.addItemToAllInventories(item));
	}

	addItemToAllInventories(item: string) {
		for (const [player] of pairs(this.inventories)) {
			this.addItemToInventory(player, item);
		}
	}

	removeItemFromAllInventories(item: string) {
		for (const [player] of pairs(this.inventories)) {
			this.removeItemFromInventory(player, item);
		}
	}

	addItemToInventory(player: Player, item: string) {
		let inventory = this.inventories.get(player);
		if (!inventory) {
			inventory = new Set();
			this.inventories.set(player, inventory);
		}
		inventory.add(item);
		UpdateInventoryEvent.SendToPlayer(player, player, item, "add");
	}

	removeItemFromInventory(player: Player, item: string) {
		const inventory = this.inventories.get(player);
		if (inventory) {
			inventory.delete(item);
			UpdateInventoryEvent.SendToPlayer(player, player, item, "remove");
		}
	}

	checkItemInInventory(player: Player, item: string) {
		const inventory = this.inventories.get(player);
		return inventory ? inventory.has(item) : false;
	}
}
