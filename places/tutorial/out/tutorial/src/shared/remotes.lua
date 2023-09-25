-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Net = TS.import(script, TS.getModule(script, "@rbxts", "net").out)
local Remotes = Net.CreateDefinitions({
	SendMessage = Net.Definitions.ServerToClientEvent(),
	ToggleRespawn = Net.Definitions.ClientToServerEvent(),
	PlayMusic = Net.Definitions.ServerToClientEvent(),
	RequestMusicPlay = Net.Definitions.ClientToServerEvent(),
	DecreaseSanityEvent = Net.Definitions.ClientToServerEvent(),
	UpdateSanityEvent = Net.Definitions.ServerToClientEvent(),
	CompleteObjectiveEvent = Net.Definitions.ServerAsyncFunction(),
	UpdateElevationEvent = Net.Definitions.ServerToClientEvent(),
	PlayerLocationEvent = Net.Definitions.ServerToClientEvent(),
	UpdateInventory = Net.Definitions.ServerToClientEvent(),
	AddItemToAllInventories = Net.Definitions.ClientToServerEvent(),
	RequestAddItemToAllInventories = Net.Definitions.ClientToServerEvent(),
	RequestRemoveItemFromAllInventories = Net.Definitions.ServerToClientEvent(),
	SpawnAI = Net.Definitions.ServerToClientEvent(),
	RequestSpawnAI = Net.Definitions.ClientToServerEvent(),
	SetPlayerClass = Net.Definitions.ClientToServerEvent(),
	GetPlayerClass = Net.Definitions.ServerAsyncFunction(),
	UpdatePlayerClass = Net.Definitions.ServerToClientEvent(),
	PlayerDeathEvent = Net.Definitions.ServerToClientEvent(),
})
local default = Remotes
return {
	default = default,
}
