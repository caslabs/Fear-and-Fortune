import { Service, OnInit, OnStart } from "@flamework/core";
import Remotes from "shared/remotes";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";

@Service({})
export default class CraftSystemService implements OnStart, OnInit {
	constructor(private readonly inventoryService: InventorySystemService) {}
	public onInit(): void {
		print("CraftSystemController initialized");
	}

	public onStart(): void {
		print("CraftSystemController started");

		const CheckCraftingIngredientsEvent = Remotes.Server.Get("CheckCraftingIngredients");

		CheckCraftingIngredientsEvent.Connect(
			(
				player: Player,
				player2: Player,
				item: string,
				ingredients: Array<{ itemName: string; quantity: number }>,
			) => {
				if (player) {
					this.craftItem(player, item, ingredients);
				}
			},
		);
	}

	private checkCraftingIngredients(
		player: Player,
		item: string,
		ingredients: Array<{ itemName: string; quantity: number }>,
	): boolean {
		// The 'requiredIngredients' are now passed from the client
		const requiredIngredients = ingredients;
		const playerInventory = this.inventoryService.getInventory(player);

		if (!playerInventory) return false;

		for (const ingredient of requiredIngredients) {
			// eslint-disable-next-line roblox-ts/lua-truthiness
			const playerIngredientQuantity = playerInventory.get(ingredient.itemName) || 0;
			if (playerIngredientQuantity < ingredient.quantity) {
				print("[CRAFTING] Failed!");
				return false;
			}
		}

		print("[CRAFTING] Sucesss!");
		return true;
	}

	craftItem(player: Player, item: string, ingredients: Array<{ itemName: string; quantity: number }>): boolean {
		const hasIngredients = this.checkCraftingIngredients(player, item, ingredients);

		if (hasIngredients) {
			for (const ingredient of ingredients) {
				for (let i = 0; i < ingredient.quantity; i++) {
					this.inventoryService.removeItemFromInventory(player, ingredient.itemName);
				}
			}
			print(`[CRAFTING] Player ${player.Name} successfully crafted ${item}`);
			this.inventoryService.addItemToInventory(player, item);
			return true;
		} else {
			print(`[CRAFTING] Player ${player.Name} doesn't have the necessary ingredients to craft ${item}`);
			return false;
		}
	}
}
