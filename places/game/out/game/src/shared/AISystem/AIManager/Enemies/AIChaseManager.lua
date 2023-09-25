-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local PlayerStates = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "AISystem", "AIManager", "character-states").default
local EventManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "EventManager").EventManager
local AIState
do
	local _inverse = {}
	AIState = setmetatable({}, {
		__index = _inverse,
	})
	AIState.Idle = 0
	_inverse[0] = "Idle"
	AIState.Chase = 1
	_inverse[1] = "Chase"
end
local IdleState
do
	IdleState = setmetatable({}, {
		__tostring = function()
			return "IdleState"
		end,
	})
	IdleState.__index = IdleState
	function IdleState.new(...)
		local self = setmetatable({}, IdleState)
		return self:constructor(...) or self
	end
	function IdleState:constructor(aiChaserManager)
		self.aiChaserManager = aiChaserManager
	end
	function IdleState:enter()
		print("Player State: Normal")
		self.aiChaserManager.playerStateController:setState(PlayerStates.Normal)
	end
	function IdleState:execute(dt)
		local target = self.aiChaserManager:findNearestPlayer()
		if target then
			self.aiChaserManager:changeState(AIState.Chase)
		end
	end
	function IdleState:exit()
	end
end
local ChaseState
do
	ChaseState = setmetatable({}, {
		__tostring = function()
			return "ChaseState"
		end,
	})
	ChaseState.__index = ChaseState
	function ChaseState.new(...)
		local self = setmetatable({}, ChaseState)
		return self:constructor(...) or self
	end
	function ChaseState:constructor(aiChaserManager)
		self.aiChaserManager = aiChaserManager
	end
	function ChaseState:enter()
		print("Player State: Chasing")
		self.aiChaserManager.playerStateController:setState(PlayerStates.Chasing)
	end
	function ChaseState:execute(dt)
		local target = self.aiChaserManager:findNearestPlayer()
		if target then
			local _position = target.Position
			local _position_1 = self.aiChaserManager.agentRootPart.Position
			local distance = (_position - _position_1).Magnitude
			self.aiChaserManager.humanoid:MoveTo(target.Position)
		else
			self.aiChaserManager:changeState(AIState.Idle)
		end
		self.aiChaserManager.playerStateController:setState(PlayerStates.Normal)
	end
	function ChaseState:exit()
	end
end
local StalkingState
do
	StalkingState = setmetatable({}, {
		__tostring = function()
			return "StalkingState"
		end,
	})
	StalkingState.__index = StalkingState
	function StalkingState.new(...)
		local self = setmetatable({}, StalkingState)
		return self:constructor(...) or self
	end
	function StalkingState:constructor(aiChaserManager)
		self.aiChaserManager = aiChaserManager
	end
	function StalkingState:enter()
		print("Player State: Stalking")
		self.aiChaserManager.playerStateController:setState(PlayerStates.Normal)
		print("Player State:")
	end
	function StalkingState:execute(dt)
	end
	function StalkingState:exit()
	end
end
local AIChaserManager
do
	AIChaserManager = setmetatable({}, {
		__tostring = function()
			return "AIChaserManager"
		end,
	})
	AIChaserManager.__index = AIChaserManager
	function AIChaserManager.new(...)
		local self = setmetatable({}, AIChaserManager)
		return self:constructor(...) or self
	end
	function AIChaserManager:constructor(playerStateController)
		self.playerStateController = playerStateController
		self.eventManager = EventManager:getInstance()
		-- Initialize the properties with dummy instances
		self.agent = Instance.new("Model")
		self.agentRootPart = Instance.new("Part")
		self.humanoid = Instance.new("Humanoid")
		self.currentState = IdleState.new(self)
	end
	function AIChaserManager:getInstance(playerStateController)
		if not self.instance then
			self.instance = AIChaserManager.new(playerStateController)
		end
		return self.instance
	end
	function AIChaserManager:createChaser(agent)
		local _arg0 = agent ~= nil and agent ~= nil
		assert(_arg0, "Invalid MODEL!")
		self.agent = agent
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
		self.agentRootPart = rootPart
		self.humanoid = humanoid
		self:changeState(AIState.Idle)
		-- Connect to RunService.Heartbeat
		local heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
			self.currentState:execute(dt)
		end)
	end
	function AIChaserManager:changeState(newState)
		if self.currentState then
			self.currentState:exit()
		end
		repeat
			if newState == (AIState.Idle) then
				self.currentState = IdleState.new(self)
				break
			end
			if newState == (AIState.Chase) then
				self.currentState = ChaseState.new(self)
				break
			end
			warn("Invalid state")
		until true
		self.currentState:enter()
	end
	function AIChaserManager:findNearestPlayer(minDistanceToChase)
		if minDistanceToChase == nil then
			minDistanceToChase = 10
		end
		local nearestPlayer
		local nearestDistance = minDistanceToChase
		for _, player in ipairs(Players:GetPlayers()) do
			local character = player.Character
			if not character then
				continue
			end
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			if not rootPart or not t.instanceIsA("BasePart")(rootPart) then
				continue
			end
			local _position = rootPart.Position
			local _position_1 = self.agentRootPart.Position
			local distance = (_position - _position_1).Magnitude
			if distance < nearestDistance then
				nearestDistance = distance
				nearestPlayer = player
			end
		end
		local _result = nearestPlayer
		if _result ~= nil then
			_result = _result.Character
			if _result ~= nil then
				_result = _result:FindFirstChild("HumanoidRootPart")
			end
		end
		return _result
	end
end
return {
	AIChaserManager = AIChaserManager,
}
