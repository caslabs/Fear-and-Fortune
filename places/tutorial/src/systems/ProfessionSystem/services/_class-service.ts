import { OnStart, Service } from "@flamework/core";
import { Players, StarterPlayer, UserInputService } from "@rbxts/services";
import Remotes from "shared/remotes";
import { DataStoreService } from "@rbxts/services";

const UpdatePlayerClassEvent = Remotes.Server.Get("UpdatePlayerClass");
@Service({
	loadOrder: 0,
})
export default class ClassService implements OnStart {
	private classStore: DataStore;
	private playerClasses: Map<Player, string>; // This is your server-side cache

	constructor() {
		this.classStore = DataStoreService.GetDataStore("PlayerClass");
		this.playerClasses = new Map();
	}

	public async setPlayerClass(player: Player, playerClass: string): Promise<void> {
		await this.classStore.SetAsync(tostring(player.UserId), playerClass);
		this.playerClasses.set(player, playerClass); // Update the cache
		UpdatePlayerClassEvent.SendToAllPlayers(player.UserId, playerClass);
	}

	public async getPlayerClass(player: Player): Promise<string> {
		if (this.playerClasses.has(player)) {
			// If the player's class is cached, return the cached value
			return this.playerClasses.get(player)!;
		}
		const data = await this.classStore.GetAsync(tostring(player.UserId));
		const playerClass = typeIs(data, "string") ? data : undefined;
		if (!playerClass) {
			await this.setPlayerClass(player, "Soldier");
			print("Player class not found, setting it to Soldier");
			return "Soldier";
		}
		print("data: " + data);
		print("playerClass: " + playerClass);
		this.playerClasses.set(player, playerClass); // Cache the player's class
		print("Setted player class: " + playerClass);
		return playerClass;

		// If no class was found in the cache or DataStore, default to "Soldier".
		return "Soldier";
	}

	public onStart() {
		print("ClassSystem Service Started");
		Players.PlayerAdded.Connect(async (newPlayer) => {
			// First attempt to fetch the class of the new player from datastore
			let playerClass = await this.getPlayerClass(newPlayer);
			if (!playerClass) {
				// If the class doesn't exist in the datastore, then set the default class
				await this.setPlayerClass(newPlayer, "Soldier");
				playerClass = "Soldier";
			}
			print("[DATASTORE] Class: " + playerClass);

			// Then send the updated class list of all existing players
			Players.GetPlayers().forEach(async (player) => {
				if (player === newPlayer) return; // Skip the new player
				const [playerClass] = await this.classStore.GetAsync(tostring(player.UserId));
				UpdatePlayerClassEvent.SendToPlayer(newPlayer, player.UserId, playerClass as string);
			});
		});

		Players.PlayerRemoving.Connect(async (player: Player) => {
			await this.setPlayerClass(player, this.playerClasses.get(player)!);
			this.playerClasses.delete(player);
		});

		// Inside the ClassSystem Service constructor or the 'onStart' method

		const SetPlayerClassEvent = Remotes.Server.Get("SetPlayerClass");
		const GetPlayerClassEvent = Remotes.Server.Get("GetPlayerClass");

		SetPlayerClassEvent.Connect(async (player: Player, playerClass: string) => {
			print(`Setting class for player ${player.UserId} to ${playerClass}`);
			await this.setPlayerClass(player, playerClass);
		});

		GetPlayerClassEvent.SetCallback(async (player: Player) => {
			return this.getPlayerClass(player);
		});
	}
}
