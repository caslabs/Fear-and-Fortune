-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
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
	function RespawnMechanic:constructor(lifeMechanic)
		self.lifeMechanic = lifeMechanic
	end
	function RespawnMechanic:onInit()
	end
	function RespawnMechanic:onStart()
		print("RespawnMechanic Controller started")
	end
end
-- (Flamework) RespawnMechanic metadata
Reflect.defineMetadata(RespawnMechanic, "identifier", "game/src/mechanics/PlayerMechanics/RespawnMechanic/controller/respawn-controller@RespawnMechanic")
Reflect.defineMetadata(RespawnMechanic, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/LifeMechanic/controller/life-controller@LifeMechanic" })
Reflect.defineMetadata(RespawnMechanic, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(RespawnMechanic, "$:flamework@Controller", Controller, {})
return {
	default = RespawnMechanic,
}
