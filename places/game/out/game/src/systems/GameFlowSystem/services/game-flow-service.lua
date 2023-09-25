-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local TeleportService = _services.TeleportService
local DataStoreService = _services.DataStoreService
local ServerStorage = _services.ServerStorage
local Workspace = _services.Workspace
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local ExtractToLobbyEvent = Remotes.Server:Get("ExtractToLobby")
local UpdateExpeditionCountEvent = Remotes.Server:Get("UpdateExpeditionCount")
local GameFlowSystemService
do
	GameFlowSystemService = setmetatable({}, {
		__tostring = function()
			return "GameFlowSystemService"
		end,
	})
	GameFlowSystemService.__index = GameFlowSystemService
	function GameFlowSystemService.new(...)
		local self = setmetatable({}, GameFlowSystemService)
		return self:constructor(...) or self
	end
	function GameFlowSystemService:constructor(inventorySystem, profileService)
		self.inventorySystem = inventorySystem
		self.profileService = profileService
		self.ExpeditionData = DataStoreService:GetOrderedDataStore("ExpeditionLeaderboard")
	end
	function GameFlowSystemService:onInit()
		local _AxeTool = ServerStorage:FindFirstChild("AxeToolTrigger")
		if _AxeTool ~= nil then
			_AxeTool = _AxeTool:Clone()
		end
		local AxeTool = _AxeTool
		if AxeTool then
			AxeTool.Name = "AxeToolTrigger"
			AxeTool.Parent = Workspace
			print("AxeToolTrigger Cloned")
		end
		print("GameFlowSystem Service Initialized")
	end
	function GameFlowSystemService:onStart()
		-- Set 'HasExtracted' attribute to false for each player when they join
		-- _DEV
		Players.PlayerAdded:Connect(function(player)
			player:SetAttribute("HasExtracted", false)
		end)
		local isExtractEvent = Remotes.Server:Get("IsExtracted")
		isExtractEvent:Connect(function(player)
			player:SetAttribute("HasExtracted", true)
			print("[GAME FLOW EVENT] " .. player.Name .. " HasExtracted", (player:GetAttribute("HasExtracted")))
		end)
		--[[
			// Also set 'HasExtracted' to false for all players currently in the game
			for (const player of Players.GetPlayers()) {
			player.SetAttribute("HasExtracted", false);
			}
		]]
		ExtractToLobbyEvent:Connect(function(player)
			self:extractToLobby(player)
		end)
		UpdateExpeditionCountEvent:Connect(function(player)
			self:incrementSuccessfulExpeditions(player)
			print("[GAME FLOW] Updated Profiles Expedition Count for " .. player.Name)
		end)
		print("GameFlowSystem Service Started")
	end
	function GameFlowSystemService:extractToLobby(player)
		-- Save Inventory to ProfileService
		local hasExtracted = player:GetAttribute("HasExtracted")
		print("[GAME FLOW] " .. player.Name .. " hasAttacted", (player:GetAttribute("HasExtracted")))
		if hasExtracted == true then
			self.inventorySystem:saveInventory(player)
			print("[GAME FLOW] Saved inventory for " .. player.Name)
			TeleportService:Teleport(13733616492, player)
			print("[GAME FLOW] Teleported " .. player.Name .. " to lobby")
		else
			print("[GAME FLOW] " .. player.Name .. " has not extracted. Not saving profile")
			TeleportService:Teleport(13733616492, player)
			print("[GAME FLOW] Teleported " .. player.Name .. " to lobby")
		end
	end
	GameFlowSystemService.incrementSuccessfulExpeditions = TS.async(function(self, player)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		if profile then
			-- Update the leaderboard aswell
			profile.Data.successful_expeditions += 1
			self.ExpeditionData:SetAsync(tostring(player.UserId), profile.Data.successful_expeditions)
			print("[EXPEDITION DATA] Updated Expedition Data for " .. player.Name .. " " .. tostring(profile.Data.successful_expeditions))
		else
			warn("Unable to fetch profile for player " .. (player.Name .. "."))
		end
	end)
end
-- (Flamework) GameFlowSystemService metadata
Reflect.defineMetadata(GameFlowSystemService, "identifier", "game/src/systems/GameFlowSystem/services/game-flow-service@GameFlowSystemService")
Reflect.defineMetadata(GameFlowSystemService, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService", "game/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic" })
Reflect.defineMetadata(GameFlowSystemService, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(GameFlowSystemService, "$:flamework@Service", Service, { {} })
return {
	default = GameFlowSystemService,
}
