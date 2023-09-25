import Net from "@rbxts/net";
import { QueueState } from "./signals";
type Segment = {
	model: Model;
	regionPart: BasePart;
	players: Player[];
};

interface Inventory {
	[itemId: string]: number; // Key is the item ID, value is the quantity
}

export interface InventoryItemData {
	name: string;
	color?: Color3;
	desc?: string;
	quantity: number;
}

interface InventoryTradeItemData {
	name: string;
	quantity: number;
}

interface PlayerData {
	inventory: Inventory;
}

interface LeaderboardData {
	name: string;
	donation: number;
}

interface ExpeditionData {
	name: string;
	expedition: number;
}

enum PlayerClass {
	Mountaineer,
	Soldier,
	Engineer,
	Doctor,
	Scholar,
	Cameraman,
}

const Remotes = Net.CreateDefinitions({
	//Defaults
	SendMessage: Net.Definitions.ServerToClientEvent<[message: string]>(),

	//Picture System
	GetHumanoidDescriptionFromUserId: Net.Definitions.ServerAsyncFunction<(player: Player) => string>(),
	GetPlayer: Net.Definitions.ClientToServerEvent<[]>(),

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
	UpdateInventory:
		Net.Definitions.ServerToClientEvent<[player: Player, item: string, operation: string, quantity: number]>(),
	UpdateInventoryTrading:
		Net.Definitions.ServerToClientEvent<[player: Player, item: string, operation: string, quantity: number]>(),
	AddItemToAllInventories: Net.Definitions.ClientToServerEvent<[item: string]>(),
	RequestAddItemToAllInventories: Net.Definitions.ClientToServerEvent<[item: string]>(),
	RequestRemoveItemFromAllInventories: Net.Definitions.ServerToClientEvent<[item: string]>(),
	LoadProfile: Net.Definitions.ClientToServerEvent<[]>(),
	SaveCurrentInventory: Net.Definitions.ClientToServerEvent<[player: Player]>(),
	//AI System
	SpawnAI: Net.Definitions.ServerToClientEvent<[aiId: string, spawnLocation: Vector3]>(), // Server tells client to spawn an AI with a specific ID at a given location
	RequestSpawnAI: Net.Definitions.ClientToServerEvent<[aiType: string, spawnLocation: Vector3]>(), // Client asks server to spawn an AI of a specific type at a given location

	//Death System
	PlayerDeathEvent: Net.Definitions.ServerToClientEvent<[player: Player, message: string, hint: string]>(), // Server tells client to show Death Screen

	//Disable Player Controls
	disablePlayerControls: Net.Definitions.ClientToServerEvent<[player: Player]>(),

	//Match Making System
	ExecuteMatch: Net.Definitions.ServerToClientEvent<[player: Player]>(),
	RequestToCancelMatch: Net.Definitions.ServerToClientEvent<[player: Player]>(),
	JoinMatch: Net.Definitions.ClientToServerEvent<[]>(),
	LeaveMatch: Net.Definitions.ClientToServerEvent<[]>(),
	TeleportMatch: Net.Definitions.ClientToServerEvent<[]>(),
	UpdatePlayerCount: Net.Definitions.ServerToClientEvent<[queuedPlayerCount: number]>(),
	UpdateQueueMembers: Net.Definitions.ServerToClientEvent<[players: Player[]]>(),
	StartGame: Net.Definitions.ServerToClientEvent<[]>(),
	CancelGame: Net.Definitions.ServerToClientEvent<[]>(),
	QueueStateChange: Net.Definitions.ServerToClientEvent<[QueueState: QueueState]>(),
	ExtractToLobby: Net.Definitions.ClientToServerEvent<[player: Player]>(),

	// Party System
	InvitePlayerToParty: Net.Definitions.ClientToServerEvent<[invitedPlayerId: number]>(),
	OnPlayerInvitedToParty: Net.Definitions.ServerToClientEvent<[invitedPlayer: Player, invitingPlayer: Player]>(),
	RespondToPartyInvitation:
		Net.Definitions.ClientToServerEvent<[invitedPlayerId: number, invitingPlayer: number, accepted: boolean]>(),

	AcceptInvite: Net.Definitions.ClientToServerEvent<[hostPlayerId: string]>(),
	RemovePlayerFromParty: Net.Definitions.ClientToServerEvent<[playerId: string]>(),
	ChangeHost: Net.Definitions.ClientToServerEvent<[newHostPlayerId: string]>(),
	KickPlayerFromParty: Net.Definitions.ClientToServerEvent<[targetPlayerId: string]>(),
	GetPartyMembers: Net.Definitions.ServerAsyncFunction<(hostPlayerId: string) => Promise<string[]>>(),
	PartyUpdate: Net.Definitions.ServerToClientEvent<[hostPlayerId: string, partyMembers: number[]]>(),

	RequestQueue: Net.Definitions.ClientToServerEvent<[partyMembers: number[], operation: string]>(),
	EnterQueue: Net.Definitions.ServerToClientEvent<[]>(),
	ExitQueue: Net.Definitions.ServerToClientEvent<[]>(),

	//Class System
	PlayerProfessionUpdate: Net.Definitions.ServerToClientEvent<[profession: string]>(),
	SendPartyMemberofClassEvent: Net.Definitions.ServerToClientEvent<[members: Player[], profession: string]>(),
	RequestProfessionUpdate: Net.Definitions.ClientToServerEvent<[profession: string]>(),
	RequestPartyMemberofClassEvent: Net.Definitions.ClientToServerEvent<[profession: string]>(),

	GetInventory: Net.Definitions.ServerAsyncFunction<(player: Player) => Promise<Inventory>>(),

	//Currency System
	//TODO: Doesn't like same events with different Page context switching...?
	//Must define different events for each Pages.
	UpdateCurrency: Net.Definitions.ServerToClientEvent<[player: Player, currency: number]>(),
	UpdateCurrencyTwitter: Net.Definitions.ServerToClientEvent<[player: Player, currency: number]>(),

	GetCurrency: Net.Definitions.ServerAsyncFunction<(player: Player) => Promise<number>>(),

	//Trade Mechanic
	TradeRequest: Net.Definitions.ClientToServerEvent<[currency: number, new_inventory: { [key: string]: number }]>(),

	//Twitter System
	CheckIfReedem: Net.Definitions.ServerAsyncFunction<() => Promise<boolean>>(),
	ReedemTwitterCode: Net.Definitions.ServerAsyncFunction<(code: string) => string>(),

	//Leaderboard system
	//-- Donation
	GetDonationData: Net.Definitions.ServerAsyncFunction<() => Promise<LeaderboardData[]>>(),
	// -- Successfull Expeditions
	GetExpeditionData: Net.Definitions.ServerAsyncFunction<() => Promise<ExpeditionData[]>>(),

	UpdateProfession: Net.Definitions.ServerToClientEvent<[profession: PlayerClass]>(),
});
export default Remotes;
