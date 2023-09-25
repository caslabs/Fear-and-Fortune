-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local Workspace = _services.Workspace
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local PlayerStates = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "AISystem", "AIManager", "character-states").default
local EventManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "EventManager").EventManager
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local AIState
do
	local _inverse = {}
	AIState = setmetatable({}, {
		__index = _inverse,
	})
	AIState.Idle = 0
	_inverse[0] = "Idle"
	AIState.TriggerJumpscare = 1
	_inverse[1] = "TriggerJumpscare"
end
local AIJumpscareManager
do
	AIJumpscareManager = setmetatable({}, {
		__tostring = function()
			return "AIJumpscareManager"
		end,
	})
	AIJumpscareManager.__index = AIJumpscareManager
	function AIJumpscareManager.new(...)
		local self = setmetatable({}, AIJumpscareManager)
		return self:constructor(...) or self
	end
	function AIJumpscareManager:constructor(playerStateController)
		self.playerStateController = playerStateController
		self.eventManager = EventManager:getInstance()
	end
	function AIJumpscareManager:getInstance(playerStateController)
		if not self.instance then
			self.instance = AIJumpscareManager.new(playerStateController)
		end
		return self.instance
	end
	function AIJumpscareManager:isFirstPerson(playerCamera)
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
	function AIJumpscareManager:createJumpscareAgent(agent)
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
		local minDistanceToTrigger = 30
		local angleThreshold = math.cos(math.rad(30))
		local isJumped = false
		-- Connect to RunService.Heartbeat
		local heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
			local target = self:findNearestPlayer(agent)
			if target then
				local _position = target.Position
				local _position_1 = rootPart.Position
				local distance = (_position - _position_1).Magnitude
				if distance <= minDistanceToTrigger then
					local character = Players.LocalPlayer.Character
					if not character then
						return nil
					end
					local head = character:FindFirstChild("Head")
					if not head then
						return nil
					end
					local playerLookVector = head.CFrame.LookVector
					local _position_2 = rootPart.Position
					local _position_3 = target.Position
					local enemyToPlayer = (_position_2 - _position_3).Unit
					local dotProduct = enemyToPlayer:Dot(playerLookVector)
					if dotProduct > angleThreshold and not isJumped then
						currentState = AIState.TriggerJumpscare
						isJumped = true
					else
						currentState = AIState.Idle
					end
				else
					currentState = AIState.Idle
				end
			else
				currentState = AIState.Idle
			end
			-- Only update the player state if it has changed
			if currentState ~= previousState then
				if currentState == AIState.TriggerJumpscare then
					self.eventManager:dispatchEvent(GameEventType.JumpScare, {
						jumpscare = "",
					})
					self.eventManager:dispatchEvent(GameEventType.PostProcessing, {
						state = "jumpscarezoom",
					})
					-- Stare at Player
					local character = Players.LocalPlayer.Character
					if character then
						local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
						if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
							local lookAt = humanoidRootPart.Position
							local primaryPart = agent.PrimaryPart
							if primaryPart and primaryPart:IsA("BasePart") then
								print("[MODEL] BEFORE", primaryPart.CFrame)
								local _position = primaryPart.Position
								local distance = (lookAt - _position).Unit
								print("[MODEL] DISTANCE", distance)
								--[[
									Stares AWAY
									primaryPart.CFrame = new CFrame(
									primaryPart.Position,
									primaryPart.Position.sub(distance),
									);
									TODO: Make AI Templates, and MENTAL MOELS / COMMON HEURISITCS FOR ROBLOX
									PROGRAMMING
									I NEED TO FIGURE OUT THIS IALGORITHM FOR THIS IS THE ALGORITHM FOR POTENTIAL
									FUTURE AIS
								]]
								-- Stares DIRECTLY
								primaryPart.CFrame = CFrame.new(primaryPart.Position, lookAt)
								wait(1)
								print("[MODEL] AFTER", primaryPart.CFrame)
							end
						end
					end
					print("Player State: Jumpscared")
					wait()
					-- Make the enemy disappear
					agent.Parent = nil
					-- Set a delay before the enemy reappears
					local _exp = TS.Promise.delay(5)
					local _arg0_1 = function()
						self.playerStateController:setState(PlayerStates.Normal)
						self.eventManager:dispatchEvent(GameEventType.PostProcessing, {
							state = "default",
						})
						print("Player State: Normal")
					end
					_exp:andThen(_arg0_1)
					-- Set a delay before the enemy reappears
					local _exp_1 = TS.Promise.delay(20)
					local _arg0_2 = function()
						isJumped = false
						if humanoid.Health > 0 then
							agent.Parent = Workspace
						end
					end
					_exp_1:andThen(_arg0_2)
				elseif currentState == AIState.Idle then
					self.playerStateController:setState(PlayerStates.Normal)
					self.eventManager:dispatchEvent(GameEventType.PostProcessing, {
						state = "default",
					})
					print("Player State: Normal")
				end
				previousState = currentState
			end
		end)
	end
	function AIJumpscareManager:findNearestPlayer(agent, minDistanceToChase)
		if minDistanceToChase == nil then
			minDistanceToChase = 100
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
	AIJumpscareManager = AIJumpscareManager,
}
