-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
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
	AIState.Mockery = 1
	_inverse[1] = "Mockery"
	AIState.Violant = 2
	_inverse[2] = "Violant"
	AIState.Choas = 3
	_inverse[3] = "Choas"
end
local AICorruptionManager
do
	AICorruptionManager = setmetatable({}, {
		__tostring = function()
			return "AICorruptionManager"
		end,
	})
	AICorruptionManager.__index = AICorruptionManager
	function AICorruptionManager.new(...)
		local self = setmetatable({}, AICorruptionManager)
		return self:constructor(...) or self
	end
	function AICorruptionManager:constructor(playerStateController)
		self.playerStateController = playerStateController
		self.eventManager = EventManager:getInstance()
	end
	function AICorruptionManager:getInstance(playerStateController)
		if not self.instance then
			self.instance = AICorruptionManager.new(playerStateController)
		end
		return self.instance
	end
	function AICorruptionManager:isFirstPerson(playerCamera)
		local character = Players.LocalPlayer.Character
		if character then
			local head = character:FindFirstChild("Head")
			if head then
				local _position = playerCamera.CFrame.Position
				local _position_1 = head.Position
				local distance = (_position - _position_1).Magnitude
				return distance <= 1
			end
		end
		return false
	end
	function AICorruptionManager:createCorruptionAgent(agent)
		print("Creating Corruption Agent")
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
		-- Connect to RunService.Heartbeat
		local heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
			local target = self:findNearestPlayer(agent)
			-- TODO: Listens to current story progression and character states
		end)
	end
	function AICorruptionManager:findNearestPlayer(agent, minDistanceToChase)
		if minDistanceToChase == nil then
			minDistanceToChase = 10
		end
		local players = Players:GetPlayers()
		local nearestPlayer
		local minDistance = math.huge
		for _, player in ipairs(players) do
			local character = player.Character
			if character then
				local rootPart = character:FindFirstChild("HumanoidRootPart")
				if rootPart then
					local agentPart = agent:FindFirstChild("HumanoidRootPart")
					if agentPart then
						local _position = rootPart.Position
						local _position_1 = agentPart.Position
						local distance = (_position - _position_1).Magnitude
						if distance < minDistance then
							nearestPlayer = player
							minDistance = distance
						end
					end
				end
			end
		end
		if nearestPlayer then
			local _result = nearestPlayer.Character
			if _result ~= nil then
				_result = _result:FindFirstChild("HumanoidRootPart")
			end
			local nearestPlayerRootPart = _result
			local agentPart = agent:FindFirstChild("HumanoidRootPart")
			if nearestPlayerRootPart and agentPart then
				local _position = nearestPlayerRootPart.Position
				local _position_1 = agentPart.Position
				local distance = (_position - _position_1).Magnitude
				if distance < minDistanceToChase then
					return nearestPlayerRootPart
				end
			end
		end
		return nil
	end
end
return {
	AICorruptionManager = AICorruptionManager,
}
