-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local ContextActionService = _services.ContextActionService
local Workspace = _services.Workspace
local Players = _services.Players
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
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
local maxStamina = 100
local staminaDecrease = 1
local staminaIncrease = 1
local staminaDecreaseInterval = 0.1
local staminaIncreaseInterval = 0.1
local staminaRecoveryThreshold = maxStamina * 0.5
-- Create signals for the stamina and sprinting state
local StaminaUpdate = Signal.new()
local sprintingStateChanged = Signal.new()
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
	function SprintController:constructor(characterController)
		self.characterController = characterController
		self.isSprinting = false
		self.stamina = maxStamina
		self.hasStaminaDepleted = false
	end
	function SprintController:onInit()
		-- Connect a function that changes the stamina according to the sprinting state
		sprintingStateChanged:Connect(function(isSprinting)
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
			_result = _result.HumanoidRootPart:FindFirstChild("Running")
		end
		local runningSound = _result
		if runningSound then
			runningSound.PlaybackSpeed = 1.5
			print("Running")
		else
			print("No running sound")
		end
		humanoid.WalkSpeed = maxSpeed
		self.isSprinting = true
		sprintingStateChanged:Fire(true)
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
		sprintingStateChanged:Fire(false)
		BreathingSound:Stop()
		print("[STATE] Walking")
	end
	SprintController.sprintingStaminaUpdate = TS.async(function(self)
		-- Decrease stamina while sprinting
		while self.isSprinting and self.stamina > 0 do
			self.stamina -= staminaDecrease
			StaminaUpdate:Fire(Players.LocalPlayer, self.stamina)
			TS.await(TS.Promise.delay(staminaDecreaseInterval))
		end
		-- Stamina has fully depleted
		if self.stamina <= 0 then
			self:stopSprinting()
			self.hasStaminaDepleted = true
			-- Stop Running Breathing and Play intense breathing sound
			BreathingSound:Stop()
			SoundSystemController:playSound(SoundKeys.SFX_STAMINA_LOW_BREATHING, 10)
		end
	end)
	SprintController.walkingStaminaUpdate = TS.async(function(self)
		-- Increase stamina while walking
		while not self.isSprinting and self.stamina < maxStamina do
			self.stamina += staminaIncrease
			StaminaUpdate:Fire(Players.LocalPlayer, self.stamina)
			TS.await(TS.Promise.delay(staminaIncreaseInterval * 2))
		end
		-- Stamina has recovered to threshold
		if self.stamina >= staminaRecoveryThreshold then
			self.hasStaminaDepleted = false
		end
	end)
end
-- (Flamework) SprintController metadata
Reflect.defineMetadata(SprintController, "identifier", "tutorial/src/mechanics/PlayerMechanics/SprintMechanic/controller/stamina-sprint-controller@SprintController")
Reflect.defineMetadata(SprintController, "flamework:parameters", { "tutorial/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(SprintController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(SprintController, "$:flamework@Controller", Controller, { {} })
return {
	StaminaUpdate = StaminaUpdate,
	default = SprintController,
}
