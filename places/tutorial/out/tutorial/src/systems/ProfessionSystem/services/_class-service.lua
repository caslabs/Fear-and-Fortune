-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local DataStoreService = TS.import(script, TS.getModule(script, "@rbxts", "services")).DataStoreService
local UpdatePlayerClassEvent = Remotes.Server:Get("UpdatePlayerClass")
local ClassService
do
	ClassService = setmetatable({}, {
		__tostring = function()
			return "ClassService"
		end,
	})
	ClassService.__index = ClassService
	function ClassService.new(...)
		local self = setmetatable({}, ClassService)
		return self:constructor(...) or self
	end
	function ClassService:constructor()
		self.classStore = DataStoreService:GetDataStore("PlayerClass")
		self.playerClasses = {}
	end
	ClassService.setPlayerClass = TS.async(function(self, player, playerClass)
		TS.await(self.classStore:SetAsync(tostring(player.UserId), playerClass))
		self.playerClasses[player] = playerClass
		UpdatePlayerClassEvent:SendToAllPlayers(player.UserId, playerClass)
	end)
	ClassService.getPlayerClass = TS.async(function(self, player)
		if self.playerClasses[player] ~= nil then
			-- If the player's class is cached, return the cached value
			return self.playerClasses[player]
		end
		local data = TS.await({ self.classStore:GetAsync(tostring(player.UserId)) })
		local playerClass = if type(data) == "string" then data else nil
		if not (playerClass ~= "" and playerClass) then
			TS.await(self:setPlayerClass(player, "Soldier"))
			print("Player class not found, setting it to Soldier")
			return "Soldier"
		end
		print("data: " .. tostring(data))
		print("playerClass: " .. playerClass)
		self.playerClasses[player] = playerClass
		print("Setted player class: " .. playerClass)
		return unpack(playerClass)
	end)
	function ClassService:onStart()
		print("ClassSystem Service Started")
		Players.PlayerAdded:Connect(TS.async(function(newPlayer)
			-- First attempt to fetch the class of the new player from datastore
			local playerClass = TS.await(self:getPlayerClass(newPlayer))
			if not (playerClass ~= "" and playerClass) then
				-- If the class doesn't exist in the datastore, then set the default class
				TS.await(self:setPlayerClass(newPlayer, "Soldier"))
				playerClass = "Soldier"
			end
			print("[DATASTORE] Class: " .. playerClass)
			-- Then send the updated class list of all existing players
			local _exp = Players:GetPlayers()
			local _arg0 = TS.async(function(player)
				if player == newPlayer then
					return nil
				end
				local playerClass = TS.await({ self.classStore:GetAsync(tostring(player.UserId)) })
				UpdatePlayerClassEvent:SendToPlayer(newPlayer, player.UserId, playerClass)
			end)
			for _k, _v in ipairs(_exp) do
				_arg0(_v, _k - 1, _exp)
			end
		end))
		Players.PlayerRemoving:Connect(TS.async(function(player)
			TS.await(self:setPlayerClass(player, self.playerClasses[player]))
			self.playerClasses[player] = nil
		end))
		-- Inside the ClassSystem Service constructor or the 'onStart' method
		local SetPlayerClassEvent = Remotes.Server:Get("SetPlayerClass")
		local GetPlayerClassEvent = Remotes.Server:Get("GetPlayerClass")
		SetPlayerClassEvent:Connect(TS.async(function(player, playerClass)
			print("Setting class for player " .. (tostring(player.UserId) .. (" to " .. playerClass)))
			TS.await(self:setPlayerClass(player, playerClass))
		end))
		GetPlayerClassEvent:SetCallback(TS.async(function(player)
			return self:getPlayerClass(player)
		end))
	end
end
-- (Flamework) ClassService metadata
Reflect.defineMetadata(ClassService, "identifier", "tutorial/src/systems/ProfessionSystem/services/_class-service@ClassService")
Reflect.defineMetadata(ClassService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(ClassService, "$:flamework@Service", Service, { {
	loadOrder = 0,
} })
return {
	default = ClassService,
}
