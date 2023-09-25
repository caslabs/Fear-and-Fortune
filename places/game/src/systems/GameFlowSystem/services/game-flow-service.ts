import { OnStart, Service, OnInit } from "@flamework/core";
import ProfileService from "@rbxts/profileservice";
import {
	Players,
	TeleportService,
	DataStoreService,
	ServerStorage,
	Workspace,
	ReplicatedStorage,
} from "@rbxts/services";
import { ProfileSystemMechanic } from "mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service";
import Remotes from "shared/remotes";
import { InventorySystemService } from "systems/InventorySystem/services/inventory-system-service";

const ExtractToLobbyEvent = Remotes.Server.Get("ExtractToLobby");
const UpdateExpeditionCountEvent = Remotes.Server.Get("UpdateExpeditionCount");

@Service({})
export default class GameFlowSystemService implements OnStart, OnInit {
	constructor(
		public readonly inventorySystem: InventorySystemService,
		private readonly profileService: ProfileSystemMechanic,
	) {}

	private ExpeditionData = DataStoreService.GetOrderedDataStore("ExpeditionLeaderboard");

	public onInit(): void | Promise<void> {
		const AxeTool = ServerStorage.FindFirstChild("AxeToolTrigger")?.Clone();
		if (AxeTool) {
			AxeTool.Name = "AxeToolTrigger";
			AxeTool.Parent = Workspace;
			print("AxeToolTrigger Cloned");
		}
		print("GameFlowSystem Service Initialized");
	}

	public onStart() {
		// Set 'HasExtracted' attribute to false for each player when they join
		// _DEV

		Players.PlayerAdded.Connect((player) => {
			player.SetAttribute("HasExtracted", false);
		});

		const isExtractEvent = Remotes.Server.Get("IsExtracted");
		isExtractEvent.Connect((player: Player) => {
			player.SetAttribute("HasExtracted", true);
			print("[GAME FLOW EVENT] " + player.Name + " HasExtracted", player.GetAttribute("HasExtracted"));
		});

		/*
		// Also set 'HasExtracted' to false for all players currently in the game
		for (const player of Players.GetPlayers()) {
			player.SetAttribute("HasExtracted", false);
		}
		*/
		ExtractToLobbyEvent.Connect((player: Player) => {
			this.extractToLobby(player);
		});

		UpdateExpeditionCountEvent.Connect((player: Player) => {
			this.incrementSuccessfulExpeditions(player);
			print("[GAME FLOW] Updated Profiles Expedition Count for " + player.Name);
		});
		print("GameFlowSystem Service Started");
	}

	//TODO: Determine if player successfully exited or just died (dependent if we are to save to Profile)

	extractToLobby(player: Player) {
		//Save Inventory to ProfileService
		const hasExtracted = player.GetAttribute("HasExtracted");
		print("[GAME FLOW] " + player.Name + " hasAttacted", player.GetAttribute("HasExtracted"));
		if (hasExtracted === true) {
			this.inventorySystem.saveInventory(player);
			print("[GAME FLOW] Saved inventory for " + player.Name);
			TeleportService.Teleport(13733616492, player);
			print("[GAME FLOW] Teleported " + player.Name + " to lobby");
		} else {
			print("[GAME FLOW] " + player.Name + " has not extracted. Not saving profile");
			TeleportService.Teleport(13733616492, player);
			print("[GAME FLOW] Teleported " + player.Name + " to lobby");
		}
	}

	async incrementSuccessfulExpeditions(player: Player) {
		let profile = this.profileService.getProfile(player);
		while (!profile) {
			await Promise.delay(1); // wait for 1 second before retrying
			profile = this.profileService.getProfile(player);
		}

		if (profile) {
			//Update the leaderboard aswell
			profile.Data.successful_expeditions += 1;
			this.ExpeditionData.SetAsync(tostring(player.UserId), profile.Data.successful_expeditions);
			print(
				"[EXPEDITION DATA] Updated Expedition Data for " +
					player.Name +
					" " +
					profile.Data.successful_expeditions,
			);
		} else {
			warn(`Unable to fetch profile for player ${player.Name}.`);
		}
	}
}
