-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local maxStamina = 100
local staminaDecrease = 10
local staminaIncrease = 1
local staminaDecreaseInterval = 0.1
local staminaIncreaseInterval = 0.1
local staminaRecoveryThreshold = maxStamina * 0.5
local jumpDelay = 1
local StaminaUpdate = Signal.new()
local StaminaController
do
	StaminaController = setmetatable({}, {
		__tostring = function()
			return "StaminaController"
		end,
	})
	StaminaController.__index = StaminaController
	function StaminaController.new(...)
		local self = setmetatable({}, StaminaController)
		return self:constructor(...) or self
	end
	function StaminaController:constructor(characterController)
		self.characterController = characterController
		self.maxStamina = 100
		self.stamina = self.maxStamina
		self.staminaDecreaseInterval = 0.1
		self.staminaIncreaseInterval = 0.1
		self.staminaRecoveryThreshold = self.maxStamina * 0.5
		self.hasStaminaDepleted = false
	end
	function StaminaController:onInit()
	end
	function StaminaController:onStart()
		Signals.jumpingStateChanged:Connect(function(isJumping)
			if isJumping then
				task.spawn(function()
					return self:staminaUpdate(-10)
				end)
			else
				task.spawn(function()
					return self:staminaUpdate(1)
				end)
			end
		end)
		Signals.onStartStamina:Connect(function(isSprinting)
			if isSprinting then
				task.spawn(function()
					return self:staminaUpdate(-1)
				end)
			else
				task.spawn(function()
					return self:staminaUpdate(1)
				end)
			end
		end)
	end
	StaminaController.staminaUpdate = TS.async(function(self, staminaChange)
		local character = self.characterController:getCurrentCharacter()
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChildOfClass("Humanoid")
		end
		local humanoid = _humanoid
		-- Don't decrease stamina if it's already depleted
		if self.hasStaminaDepleted and staminaChange < 0 then
			return nil
		end
		self.stamina += staminaChange
		if self.stamina <= 0 then
			self.stamina = 0
			self.hasStaminaDepleted = true
			SoundSystemController:playSound(SoundKeys.SFX_STAMINA_LOW_BREATHING, 10)
		elseif self.stamina >= self.maxStamina then
			self.stamina = self.maxStamina
		end
		StaminaUpdate:Fire(Players.LocalPlayer, self.stamina)
		if self.stamina >= self.staminaRecoveryThreshold then
			self.hasStaminaDepleted = false
		end
		TS.await(TS.Promise.delay(if self.hasStaminaDepleted then self.staminaIncreaseInterval else self.staminaDecreaseInterval))
	end)
end
-- (Flamework) StaminaController metadata
Reflect.defineMetadata(StaminaController, "identifier", "game/src/mechanics/PlayerMechanics/ResourceMechanic/controller/stamina-controller@StaminaController")
Reflect.defineMetadata(StaminaController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(StaminaController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(StaminaController, "$:flamework@Controller", Controller, { {} })
return {
	StaminaUpdate = StaminaUpdate,
	default = StaminaController,
}
