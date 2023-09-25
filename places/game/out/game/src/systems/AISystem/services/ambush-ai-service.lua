-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local RunService = _services.RunService
local PathfindingService = _services.PathfindingService
local Workspace = _services.Workspace
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local _SpawnBehindPlayerEvent = Remotes.Server:Get("_SpawnBehindPlayer")
local AmbushAIComponent
do
	local super = BaseComponent
	AmbushAIComponent = setmetatable({}, {
		__tostring = function()
			return "AmbushAIComponent"
		end,
		__index = super,
	})
	AmbushAIComponent.__index = AmbushAIComponent
	function AmbushAIComponent.new(...)
		local self = setmetatable({}, AmbushAIComponent)
		return self:constructor(...) or self
	end
	function AmbushAIComponent:constructor(...)
		super.constructor(self, ...)
		self.isRunningAway = false
		self.targetPlayer = nil
		self.runningAwayTimer = 0
		self.previousState = nil
	end
	function AmbushAIComponent:onStart()
		print("Ambush AI Component Started")
		-- Test to Spawn Behind Player
		_SpawnBehindPlayerEvent:Connect(function(player)
			self:spawnBehindPlayer(player)
			print("[AMBUSH] Spawned success!")
		end)
		-- Start updating path
		RunService.Heartbeat:Connect(function(dt)
			self:updatePath(dt)
		end)
	end
	function AmbushAIComponent:spawnBehindPlayer(player)
		local character = player.Character
		local _humanoidRootPart = character
		if _humanoidRootPart ~= nil then
			_humanoidRootPart = _humanoidRootPart:FindFirstChild("HumanoidRootPart")
		end
		local humanoidRootPart = _humanoidRootPart
		if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
			local spawnDirection = humanoidRootPart.CFrame.LookVector * (-1)
			local spawnDistance = 10
			local ray = Ray.new(humanoidRootPart.Position, spawnDirection * spawnDistance)
			local hitPart, hitPosition = Workspace:FindPartOnRayWithIgnoreList(ray, { self.instance })
			if self.instance:IsA("Model") and (self.instance.PrimaryPart and hitPosition) then
				self.instance:SetPrimaryPartCFrame(CFrame.new(hitPosition))
			end
		end
		self.targetPlayer = player
		self.isRunningAway = false
		self.runningAwayTimer = 0
	end
	function AmbushAIComponent:updatePath(dt)
		local npcHumanoid = (self.instance):FindFirstChildOfClass("Humanoid")
		local player = self.targetPlayer
		if npcHumanoid and player then
			local character = player.Character
			if character then
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
					local path = PathfindingService:CreatePath()
					if self.isRunningAway then
						-- Run away from the player
						local runAwayDirection = humanoidRootPart.CFrame.LookVector * (-1)
						local runAwayDistance = 50
						local _fn = path
						local _exp = (self.instance).PrimaryPart.Position
						local _position = humanoidRootPart.Position
						local _arg0 = runAwayDirection * runAwayDistance
						_fn:ComputeAsync(_exp, _position + _arg0)
					else
						-- Chase the player
						path:ComputeAsync((self.instance).PrimaryPart.Position, humanoidRootPart.Position)
					end
					if path.Status == Enum.PathStatus.Success then
						local waypoints = path:GetWaypoints()
						npcHumanoid:MoveTo(waypoints[2].Position)
					end
					-- Check if the player is looking at the AI
					local _cameraCFrame = Workspace.CurrentCamera
					if _cameraCFrame ~= nil then
						_cameraCFrame = _cameraCFrame.CFrame
					end
					local cameraCFrame = _cameraCFrame
					if cameraCFrame then
						local playerLookVector = cameraCFrame.LookVector
						local _position = humanoidRootPart.Position
						local _position_1 = (self.instance).PrimaryPart.Position
						local aiToPlayer = _position - _position_1
						if aiToPlayer.Unit:Dot(playerLookVector.Unit) > 0 then
							-- Player is looking at the AI
							if not self.isRunningAway then
								self.isRunningAway = true
								self.runningAwayTimer = 0
								if self.previousState ~= "runningAway" then
									print("[AMBUSH] Is Running Away")
									self.previousState = "runningAway"
								end
							else
								self.runningAwayTimer += dt
								if self.runningAwayTimer >= 3 then
									self.instance:Destroy()
								end
							end
							-- Run away from the player directly
							local runAwayDirection = humanoidRootPart.CFrame.LookVector * (-1)
							local runAwayDistance = 5
							local _position_2 = (self.instance).PrimaryPart.Position
							local _arg0 = runAwayDirection * runAwayDistance
							local runAwayPosition = _position_2 + _arg0
							npcHumanoid:MoveTo(runAwayPosition)
						else
							-- Player is not looking at the AI
							if self.isRunningAway then
								if self.previousState ~= "chasing" then
									print("[AMBUSH] Is Chasing")
									self.previousState = "chasing"
								end
							end
							self.isRunningAway = false
							-- Chase the player directly
							npcHumanoid:MoveTo(humanoidRootPart.Position)
						end
					end
				end
			end
		end
	end
end
-- (Flamework) AmbushAIComponent metadata
Reflect.defineMetadata(AmbushAIComponent, "identifier", "game/src/systems/AISystem/services/ambush-ai-service@AmbushAIComponent")
Reflect.defineMetadata(AmbushAIComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(AmbushAIComponent, "$c:init@Component", Component, { {
	tag = "AMBUSH_AI",
	attributes = {},
} })
return {
	AmbushAIComponent = AmbushAIComponent,
}
