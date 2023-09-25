import { Service, OnInit, OnStart } from "@flamework/core";
import { Players } from "@rbxts/services";
import ProfileService from "@rbxts/profileservice";
import { Profile } from "@rbxts/profileservice/globals";
import Remotes from "shared/remotes";
import { ProfileSystemMechanic } from "mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service";

enum PlayerClass {
	Mountaineer,
	Soldier,
	Engineer,
	Doctor,
	Scholar,
	Cameraman,
}

@Service({
	loadOrder: 99999,
})
export class ProfessionMechanicService implements OnStart {
	constructor(private readonly profileService: ProfileSystemMechanic) {}

	onStart(): void {
		print("ProfessionMechanic Service started");
	}

	async getProfession(player: Player): Promise<PlayerClass> {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}

		return profile.Data.class;
	}
}
