-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local AIJumpscareManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "AISystem", "AIManager", "Enemies", "AIJumpscareManager").AIJumpscareManager
--[[
	TODO: Implement AI general behaviours
]]
local EnemyComponent
do
	local super = BaseComponent
	EnemyComponent = setmetatable({}, {
		__tostring = function()
			return "EnemyComponent"
		end,
		__index = super,
	})
	EnemyComponent.__index = EnemyComponent
	function EnemyComponent.new(...)
		local self = setmetatable({}, EnemyComponent)
		return self:constructor(...) or self
	end
	function EnemyComponent:constructor(playerStateController)
		super.constructor(self)
		self.playerStateController = playerStateController
	end
	function EnemyComponent:onStart()
		print("ENEMY Component Initiated")
		print("ENEMY Component Initiated on " .. (self.instance.Name .. (" (" .. (self.instance.ClassName .. ")"))))
		local agentModel = self.instance
		if agentModel and agentModel:FindFirstChildOfClass("Humanoid") then
			print("AIJumpscare Test")
			local aiJumpscareManager = AIJumpscareManager:getInstance(self.playerStateController)
			aiJumpscareManager:createJumpscareAgent(agentModel)
			print("Executed Jumpscare Agent Brain!")
		else
			print("Unable to find Model with Humanoid")
		end
	end
end
-- (Flamework) EnemyComponent metadata
Reflect.defineMetadata(EnemyComponent, "identifier", "game/src/systems/AISystem/components/ai-jumpscare@EnemyComponent")
Reflect.defineMetadata(EnemyComponent, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/character-states-controller@PlayerStateController" })
Reflect.defineMetadata(EnemyComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(EnemyComponent, "$c:init@Component", Component, { {
	tag = "JUMPSCARE_AI",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	EnemyComponent = EnemyComponent,
}
