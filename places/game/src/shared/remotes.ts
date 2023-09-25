import Net from "@rbxts/net";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
type Segment = {
	model: Model;
	regionPart: BasePart;
	players: Player[];
};

//TODO: Prototype
type ToolData = {
	ammo: number;
	maxAmmo: number;
};

const Remotes = Net.CreateDefinitions({
	//Defaults
	SendMessage: Net.Definitions.ServerToClientEvent<[message: string]>(),
	DamagePlayer: Net.Definitions.ServerToClientEvent<[player: Player, damage: number]>(),

	//Crouching Mechanic
	IsCrouching: Net.Definitions.ClientToServerEvent<[isCrouching: boolean]>(),

	// Audio Systems
	PlayLocalSound: Net.Definitions.ServerToClientEvent<[soundId: SoundKeys, volume: number]>(),
	StopLocalSound: Net.Definitions.ServerToClientEvent<[soundId: SoundKeys]>(),
	// Respawn Mechanics
	ToggleRespawn: Net.Definitions.ClientToServerEvent<[respawnEnabled: boolean]>(),

	//Music Mechanics
	PlayMusic: Net.Definitions.ServerToClientEvent<[musicId: string]>(),
	RequestMusicPlay: Net.Definitions.ClientToServerEvent<[]>(),

	//Sanity Mechanics
	DecreaseSanityEvent: Net.Definitions.ClientToServerEvent<[player: Player]>(),
	UpdateSanityEvent: Net.Definitions.ServerToClientEvent<[player: Player, sanity: number]>(),

	// Post-Processing Mechanics
	StopJumpScareZoom: Net.Definitions.ServerToClientEvent<[]>(),
	PlayJumpScareZoom: Net.Definitions.ServerToClientEvent<[]>(),
	PlayGunShake: Net.Definitions.ServerToClientEvent<[]>(),

	// Task System
	CompleteObjectiveEvent: Net.Definitions.ServerAsyncFunction<() => void>(),

	//Progression Elevation System
	UpdateElevationEvent: Net.Definitions.ServerToClientEvent<[player: Player, elevation: number]>(),

	//Level System
	PlayerLocationEvent:
		Net.Definitions.ServerToClientEvent<[player: Player, segmentName: string, segmentModel: Segment]>(),

	//Inventory System
	UpdateInventory:
		Net.Definitions.ServerToClientEvent<[player: Player, item: string, operation: string, quantity: number]>(),
	AddItemToAllInventories: Net.Definitions.ClientToServerEvent<[item: string]>(),
	AddItemToInventory: Net.Definitions.ClientToServerEvent<[item: string]>(),
	RequestAddItemToAllInventories: Net.Definitions.ClientToServerEvent<[item: string]>(),
	RequestRemoveItemFromAllInventories: Net.Definitions.ServerToClientEvent<[item: string]>(),
	DropItemFromInventory: Net.Definitions.ClientToServerEvent<[item: string]>(),
	EquipItemFromInventory: Net.Definitions.ClientToServerEvent<[item: string]>(),
	//Crafting System
	CheckCraftingIngredients:
		Net.Definitions.ClientToServerEvent<
			[player: Player, item: string, ingredients: Array<{ itemName: string; quantity: number }>]
		>(),

	//AI System
	SpawnAI: Net.Definitions.ServerToClientEvent<[aiId: string, spawnLocation: Vector3]>(), // Server tells client to spawn an AI with a specific ID at a given location
	RequestSpawnAI: Net.Definitions.ClientToServerEvent<[aiType: string, spawnLocation: Vector3]>(), // Client asks server to spawn an AI of a specific type at a given location
	StartChasingShake: Net.Definitions.ServerToClientEvent<[]>(),
	StopChasingShake: Net.Definitions.ServerToClientEvent<[]>(),

	//Class System
	SetPlayerClass: Net.Definitions.ClientToServerEvent<[playerClass: string]>(),
	GetPlayerClass: Net.Definitions.ServerAsyncFunction<(player: Player) => Promise<string>>(),
	UpdatePlayerClass: Net.Definitions.ServerToClientEvent<[playerID: number, playerClass: string]>(),

	//Match
	//Death System
	PlayerDeathEvent: Net.Definitions.ServerToClientEvent<[player: Player, message: string, hint: string]>(), // Server tells client to show Death Screen
	PlayerDeathSurvival: Net.Definitions.ClientToServerEvent<[]>(),
	//Game Flow
	ExtractToLobby: Net.Definitions.ClientToServerEvent<[player: Player]>(),
	IsExtracted: Net.Definitions.ClientToServerEvent<[player: Player]>(),
	UpdateExpeditionCount: Net.Definitions.ClientToServerEvent<[player: Player]>(),

	//_DEV
	_SpawnBehindPlayer: Net.Definitions.ClientToServerEvent<[player: Player]>(),

	//Tool System
	ToolPickupEvent: Net.Definitions.ServerToClientEvent<[player: Player, tool: Tool, _toolData?: ToolData]>(),
	ToolRemovedEvent: Net.Definitions.ServerToClientEvent<[player: Player, tool: Tool]>(),
	UpdateAmmoEvent: Net.Definitions.ServerToClientEvent<[ammo: number]>(),

	//Survival System
	AddThirst: Net.Definitions.ServerToClientEvent<[thirst: number]>(),
	AddHunger: Net.Definitions.ServerToClientEvent<[hunger: number]>(),
	AddExposure: Net.Definitions.ServerToClientEvent<[isHeated: boolean]>(),
});
export default Remotes;
