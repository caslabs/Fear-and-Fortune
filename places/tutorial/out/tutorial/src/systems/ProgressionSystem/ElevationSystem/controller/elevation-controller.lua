-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
-- client/controller/elevation-mechanic-controller.ts
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local ElevationMechanicController
do
	ElevationMechanicController = setmetatable({}, {
		__tostring = function()
			return "ElevationMechanicController"
		end,
	})
	ElevationMechanicController.__index = ElevationMechanicController
	function ElevationMechanicController.new(...)
		local self = setmetatable({}, ElevationMechanicController)
		return self:constructor(...) or self
	end
	function ElevationMechanicController:constructor(characterController)
		self.characterController = characterController
	end
	function ElevationMechanicController:getElevationChanged()
		return Signals.playerElevationChanged
	end
	function ElevationMechanicController:onInit()
	end
	function ElevationMechanicController:onStart()
		print("ElevationMechanic Controller started")
		local player = Players.LocalPlayer
		if player then
			-- Deploy Character Controller
			wait(5)
			self:setCharacter(self.characterController:getCurrentCharacter())
			self.characterController.onCharacterAdded:Connect(function(character)
				return self:setCharacter(character)
			end)
			-- Run every frame
			RunService.RenderStepped:Connect(function()
				if self.humanoid then
					local elevation = self.humanoid.Position.Y
					Signals.playerElevationChanged:Fire(player, elevation)
				end
			end)
		end
	end
	function ElevationMechanicController:setCharacter(character)
		local _result = character
		if _result ~= nil then
			_result = _result.HumanoidRootPart
		end
		self.humanoid = _result
		if not self.humanoid then
			print("Humanoid not found")
			return nil
		end
	end
end
-- (Flamework) ElevationMechanicController metadata
Reflect.defineMetadata(ElevationMechanicController, "identifier", "tutorial/src/systems/ProgressionSystem/ElevationSystem/controller/elevation-controller@ElevationMechanicController")
Reflect.defineMetadata(ElevationMechanicController, "flamework:parameters", { "tutorial/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(ElevationMechanicController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(ElevationMechanicController, "$:flamework@Controller", Controller, { {
	loadOrder = 3,
} })
return {
	default = ElevationMechanicController,
}
