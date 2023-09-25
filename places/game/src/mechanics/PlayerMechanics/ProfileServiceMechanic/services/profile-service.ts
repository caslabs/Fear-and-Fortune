import { Service, OnInit, OnStart } from "@flamework/core";
import { Players } from "@rbxts/services";
import ProfileService from "@rbxts/profileservice";
import { Profile } from "@rbxts/profileservice/globals";

enum PlayerClass {
	Mountaineer,
	Soldier,
	Engineer,
	Doctor,
	Scholar,
	Cameraman,
}

//TODO: Finalize Profile Data Structure
interface ProfileData {
	inventory: { [itemName: string]: number };
	backpack: { [itemName: string]: number };
	currency: number;
	class: PlayerClass;
	twitter_code_1: boolean;
	twitter_code_2: boolean;
	donation: number;
	successful_expeditions: number;
}

const profileTemplate: ProfileData = {
	inventory: {},
	backpack: {},
	currency: 0,
	class: PlayerClass.Soldier,
	twitter_code_1: false,
	twitter_code_2: false,
	donation: 0,
	successful_expeditions: 0,
};

const profileStore = ProfileService.GetProfileStore<ProfileData>("PlayerData", profileTemplate);


@Service({
	loadOrder: -1,
})
export class ProfileSystemMechanic implements OnInit, OnStart {
	private profiles = new Map<number, Profile<ProfileData>>();

	onInit() {
		print("ProfileServiceSystem service initiated");
	}

	onStart() {
		Players.PlayerAdded.Connect((player: Player) => {
			const profile = profileStore.LoadProfileAsync("Player_" + player.UserId, "ForceLoad");
			if (profile) {
				if (profile.Data.inventory === undefined) {
					profile.Data.inventory = profileTemplate.inventory;
				}

				if (profile.Data.backpack === undefined) {
					profile.Data.backpack = profileTemplate.backpack;
				}

				if (profile.Data.currency === undefined) {
					profile.Data.currency = profileTemplate.currency;
				}
				if (profile.Data.class === undefined) {
					profile.Data.class = profileTemplate.class;
				}
				if (profile.Data.twitter_code_1 === undefined) {
					profile.Data.twitter_code_1 = profileTemplate.twitter_code_1;
				}

				if (profile.Data.twitter_code_2 === undefined) {
					profile.Data.twitter_code_2 = profileTemplate.twitter_code_2;
				}

				if (profile.Data.donation === undefined) {
					profile.Data.donation = profileTemplate.donation;
				}

				if (profile.Data.successful_expeditions === undefined) {
					profile.Data.successful_expeditions = profileTemplate.successful_expeditions;
				}
				this.profiles.set(player.UserId, profile);
			} else {
				print("[PROFILE] Failed to load profile for " + player.Name);
			}
		});

		Players.PlayerRemoving.Connect((player: Player) => {
			const profile = this.profiles.get(player.UserId);
			if (profile && profile.IsActive()) {
				profile.Release();
				this.profiles.delete(player.UserId);
			}
		});

		print("ProfileServiceSystem service started");
	}

	getProfile(player: Player): Profile<ProfileData> | undefined {
		return this.profiles.get(player.UserId);
	}
}
