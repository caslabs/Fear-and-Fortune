-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local MoraleUpdateEvent = Signals.MoraleUpdate
local MoraleController
do
	MoraleController = setmetatable({}, {
		__tostring = function()
			return "MoraleController"
		end,
	})
	MoraleController.__index = MoraleController
	function MoraleController.new(...)
		local self = setmetatable({}, MoraleController)
		return self:constructor(...) or self
	end
	function MoraleController:constructor(characterController)
		self.characterController = characterController
		self.morale = 0
	end
	function MoraleController:onInit()
	end
	function MoraleController:onStart()
	end
	MoraleController.increaseMorale = TS.async(function(self)
		self.morale += 1
		TS.await(self:updateMorale())
		print("Player " .. (Players.LocalPlayer.Name .. ("'s morale increased to: " .. tostring(self.morale))))
	end)
	MoraleController.updateMorale = TS.async(function(self)
		MoraleUpdateEvent:Fire(Players.LocalPlayer, self.morale)
	end)
end
-- (Flamework) MoraleController metadata
Reflect.defineMetadata(MoraleController, "identifier", "game/src/mechanics/PlayerMechanics/ResourceMechanic/controller/morale-controller@MoraleController")
Reflect.defineMetadata(MoraleController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(MoraleController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(MoraleController, "$:flamework@Controller", Controller, { {} })
return {
	default = MoraleController,
}
