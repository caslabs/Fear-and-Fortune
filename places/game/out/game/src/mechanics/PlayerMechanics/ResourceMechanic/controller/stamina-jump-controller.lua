-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local UserInputService = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local jumpDelay = 3
local JumpController
do
	JumpController = setmetatable({}, {
		__tostring = function()
			return "JumpController"
		end,
	})
	JumpController.__index = JumpController
	function JumpController.new(...)
		local self = setmetatable({}, JumpController)
		return self:constructor(...) or self
	end
	function JumpController:constructor(characterController, staminaController)
		self.characterController = characterController
		self.staminaController = staminaController
		self.canJump = true
	end
	function JumpController:onInit()
		Signals.jumpingStateChanged:Connect(function(isJumping)
			if isJumping then
				task.spawn(function()
					return self.staminaController:staminaUpdate(-10)
				end)
			else
				task.spawn(function()
					return self.staminaController:staminaUpdate(1)
				end)
			end
		end)
	end
	function JumpController:onStart()
		print("Stamina Jump Controller started")
		UserInputService.JumpRequest:Connect(function()
			self:handleJumpRequest()
		end)
	end
	function JumpController:handleJumpRequest()
		local character = self.characterController:getCurrentCharacter()
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChildOfClass("Humanoid")
		end
		local humanoid = _humanoid
		if not humanoid or not self.canJump then
			return nil
		end
		self.canJump = false
		self.originalJumpPower = humanoid.JumpPower
		humanoid.JumpPower = 11
		-- Handle jump and delay asynchronously
		self:jumpAndDelay(humanoid)
	end
	JumpController.jumpAndDelay = TS.async(function(self, humanoid)
		-- Wait for the jump delay
		TS.await(TS.Promise.delay(jumpDelay))
		-- Ensure the humanoid and originalJumpPower are still valid
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		local _condition = not humanoid
		if not _condition then
			local _value = self.originalJumpPower
			_condition = not (_value ~= 0 and (_value == _value and _value))
		end
		if _condition then
			return nil
		end
		-- Enable jumping again
		humanoid.JumpPower = 0
		self.canJump = true
	end)
end
-- (Flamework) JumpController metadata
Reflect.defineMetadata(JumpController, "identifier", "game/src/mechanics/PlayerMechanics/ResourceMechanic/controller/stamina-jump-controller@JumpController")
Reflect.defineMetadata(JumpController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic", "game/src/mechanics/PlayerMechanics/ResourceMechanic/controller/stamina-controller@StaminaController" })
Reflect.defineMetadata(JumpController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(JumpController, "$:flamework@Controller", Controller, { {} })
return {
	default = JumpController,
}
