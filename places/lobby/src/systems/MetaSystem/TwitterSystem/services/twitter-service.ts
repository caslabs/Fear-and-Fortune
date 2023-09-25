import { OnInit, OnStart, Service } from "@flamework/core";
import { CurrencyMechanicService } from "mechanics/PlayerMechanics/CurrencyMechanic/services/currency-service";
import { ProfileSystemMechanic } from "mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service";
import Remotes from "shared/remotes";

@Service({})
export default class TwitterSystemService implements OnStart {
	constructor(
		private readonly profileService: ProfileSystemMechanic,
		private readonly currencyMechanic: CurrencyMechanicService,
	) {}

	public onInit(): void {
		print("TwitterSystem Service initialized");
	}

	public onStart() {
		print("TwitterSystem Service Started");

		//Check Code for UI end
		const CheckIfReedemEvent = Remotes.Server.Get("CheckIfReedem");
		CheckIfReedemEvent.SetCallback(async (player: Player) => {
			return await this.checkIfReedem(player);
		});

		//Reedem Code
		// Reedem Code
		const ReedemTwitterCodeEvent = Remotes.Server.Get("ReedemTwitterCode");
		ReedemTwitterCodeEvent.SetCallback((player, code: string) => {
			print("Bruh");
			return this.reedemTwitterCode(player, code);
		});
	}

	//TODO: Hard-coded for now
	async checkIfReedem(player: Player): Promise<boolean> {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}

		print(profile.Data.twitter_code_1);

		return profile.Data.twitter_code_1;
	}

	async reedemTwitterCode(player: Player, code: string): Promise<string> {
		if (!(await this.checkIfReedem(player))) {
			let profile = this.profileService.getProfile(player);
			while (!profile) {
				await Promise.delay(1); // wait for 1 second before retrying
				profile = this.profileService.getProfile(player);
			}
			if (profile) {
				if (code === "PLAYTEST") {
					this.award(player);
					return "Success!";
				} else {
					return "Wrong Code!";
				}
			} else {
				return "Failed to fetch profile!";
			}
		} else {
			return "Already Redeemed!";
		}
	}

	async award(player: Player): Promise<void> {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}
		this.currencyMechanic.addCurrency(player, 10000);
		profile.Data.twitter_code_1 = true;
		profile.Release();
	}
}
