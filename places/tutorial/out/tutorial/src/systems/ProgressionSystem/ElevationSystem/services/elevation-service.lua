-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local UpdateElevationEvent = Remotes.Server:Get("UpdateElevationEvent")
local ElevationSystem
do
	ElevationSystem = setmetatable({}, {
		__tostring = function()
			return "ElevationSystem"
		end,
	})
	ElevationSystem.__index = ElevationSystem
	function ElevationSystem.new(...)
		local self = setmetatable({}, ElevationSystem)
		return self:constructor(...) or self
	end
	function ElevationSystem:constructor()
		self.playerElevation = {}
	end
	function ElevationSystem:onStart()
		print("ElevationSystem Service started")
		Players.PlayerAdded:Connect(function(player)
			return self:initializePlayer(player)
		end)
	end
	ElevationSystem.initializePlayer = TS.async(function(self, player)
		-- TODO: This is a hack, need to use character-controller to get the player's elevation
		local character
		if player.Character then
			character = player.Character
		else
			character = (TS.await({ player.CharacterAdded:Wait() }))[1]
		end
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		-- Keep sending elevation data to the server
		-- TODO: Still need to figure out how elevation is going to be used in our game system
		while character do
			wait(60)
			-- Get the player's current elevation
			local elevation = humanoidRootPart.Position.Y
			self.playerElevation[player] = elevation
			-- Send the player's current elevation to the client
			UpdateElevationEvent:SendToPlayer(player, player, elevation)
		end
	end)
end
-- (Flamework) ElevationSystem metadata
Reflect.defineMetadata(ElevationSystem, "identifier", "tutorial/src/systems/ProgressionSystem/ElevationSystem/services/elevation-service@ElevationSystem")
Reflect.defineMetadata(ElevationSystem, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(ElevationSystem, "$:flamework@Service", Service, { {} })
return {
	ElevationSystem = ElevationSystem,
}
