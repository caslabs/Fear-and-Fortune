-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local ReplicatedStorage = _services.ReplicatedStorage
local ContextActionService = _services.ContextActionService
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local isCrouchingEvent = Remotes.Client:Get("IsCrouching")
local CrouchController
do
	CrouchController = setmetatable({}, {
		__tostring = function()
			return "CrouchController"
		end,
	})
	CrouchController.__index = CrouchController
	function CrouchController.new(...)
		local self = setmetatable({}, CrouchController)
		return self:constructor(...) or self
	end
	function CrouchController:constructor(characterController)
		self.characterController = characterController
		self.canCrawl = false
	end
	function CrouchController:onInit()
		print("CrouchController initialized")
	end
	function CrouchController:onStart()
		print("CrouchController started")
		local character = self.characterController:getCurrentCharacter()
		local animation = ReplicatedStorage:FindFirstChild("Crawl")
		local hum = character:FindFirstChildOfClass("Humanoid")
		if hum then
			self.animPlay = hum:LoadAnimation(animation)
		end
		ContextActionService:BindAction("Crouch", function(_, state)
			return self:handleInput(state)
		end, false, Enum.KeyCode.C)
	end
	function CrouchController:handleInput(state)
		if state == Enum.UserInputState.Begin then
			self:startCrouch()
		elseif state == Enum.UserInputState.End then
			self:stopCrouch()
		end
	end
	function CrouchController:startCrouch()
		local character = self.characterController:getCurrentCharacter()
		local hum = character:FindFirstChildOfClass("Humanoid")
		if hum then
			self.canCrawl = true
			hum.HipHeight = 1
			hum.WalkSpeed = 7
			hum.JumpPower = 0
			local _result = self.animPlay
			if _result ~= nil then
				_result:Play()
			end
			print("Crouch")
			isCrouchingEvent:SendToServer(true)
		end
	end
	function CrouchController:stopCrouch()
		local character = self.characterController:getCurrentCharacter()
		local hum = character:FindFirstChildOfClass("Humanoid")
		if hum then
			self.canCrawl = false
			hum.HipHeight = 2
			hum.WalkSpeed = 14
			hum.JumpPower = 50
			local _result = self.animPlay
			if _result ~= nil then
				_result:Stop()
			end
			print("No Crouch")
			isCrouchingEvent:SendToServer(false)
		end
	end
end
-- (Flamework) CrouchController metadata
Reflect.defineMetadata(CrouchController, "identifier", "game/src/mechanics/PlayerMechanics/StealthMechanic/controller/crouch-controller@CrouchController")
Reflect.defineMetadata(CrouchController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(CrouchController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(CrouchController, "$:flamework@Controller", Controller, { {} })
return {
	default = CrouchController,
}
