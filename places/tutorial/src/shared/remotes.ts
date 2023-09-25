import Net from "@rbxts/net";
type Segment = {
	model: Model;
	regionPart: BasePart;
	players: Player[];
};

const Remotes = Net.CreateDefinitions({
	//Defaults
	SendMessage: Net.Definitions.ServerToClientEvent<[message: string]>(),

	// Respawn Mechanics
	ToggleRespawn: Net.Definitions.ClientToServerEvent<[respawnEnabled: boolean]>(),

	//Music Mechanics
	PlayMusic: Net.Definitions.ServerToClientEvent<[musicId: string]>(),
	RequestMusicPlay: Net.Definitions.ClientToServerEvent<[]>(),

	//Sanity Mechanics
	DecreaseSanityEvent: Net.Definitions.ClientToServerEvent<[player: Player]>(),
	UpdateSanityEvent: Net.Definitions.ServerToClientEvent<[player: Player, sanity: number]>(),

	// Task System
	CompleteObjectiveEvent: Net.Definitions.ServerAsyncFunction<() => void>(),

	//Progression Elevation System
	UpdateElevationEvent: Net.Definitions.ServerToClientEvent<[player: Player, elevation: number]>(),

	//Level System
	PlayerLocationEvent:
		Net.Definitions.ServerToClientEvent<[player: Player, segmentName: string, segmentModel: Segment]>(),

	//Inventory System
	UpdateInventory: Net.Definitions.ServerToClientEvent<[player: Player, item: string, operation: string]>(),
	AddItemToAllInventories: Net.Definitions.ClientToServerEvent<[item: string]>(),
	RequestAddItemToAllInventories: Net.Definitions.ClientToServerEvent<[item: string]>(),
	RequestRemoveItemFromAllInventories: Net.Definitions.ServerToClientEvent<[item: string]>(),

	//AI System
	SpawnAI: Net.Definitions.ServerToClientEvent<[aiId: string, spawnLocation: Vector3]>(), // Server tells client to spawn an AI with a specific ID at a given location
	RequestSpawnAI: Net.Definitions.ClientToServerEvent<[aiType: string, spawnLocation: Vector3]>(), // Client asks server to spawn an AI of a specific type at a given location
	StartChasingShake: Net.Definitions.ServerToClientEvent<[player: Player]>(),
	StopChasingShake: Net.Definitions.ServerToClientEvent<[player: Player]>(),

	//Class System
	SetPlayerClass: Net.Definitions.ClientToServerEvent<[playerClass: string]>(),
	GetPlayerClass: Net.Definitions.ServerAsyncFunction<(player: Player) => Promise<string>>(),
	UpdatePlayerClass: Net.Definitions.ServerToClientEvent<[playerID: number, playerClass: string]>(),

	//Picture System
	GetHumanoidDescriptionFromUserId: Net.Definitions.ServerAsyncFunction<() => Promise<HumanoidDescription>>(),

	//Match
	//Death System
	PlayerDeathEvent: Net.Definitions.ServerToClientEvent<[player: Player, message: string, hint: string]>(), // Server tells client to show Death Screen
});
export default Remotes;
