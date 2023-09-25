import { Service, OnStart } from "@flamework/core";
import { Players } from "@rbxts/services";
import { CurrencyMechanicService } from "mechanics/PlayerMechanics/CurrencyMechanic/services/currency-service";
import { ProfileSystemMechanic } from "mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service";
import Remotes from "shared/remotes";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-service";

const UpdateCurrencyEvent = Remotes.Server.Get("UpdateCurrency");

export interface InventoryItemData {
	name: string;
	color?: Color3;
	desc?: string;
	quantity: number;
}

@Service({
	loadOrder: 99999,
})
export class TradeMechanicService implements OnStart {
	constructor(
		private readonly inventoryService: InventorySystemService,
		private readonly currencyService: CurrencyMechanicService,
	) {}

	onStart(): void {
		const TradeRequestEvent = Remotes.Server.Get("TradeRequest");
		TradeRequestEvent.Connect((player: Player, currency: number, new_inventory: { [key: string]: number }) => {
			print("NEW STASH DATA 2", new_inventory);
			this.afterTrade(player, currency, new_inventory);
			print("[TRADE] Player " + player.Name + " requested trade SUCESS!");
		});

		print("TradeMechanic Service started");
	}

	//Set New Inventory and Currency State for Player after trading
	async afterTrade(player: Player, currency: number, new_inventory: { [key: string]: number }) {
		print("NEW STASH DATA 3", new_inventory);

		if (currency >= 0) {
			this.currencyService.addCurrency(player, currency);
			this.inventoryService.setInventory(player, new_inventory);
			print("new stash data 4.0 " + new_inventory);
			print("[TRADE] Player gaind money from trade!");
		} else {
			// if player can afford the trade, update currency
			if ((await this.currencyService.getCurrency(player)) >= currency) {
				this.currencyService.removeCurrency(player, currency);
				this.inventoryService.setInventory(player, new_inventory);
				print("[TRADE] Player paid for trade!");
			} else {
				print("[TRADE] Player cannot afford trade");
			}
		}

		print("NEW STASH DATA 5", new_inventory);
	}
}
