-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local AnimationData = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "AnimationSytem", "AnimationData").AnimationData
local UserInputService = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local AnimationSystemController
do
	AnimationSystemController = setmetatable({}, {
		__tostring = function()
			return "AnimationSystemController"
		end,
	})
	AnimationSystemController.__index = AnimationSystemController
	function AnimationSystemController.new(...)
		local self = setmetatable({}, AnimationSystemController)
		return self:constructor(...) or self
	end
	function AnimationSystemController:constructor(characterController)
		self.characterController = characterController
	end
	function AnimationSystemController:onInit()
		for animationKey, animationId in pairs(AnimationData) do
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://" .. animationId
			AnimationSystemController.animationInstances[animationKey] = animation
		end
		print("AnimationSystemController initialized")
	end
	function AnimationSystemController:onStart()
		local character = self.characterController:getCurrentCharacter()
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid.Humanoid
		end
		local humanoid = _humanoid
		if not humanoid then
			return nil
		end
		self.animator = humanoid:FindFirstChildOfClass("Animator")
		if not self.animator then
			print("No Animator found for character")
			return nil
		end
		print("Animator set up")
		UserInputService.InputBegan:Connect(function(input)
			return self:_handleInput(input)
		end)
		print("AnimationSystemController started")
	end
	function AnimationSystemController:_handleInput(input)
	end
	function AnimationSystemController:playAnimation(id)
		print("[INFO] playAnimation", id)
		local animation = AnimationSystemController.animationInstances[id]
		if animation and self.animator then
			local animationTrack = self.animator:LoadAnimation(animation)
			animationTrack:Play()
			print("Animation should be playing")
		end
	end
	function AnimationSystemController:stopAnimation(id)
		print("[INFO] stopAnimation", id)
		local animation = AnimationSystemController.animationInstances[id]
		if animation and self.animator then
			local animationTrack = self.animator:LoadAnimation(animation)
			animationTrack:Stop()
		end
	end
	AnimationSystemController.animationInstances = {}
end
-- (Flamework) AnimationSystemController metadata
Reflect.defineMetadata(AnimationSystemController, "identifier", "game/src/systems/AnimationSystem/controller/animation-controller@AnimationSystemController")
Reflect.defineMetadata(AnimationSystemController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(AnimationSystemController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(AnimationSystemController, "$:flamework@Controller", Controller, { {} })
return {
	default = AnimationSystemController,
}
