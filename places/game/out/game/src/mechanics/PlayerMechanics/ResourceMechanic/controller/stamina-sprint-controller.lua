-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local ContextActionService = _services.ContextActionService
local Workspace = _services.Workspace
local Players = _services.Players
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local camera = Workspace.CurrentCamera
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
-- TODO: Make this data driven
local sprintMultiplier = 1.45
local baseSpeed = 16
local maxSpeed = baseSpeed * sprintMultiplier
local minSpeed = baseSpeed
-- TODO: Used to be 85, find a good animation for running in first person
local maxFov = 90
local minFov = 70
local startSprintingState = Enum.UserInputState.Begin
local stopSprintingState = Enum.UserInputState.End
-- Create signals for the stamina and sprinting state
-- TODO: Implement "Keep Playing until Stop" based on Events
local BreathingSound = Instance.new("Sound")
BreathingSound.SoundId = "rbxassetid://" .. tostring(13868760809)
BreathingSound.Parent = game:GetService("SoundService")
BreathingSound.Volume = 2
local SprintController
do
	SprintController = setmetatable({}, {
		__tostring = function()
			return "SprintController"
		end,
	})
	SprintController.__index = SprintController
	function SprintController.new(...)
		local self = setmetatable({}, SprintController)
		return self:constructor(...) or self
	end
	function SprintController:constructor(characterController, staminaController)
		self.characterController = characterController
		self.staminaController = staminaController
		self.isSprinting = false
		self.hasStaminaDepleted = false
	end
	function SprintController:onInit()
		-- Connect a function that changes the stamina according to the sprinting state
		Signals.onStartStamina:Connect(function(isSprinting)
			if isSprinting then
				task.spawn(function()
					return self:sprintingStaminaUpdate()
				end)
			else
				task.spawn(function()
					return self:walkingStaminaUpdate()
				end)
			end
		end)
	end
	function SprintController:onStart()
		ContextActionService:BindAction("Sprint", function(_, s)
			return self:handleInput(s)
		end, true, Enum.KeyCode.LeftShift)
		self.characterController.onCharacterAdded:Connect(function()
			if not self.isSprinting then
				return nil
			end
			self:startSprinting()
		end)
	end
	function SprintController:handleInput(state)
		if state == startSprintingState then
			self:startSprinting()
		elseif state == stopSprintingState then
			self:stopSprinting()
		end
	end
	function SprintController:startSprinting()
		-- Prevent sprinting if stamina has depleted fully
		if self.hasStaminaDepleted then
			return nil
		end
		local character = self.characterController:getCurrentCharacter()
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid.Humanoid
		end
		local humanoid = _humanoid
		if not humanoid then
			return nil
		end
		local _result = character
		if _result ~= nil then
			_result = _result.HumanoidRootPart.Position
		end
		self.lastPosition = _result
		local _result_1 = character
		if _result_1 ~= nil then
			_result_1 = _result_1.HumanoidRootPart:FindFirstChild("Running")
		end
		local runningSound = _result_1
		if runningSound then
			runningSound.PlaybackSpeed = 1.5
			print("Running")
		else
			print("No running sound")
		end
		humanoid.WalkSpeed = maxSpeed
		self.isSprinting = true
		Signals.onStartStamina:Fire(true)
		BreathingSound:Play()
		print("[STATE] Sprinting")
	end
	function SprintController:stopSprinting()
		local character = self.characterController:getCurrentCharacter()
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid.Humanoid
		end
		local humanoid = _humanoid
		if not humanoid then
			return nil
		end
		local _result = character
		if _result ~= nil then
			_result = _result.HumanoidRootPart:FindFirstChild("Running")
		end
		local runningSound = _result
		if runningSound then
			runningSound.PlaybackSpeed = 1.3
			print("Running")
		else
			print("No running sound")
		end
		humanoid.WalkSpeed = minSpeed
		self.isSprinting = false
		Signals.onStartStamina:Fire(false)
		BreathingSound:Stop()
		print("[STATE] Walking")
	end
	SprintController.sprintingStaminaUpdate = TS.async(function(self)
		local character = self.characterController:getCurrentCharacter()
		-- Decrease stamina while sprinting
		while self.isSprinting and self.staminaController.stamina > 0 do
			local _result = character
			if _result ~= nil then
				_result = _result.HumanoidRootPart.Position
			end
			if _result ~= self.lastPosition then
				-- Check if player is moving
				self.staminaController.stamina -= 1
				Signals.StaminaUpdate:Fire(Players.LocalPlayer, self.staminaController.stamina)
			end
			local _result_1 = character
			if _result_1 ~= nil then
				_result_1 = _result_1.HumanoidRootPart.Position
			end
			self.lastPosition = _result_1
			TS.await(TS.Promise.delay(self.staminaController.staminaDecreaseInterval))
		end
		-- Stamina has fully depleted
		if self.staminaController.stamina <= 0 then
			self:stopSprinting()
			self.hasStaminaDepleted = true
			-- Stop Running Breathing and Play intense breathing sound
			BreathingSound:Stop()
			SoundSystemController:playSound(SoundKeys.SFX_STAMINA_LOW_BREATHING, 10)
		end
	end)
	SprintController.walkingStaminaUpdate = TS.async(function(self)
		-- Increase stamina while walking
		while not self.isSprinting and self.staminaController.stamina < self.staminaController.maxStamina do
			self.staminaController.stamina += 1
			Signals.StaminaUpdate:Fire(Players.LocalPlayer, self.staminaController.stamina)
			TS.await(TS.Promise.delay(self.staminaController.staminaIncreaseInterval * 2))
		end
		-- Stamina has recovered to threshold
		if self.staminaController.stamina >= self.staminaController.staminaRecoveryThreshold then
			self.hasStaminaDepleted = false
		end
	end)
end
-- (Flamework) SprintController metadata
Reflect.defineMetadata(SprintController, "identifier", "game/src/mechanics/PlayerMechanics/ResourceMechanic/controller/stamina-sprint-controller@SprintController")
Reflect.defineMetadata(SprintController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic", "game/src/mechanics/PlayerMechanics/ResourceMechanic/controller/stamina-controller@StaminaController" })
Reflect.defineMetadata(SprintController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(SprintController, "$:flamework@Controller", Controller, { {} })
return {
	default = SprintController,
}
