-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local EventManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "EventManager").EventManager
local AIState
do
	local _inverse = {}
	AIState = setmetatable({}, {
		__index = _inverse,
	})
	AIState.Idle = 0
	_inverse[0] = "Idle"
	AIState.Interacting = 1
	_inverse[1] = "Interacting"
end
local AINPCManager
do
	AINPCManager = setmetatable({}, {
		__tostring = function()
			return "AINPCManager"
		end,
	})
	AINPCManager.__index = AINPCManager
	function AINPCManager.new(...)
		local self = setmetatable({}, AINPCManager)
		return self:constructor(...) or self
	end
	function AINPCManager:constructor(playerStateController)
		self.playerStateController = playerStateController
		self.eventManager = EventManager:getInstance()
	end
	function AINPCManager:getInstance(playerStateController)
		if not self.instance then
			self.instance = AINPCManager.new(playerStateController)
		end
		return self.instance
	end
	function AINPCManager:createNPCAgent(agent, interactionData)
		-- ...validate agent and set up initial state...
		local _arg0 = agent ~= nil and agent ~= nil
		assert(_arg0, "Invalid MODEL!")
		local humanoid = agent:FindFirstChildOfClass("Humanoid")
		local rootPart = agent:FindFirstChild("HumanoidRootPart")
		-- Check if the root is a valid agent
		if not t.instanceIsA("BasePart")(rootPart) then
			return nil
		end
		-- Check if the humanoid is a valid agent
		if not t.instanceIsA("Humanoid")(humanoid) then
			return nil
		end
		local currentState = AIState.Idle
		local previousState
	end
end
return {
	AINPCManager = AINPCManager,
}
