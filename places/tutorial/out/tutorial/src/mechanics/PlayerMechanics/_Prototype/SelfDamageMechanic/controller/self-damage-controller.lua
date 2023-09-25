-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local ContextActionService = TS.import(script, TS.getModule(script, "@rbxts", "services")).ContextActionService
-- TODO: Is Self Damage a useful mechanic?
local SelfDamageController
do
	SelfDamageController = setmetatable({}, {
		__tostring = function()
			return "SelfDamageController"
		end,
	})
	SelfDamageController.__index = SelfDamageController
	function SelfDamageController.new(...)
		local self = setmetatable({}, SelfDamageController)
		return self:constructor(...) or self
	end
	function SelfDamageController:constructor(characterController)
		self.characterController = characterController
		self.actionName = "DamageSelf"
	end
	function SelfDamageController:onInit()
		print("SelfDamageController initialized")
	end
	function SelfDamageController:onStart()
		print("SelfDamageController started")
		ContextActionService:BindAction(self.actionName, function(_, state)
			return self:handleInput(state)
		end, false, Enum.KeyCode.G)
		self.characterController.onCharacterAdded:Connect(function(character)
			return self:bindToDamageSelf(character)
		end)
		self.characterController.onCharacterRemoved:Connect(function()
			return self:unbindFromDamageSelf()
		end)
	end
	function SelfDamageController:handleInput(state)
		if state ~= Enum.UserInputState.Begin then
			return nil
		end
		local character = self.characterController:getCurrentCharacter()
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChildOfClass("Humanoid")
		end
		local humanoid = _humanoid
		if humanoid then
			humanoid.Health -= 10
		end
	end
	function SelfDamageController:bindToDamageSelf(character)
		self:unbindFromDamageSelf()
		ContextActionService:BindAction(self.actionName, function(_, state)
			return self:handleInput(state)
		end, false, Enum.KeyCode.G)
	end
	function SelfDamageController:unbindFromDamageSelf()
		ContextActionService:UnbindAction(self.actionName)
	end
end
-- (Flamework) SelfDamageController metadata
Reflect.defineMetadata(SelfDamageController, "identifier", "tutorial/src/mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/self-damage-controller@SelfDamageController")
Reflect.defineMetadata(SelfDamageController, "flamework:parameters", { "tutorial/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(SelfDamageController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(SelfDamageController, "$:flamework@Controller", Controller, { {} })
return {
	default = SelfDamageController,
}
