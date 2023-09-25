import { Service, OnInit, OnStart } from "@flamework/core";
import { Players } from "@rbxts/services";
import ProfileService from "@rbxts/profileservice";
import { Profile } from "@rbxts/profileservice/globals";

// Constants
const PROFILE_STORE_NAME = "PlayerData";

enum PlayerClass {
	Mountaineer,
	Soldier,
	Engineer,
	Doctor,
	Scholar,
	Cameraman,
}

class ProfileData {
	inventory: { [itemName: string]: number } = {};
	backpack: { [itemName: string]: number } = {};
	currency = 0;
	class: PlayerClass = PlayerClass.Soldier;
	twitter_code_1 = false;
	twitter_code_2 = false;
	donation = 0;
	successful_expeditions = 0;
}

const profileStore = ProfileService.GetProfileStore<ProfileData>(PROFILE_STORE_NAME, new ProfileData());

@Service({
	loadOrder: -1,
})
export class ProfileSystemMechanic implements OnInit, OnStart {
	private profiles = new Map<number, Profile<ProfileData>>();

	onInit() {
		print("ProfileServiceSystem service initiated");
	}

	onStart() {
		Players.PlayerAdded.Connect((player: Player) => this.handlePlayerAdded(player));
		Players.PlayerRemoving.Connect((player: Player) => this.handlePlayerRemoved(player));

		print("ProfileServiceSystem service started");
	}

	private handlePlayerAdded(player: Player) {
		const profile = profileStore.LoadProfileAsync("Player_" + player.UserId, "ForceLoad");
		if (profile) {
			//TODO: Consider undefined case
			this.profiles.set(player.UserId, profile);
		} else {
			error("[PROFILE] Failed to load profile for " + player.Name);
			// Handle error as appropriate for your use case
		}
	}

	private handlePlayerRemoved(player: Player) {
		const profile = this.profiles.get(player.UserId);
		if (profile && profile.IsActive()) {
			profile.Release();
			this.profiles.delete(player.UserId);
		}
	}

	getProfile(player: Player): Profile<ProfileData> | undefined {
		return this.profiles.get(player.UserId);
	}
}
