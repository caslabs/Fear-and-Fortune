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
	AIState.IdentityFraud = 1
	_inverse[1] = "IdentityFraud"
	AIState.Chase = 2
	_inverse[2] = "Chase"
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
	function IdleState:constructor(aiIdentityManager)
		self.aiIdentityManager = aiIdentityManager
	end
	function IdleState:enter()
		print("Player State: Normal")
		self.aiIdentityManager.playerStateController:setState(PlayerStates.Normal)
	end
	function IdleState:execute(dt)
		local target = self.aiIdentityManager:findNearestPlayer()
		if target then
			self.aiIdentityManager:changeState(AIState.Chase)
		end
	end
	function IdleState:exit()
	end
end
local IdentityFraudState
do
	IdentityFraudState = setmetatable({}, {
		__tostring = function()
			return "IdentityFraudState"
		end,
	})
	IdentityFraudState.__index = IdentityFraudState
	function IdentityFraudState.new(...)
		local self = setmetatable({}, IdentityFraudState)
		return self:constructor(...) or self
	end
	function IdentityFraudState:constructor(aiIdentityManager)
		self.aiIdentityManager = aiIdentityManager
	end
	function IdentityFraudState:enter()
		print("Identiy Fraud Initialization")
		self.aiIdentityManager.playerStateController:setState(PlayerStates.Normal)
	end
	function IdentityFraudState:execute(dt)
		print("Executing Identity Fraud")
	end
	function IdentityFraudState:exit()
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
	function ChaseState:constructor(aiIdentityManager)
		self.aiIdentityManager = aiIdentityManager
	end
	function ChaseState:enter()
		print("Player State: Chasing")
		self.aiIdentityManager.playerStateController:setState(PlayerStates.Chasing)
	end
	function ChaseState:execute(dt)
		local target = self.aiIdentityManager:findNearestPlayer()
		if target then
			local _position = target.Position
			local _position_1 = self.aiIdentityManager.agentRootPart.Position
			local distance = (_position - _position_1).Magnitude
			self.aiIdentityManager.humanoid:MoveTo(target.Position)
		else
			self.aiIdentityManager:changeState(AIState.Idle)
		end
		self.aiIdentityManager.playerStateController:setState(PlayerStates.Normal)
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
	function StalkingState:constructor(aiIdentityManager)
		self.aiIdentityManager = aiIdentityManager
	end
	function StalkingState:enter()
		print("Player State: Stalking")
		self.aiIdentityManager.playerStateController:setState(PlayerStates.Normal)
		print("Player State:")
	end
	function StalkingState:execute(dt)
	end
	function StalkingState:exit()
	end
end
local AIIdentityManager
do
	AIIdentityManager = setmetatable({}, {
		__tostring = function()
			return "AIIdentityManager"
		end,
	})
	AIIdentityManager.__index = AIIdentityManager
	function AIIdentityManager.new(...)
		local self = setmetatable({}, AIIdentityManager)
		return self:constructor(...) or self
	end
	function AIIdentityManager:constructor(playerStateController)
		self.playerStateController = playerStateController
		self.eventManager = EventManager:getInstance()
		-- Initialize the properties with dummy instances
		self.agent = Instance.new("Model")
		self.agentRootPart = Instance.new("Part")
		self.humanoid = Instance.new("Humanoid")
		self.currentState = IdleState.new(self)
	end
	function AIIdentityManager:getInstance(playerStateController)
		if not self.instance then
			self.instance = AIIdentityManager.new(playerStateController)
		end
		return self.instance
	end
	AIIdentityManager.applyCharacterAppearanceToAgent = TS.async(function(self, player, agent)
		-- Get the player's character appearance
		local characterAppearance = TS.await(Players:GetCharacterAppearanceAsync(player.UserId))
		-- Clone the character appearance
		local clonedCharacter = characterAppearance:Clone()
		-- Remove unnecessary parts or scripts from the cloned character
		-- You can customize this part depending on what you want to keep or remove
		for _, child in ipairs(clonedCharacter:GetChildren()) do
			if child:IsA("Script") or child:IsA("LocalScript") then
				child:Destroy()
			end
		end
		-- Apply the cloned appearance to the AI agent
		-- You can customize this part to apply the appearance to the agent in a specific way
		clonedCharacter.Parent = agent
	end)
	AIIdentityManager.createChaser = TS.async(function(self, agent)
		local _arg0 = agent ~= nil and agent ~= nil
		assert(_arg0, "Invalid MODEL!")
		local targetPlayer = Players:GetPlayers()[1]
		TS.await(self:applyCharacterAppearanceToAgent(targetPlayer, self.agent))
		local rootPart = agent:FindFirstChild("HumanoidRootPart")
		local humanoid = agent:FindFirstChildOfClass("Humanoid")
		-- Check if the Model has a Humanoid
		if not humanoid then
			warn("Unable to find Model with Humanoid")
			return nil
		end
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
	end)
	function AIIdentityManager:changeState(newState)
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
	function AIIdentityManager:findNearestPlayer(minDistanceToChase)
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
	AIIdentityManager = AIIdentityManager,
}
