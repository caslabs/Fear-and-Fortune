-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local ContextActionService = _services.ContextActionService
local Players = _services.Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
-- TODO: Is Self Damage a useful mechanic?
local _SpawnBehindPlayerEvent = Remotes.Client:Get("_SpawnBehindPlayer")
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
		-- ContextActionService.BindAction(this.actionName, (_, state) => this.handleInput(state), false, Enum.KeyCode.V);
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
		_SpawnBehindPlayerEvent:SendToServer(Players.LocalPlayer)
		print("[AMBUSH] Spawned behind player!")
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
Reflect.defineMetadata(SelfDamageController, "identifier", "game/src/mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/self-damage-controller@SelfDamageController")
Reflect.defineMetadata(SelfDamageController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(SelfDamageController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(SelfDamageController, "$:flamework@Controller", Controller, { {} })
return {
	default = SelfDamageController,
}
