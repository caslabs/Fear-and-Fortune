-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local RunService = _services.RunService
local Lighting = _services.Lighting
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
-- Game state for atmosphere
local AtmosphereService
do
	AtmosphereService = setmetatable({}, {
		__tostring = function()
			return "AtmosphereService"
		end,
	})
	AtmosphereService.__index = AtmosphereService
	function AtmosphereService.new(...)
		local self = setmetatable({}, AtmosphereService)
		return self:constructor(...) or self
	end
	function AtmosphereService:constructor()
		self.fogDensity = 0.6
	end
	function AtmosphereService:onInit()
		print("AtmosphereService started")
		-- Only start the fog if this is running on the server
		if RunService:IsServer() then
			self:startFog()
		end
	end
	function AtmosphereService:startFog()
		local atmosphere = Lighting:WaitForChild("Atmosphere")
		atmosphere.Density = self.fogDensity
		atmosphere.Offset = 0.095
	end
end
-- (Flamework) AtmosphereService metadata
Reflect.defineMetadata(AtmosphereService, "identifier", "game/src/systems/EnvironmentSystem/TimeSystem/AtmosphereSystem/services/atmosphere-service@AtmosphereService")
Reflect.defineMetadata(AtmosphereService, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(AtmosphereService, "$:flamework@Service", Service, { {
	loadOrder = 0,
} })
return {
	AtmosphereService = AtmosphereService,
}
