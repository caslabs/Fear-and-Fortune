-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local RespawnMechanic
do
	RespawnMechanic = setmetatable({}, {
		__tostring = function()
			return "RespawnMechanic"
		end,
	})
	RespawnMechanic.__index = RespawnMechanic
	function RespawnMechanic.new(...)
		local self = setmetatable({}, RespawnMechanic)
		return self:constructor(...) or self
	end
	function RespawnMechanic:constructor()
	end
	function RespawnMechanic:onStart()
		print("RespawnMechanic Service started")
		local ToggleRespawn = Remotes.Server:Get("ToggleRespawn")
		-- Listen for ToggleRespawn event from server, and disable respawning if it's enabled
		ToggleRespawn:Connect(function(respawnEnabled)
			if respawnEnabled then
				-- Don't respawn player
				print("[INFO] Disabling respawn...")
				-- Set Player's CharacterAutoLoads to false, apparantly this is the only way to disable respawning
				-- only in the server...
				Players.CharacterAutoLoads = false
			end
		end)
	end
end
-- (Flamework) RespawnMechanic metadata
Reflect.defineMetadata(RespawnMechanic, "identifier", "tutorial/src/mechanics/PlayerMechanics/RespawnMechanic/services/respawn-service@RespawnMechanic")
Reflect.defineMetadata(RespawnMechanic, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(RespawnMechanic, "$:flamework@Service", Service, { {} })
return {
	default = RespawnMechanic,
}
