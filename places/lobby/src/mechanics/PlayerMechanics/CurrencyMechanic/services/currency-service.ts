import { Service, OnStart } from "@flamework/core";
import { Players } from "@rbxts/services";
import { ProfileSystemMechanic } from "mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service";
import Remotes from "shared/remotes";

const UpdateCurrencyEvent = Remotes.Server.Get("UpdateCurrency");
const UpdateCurrencyTwitterEvent = Remotes.Server.Get("UpdateCurrencyTwitter");

@Service({
	loadOrder: 99999,
})
export class CurrencyMechanicService implements OnStart {
	constructor(private readonly profileService: ProfileSystemMechanic) {}

	onStart(): void {
		print("CurrencyMechanic Service started");

		Players.PlayerAdded.Connect(async (player: Player) => {
			const currency = this.getCurrency(player);
			UpdateCurrencyEvent.SendToPlayer(player, player, await currency);
			UpdateCurrencyTwitterEvent.SendToPlayer(player, player, await currency);
			print("Curremcy Updated");
		});

		Players.PlayerRemoving.Connect(async (player: Player) => {
			const profile = this.profileService?.getProfile(player);
			if (profile && profile.IsActive()) {
				profile.Data.currency = await this.getCurrency(player); // Update the currency value in the profile
				print("Updated Currency Value");
				profile.Release();
			}
		});
	}

	async getCurrency(player: Player): Promise<number> {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}

		return profile.Data.currency;
	}

	async addCurrency(player: Player, amount: number): Promise<void> {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}
		if (profile) {
			profile.Data.currency += amount;
			UpdateCurrencyEvent.SendToPlayer(player, player, profile.Data.currency);
			UpdateCurrencyTwitterEvent.SendToPlayer(player, player, profile.Data.currency);
		} else {
			error("Profile not found for player " + player.Name);
		}
	}

	async removeCurrency(player: Player, amount: number): Promise<void> {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}
		if (profile) {
			profile.Data.currency += amount;
			print("Removed " + amount + " currency from " + player.Name);
			print("[CURRENCY] " + player.Name + " now has " + profile.Data.currency + " currency");
			UpdateCurrencyEvent.SendToPlayer(player, player, profile.Data.currency);
			UpdateCurrencyTwitterEvent.SendToPlayer(player, player, profile.Data.currency);
		} else {
			error("Profile not found for player " + player.Name);
		}
	}
}
