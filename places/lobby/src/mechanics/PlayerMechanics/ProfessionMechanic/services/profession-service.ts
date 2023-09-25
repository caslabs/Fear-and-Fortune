import { Service, OnInit, OnStart } from "@flamework/core";
import { Players } from "@rbxts/services";
import ProfileService from "@rbxts/profileservice";
import { Profile } from "@rbxts/profileservice/globals";
import Remotes from "shared/remotes";
import { ProfileSystemMechanic } from "mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service";
import PartyService from "systems/MatchMakingSystem/services/party-service";

enum PlayerClass {
	Mountaineer,
	Soldier,
	Engineer,
	Doctor,
	Scholar,
	Cameraman,
}

function PlayerClassToString(playerClass: PlayerClass) {
	switch (playerClass) {
		case PlayerClass.Mountaineer:
			return "Mountaineer";
		case PlayerClass.Soldier:
			return "Soldier";
		case PlayerClass.Engineer:
			return "Engineer";
		case PlayerClass.Doctor:
			return "Doctor";
		case PlayerClass.Scholar:
			return "Scholar";
		case PlayerClass.Cameraman:
			return "Cameraman";
	}
}

function StringToPlayerClass(playerClass: string) {
	switch (playerClass) {
		case "Mountaineer":
			return PlayerClass.Mountaineer;
		case "Soldier":
			return PlayerClass.Soldier;
		case "Engineer":
			return PlayerClass.Engineer;
		case "Doctor":
			return PlayerClass.Doctor;
		case "Scholar":
			return PlayerClass.Scholar;
		case "Cameraman":
			return PlayerClass.Cameraman;
	}
}

const PlayerProfessionUpdateEvent = Remotes.Server.Get("PlayerProfessionUpdate");
const SendPartyMemberofClassEvent = Remotes.Server.Get("SendPartyMemberofClassEvent");
const RequestUpdateProfessionEvent = Remotes.Server.Get("RequestProfessionUpdate");
const RequestPartyMemberofClassEvent = Remotes.Server.Get("RequestPartyMemberofClassEvent");

@Service({
	loadOrder: 99999,
})
export class ProfessionMechanicService implements OnStart {
	constructor(private readonly profileService: ProfileSystemMechanic, private readonly partyService: PartyService) {}

	onStart(): void {
		print("ProfessionMechanic Service started");

		Players.PlayerAdded.Connect(async (player: Player) => {
			const playerClass = await this.getProfession(player);
			// eslint-disable-next-line roblox-ts/lua-truthiness
			if (playerClass === undefined) {
				// If the player has no profession, set it to Mountaineer
				return;
				// eslint-disable-next-line roblox-ts/lua-truthiness
			} else if (playerClass) {
				const playerClassStr = PlayerClassToString(playerClass);
				if (playerClassStr === undefined) {
					return;
				}
				PlayerProfessionUpdateEvent.SendToPlayer(player, playerClassStr);
				print("Profession Updated");
			}
		});

		Players.PlayerRemoving.Connect(async (player: Player) => {
			const profile = this.profileService?.getProfile(player);
			if (profile && profile.IsActive()) {
				profile.Data.class = await this.getProfession(player); // Update the class value in the profile
				print("Updated Profession Value");
				profile.Release();
			}
		});

		RequestUpdateProfessionEvent.Connect(async (player: Player, profession: string) => {
			const playerClass = StringToPlayerClass(profession);
			// eslint-disable-next-line roblox-ts/lua-truthiness
			if (playerClass) {
				await this.setProfession(player, playerClass);
			}
		});
	}

	async getProfession(player: Player): Promise<PlayerClass> {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}

		return profile.Data.class;
	}

	async setProfession(player: Player, profession: PlayerClass): Promise<void> {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}
		if (profile) {
			profile.Data.class = profession;

			PlayerProfessionUpdateEvent.SendToPlayer(player, PlayerClassToString(profile.Data.class));

			const members: Player[] = [];
			if (this.partyService.isMember(tostring(player.UserId))) {
				print("[HOST] Player is a member of a party");
				// Assuming you have a method that identifies if the player is the host.
				// Create a ticket specifically for the host
				// Assuming your match-making service has a reference to your party service.
				const partyMembers = this.partyService.getPartyMembers(tostring(player.UserId));
				for (const member of partyMembers) {
					const userId = tonumber(member.userId);
					// Skip Local Player if member as we already have it.
					const thisPlayer = Players.LocalPlayer;
					if (thisPlayer && userId !== thisPlayer.UserId) {
						continue;
					}
					if (userId !== undefined) {
						const member = Players.GetPlayerByUserId(userId);
						if (member) {
							members.push(member);
						}
					}
				}
				SendPartyMemberofClassEvent.SendToPlayers(members, members, PlayerClassToString(profile.Data.class));
			} else {
				error("Profile not found for player " + player.Name);
			}
		}
	}
}
