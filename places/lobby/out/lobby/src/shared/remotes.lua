-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Net = TS.import(script, TS.getModule(script, "@rbxts", "net").out)
local PlayerClass
do
	local _inverse = {}
	PlayerClass = setmetatable({}, {
		__index = _inverse,
	})
	PlayerClass.Mountaineer = 0
	_inverse[0] = "Mountaineer"
	PlayerClass.Soldier = 1
	_inverse[1] = "Soldier"
	PlayerClass.Engineer = 2
	_inverse[2] = "Engineer"
	PlayerClass.Doctor = 3
	_inverse[3] = "Doctor"
	PlayerClass.Scholar = 4
	_inverse[4] = "Scholar"
	PlayerClass.Cameraman = 5
	_inverse[5] = "Cameraman"
end
local Remotes = Net.CreateDefinitions({
	SendMessage = Net.Definitions.ServerToClientEvent(),
	GetHumanoidDescriptionFromUserId = Net.Definitions.ServerAsyncFunction(),
	GetPlayer = Net.Definitions.ClientToServerEvent(),
	ToggleRespawn = Net.Definitions.ClientToServerEvent(),
	PlayMusic = Net.Definitions.ServerToClientEvent(),
	RequestMusicPlay = Net.Definitions.ClientToServerEvent(),
	DecreaseSanityEvent = Net.Definitions.ClientToServerEvent(),
	UpdateSanityEvent = Net.Definitions.ServerToClientEvent(),
	CompleteObjectiveEvent = Net.Definitions.ServerAsyncFunction(),
	UpdateElevationEvent = Net.Definitions.ServerToClientEvent(),
	PlayerLocationEvent = Net.Definitions.ServerToClientEvent(),
	UpdateInventory = Net.Definitions.ServerToClientEvent(),
	UpdateInventoryTrading = Net.Definitions.ServerToClientEvent(),
	AddItemToAllInventories = Net.Definitions.ClientToServerEvent(),
	RequestAddItemToAllInventories = Net.Definitions.ClientToServerEvent(),
	RequestRemoveItemFromAllInventories = Net.Definitions.ServerToClientEvent(),
	LoadProfile = Net.Definitions.ClientToServerEvent(),
	SaveCurrentInventory = Net.Definitions.ClientToServerEvent(),
	SpawnAI = Net.Definitions.ServerToClientEvent(),
	RequestSpawnAI = Net.Definitions.ClientToServerEvent(),
	PlayerDeathEvent = Net.Definitions.ServerToClientEvent(),
	disablePlayerControls = Net.Definitions.ClientToServerEvent(),
	ExecuteMatch = Net.Definitions.ServerToClientEvent(),
	RequestToCancelMatch = Net.Definitions.ServerToClientEvent(),
	JoinMatch = Net.Definitions.ClientToServerEvent(),
	LeaveMatch = Net.Definitions.ClientToServerEvent(),
	TeleportMatch = Net.Definitions.ClientToServerEvent(),
	UpdatePlayerCount = Net.Definitions.ServerToClientEvent(),
	UpdateQueueMembers = Net.Definitions.ServerToClientEvent(),
	StartGame = Net.Definitions.ServerToClientEvent(),
	CancelGame = Net.Definitions.ServerToClientEvent(),
	QueueStateChange = Net.Definitions.ServerToClientEvent(),
	ExtractToLobby = Net.Definitions.ClientToServerEvent(),
	InvitePlayerToParty = Net.Definitions.ClientToServerEvent(),
	OnPlayerInvitedToParty = Net.Definitions.ServerToClientEvent(),
	RespondToPartyInvitation = Net.Definitions.ClientToServerEvent(),
	AcceptInvite = Net.Definitions.ClientToServerEvent(),
	RemovePlayerFromParty = Net.Definitions.ClientToServerEvent(),
	ChangeHost = Net.Definitions.ClientToServerEvent(),
	KickPlayerFromParty = Net.Definitions.ClientToServerEvent(),
	GetPartyMembers = Net.Definitions.ServerAsyncFunction(),
	PartyUpdate = Net.Definitions.ServerToClientEvent(),
	RequestQueue = Net.Definitions.ClientToServerEvent(),
	EnterQueue = Net.Definitions.ServerToClientEvent(),
	ExitQueue = Net.Definitions.ServerToClientEvent(),
	PlayerProfessionUpdate = Net.Definitions.ServerToClientEvent(),
	SendPartyMemberofClassEvent = Net.Definitions.ServerToClientEvent(),
	RequestProfessionUpdate = Net.Definitions.ClientToServerEvent(),
	RequestPartyMemberofClassEvent = Net.Definitions.ClientToServerEvent(),
	GetInventory = Net.Definitions.ServerAsyncFunction(),
	UpdateCurrency = Net.Definitions.ServerToClientEvent(),
	UpdateCurrencyTwitter = Net.Definitions.ServerToClientEvent(),
	GetCurrency = Net.Definitions.ServerAsyncFunction(),
	TradeRequest = Net.Definitions.ClientToServerEvent(),
	CheckIfReedem = Net.Definitions.ServerAsyncFunction(),
	ReedemTwitterCode = Net.Definitions.ServerAsyncFunction(),
	GetDonationData = Net.Definitions.ServerAsyncFunction(),
	GetExpeditionData = Net.Definitions.ServerAsyncFunction(),
	UpdateProfession = Net.Definitions.ServerToClientEvent(),
})
local default = Remotes
return {
	default = default,
}
