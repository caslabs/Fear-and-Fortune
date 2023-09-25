-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local PathfindingService = _services.PathfindingService
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
-- TODO: Find Units - i think its STUDS
local DETECTION_RADIUS = 50
local PlayLocalSoundEvent = Remotes.Server:Get("PlayLocalSound")
local StopLocalSoundEvent = Remotes.Server:Get("StopLocalSound")
local PlayJumpScareZoomEvent = Remotes.Server:Get("PlayJumpScareZoom")
local StopJumpScareZoomEvent = Remotes.Server:Get("StopJumpScareZoom")
local StartChasingShakeEvent = Remotes.Server:Get("StartChasingShake")
local StopChasingShakeEvent = Remotes.Server:Get("StopChasingShake")
-- Events
local DamagePlayerEvent = Remotes.Server:Get("DamagePlayer")
local FollowAIComponent
do
	local super = BaseComponent
	FollowAIComponent = setmetatable({}, {
		__tostring = function()
			return "FollowAIComponent"
		end,
		__index = super,
	})
	FollowAIComponent.__index = FollowAIComponent
	function FollowAIComponent.new(...)
		local self = setmetatable({}, FollowAIComponent)
		return self:constructor(...) or self
	end
	function FollowAIComponent:constructor(...)
		super.constructor(self, ...)
		self.isFollowing = false
		self.lastFollowedPlayer = nil
		self.killedPlayers = {}
	end
	function FollowAIComponent:onStart()
		print("Crouch AI Component Started")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to Banshee because it has no PrimaryPart")
			return nil
		end
		-- Start updating path
		RunService.Heartbeat:Connect(function()
			self:updatePath()
		end)
		local humanoid = self.instance:FindFirstChild("Humanoid")
		if humanoid and humanoid:IsA("Humanoid") then
			humanoid.Touched:Connect(function(otherPart)
				return self:onTouch(otherPart)
			end)
			print("Touched Event Connected")
		end
	end
	function FollowAIComponent:onTouch(otherPart)
		-- Find the Player instance associated with the character model
		local character = otherPart.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if not player or self.killedPlayers[player] ~= nil then
			-- Ignore if player has already been killed
			return nil
		end
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChild("Humanoid")
		end
		local humanoid = _humanoid
		if humanoid and humanoid:IsA("Humanoid") then
			-- It's a player! Subtract health.
			print("Killed Player!")
			local _result = player
			if _result ~= nil then
				_result:SetAttribute("LastDamageBy_Crouch", true)
			end
			humanoid:TakeDamage(humanoid.MaxHealth)
			if humanoid then
				humanoid:TakeDamage(humanoid.MaxHealth)
				self.killedPlayers[player] = true
			end
		end
	end
	function FollowAIComponent:findNearestPlayer()
		local npcPosition = (self.instance).PrimaryPart.Position
		local closestPlayer = nil
		local closestDistance = DETECTION_RADIUS
		for _, player in ipairs(Players:GetPlayers()) do
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			local _value = player:GetAttribute("isCrouching")
			if _value ~= 0 and (_value == _value and (_value ~= "" and _value)) then
				-- Skip if player is crouching
				continue
			end
			local character = player.Character
			if character then
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
					local playerPosition = humanoidRootPart.Position
					local distance = (npcPosition - playerPosition).Magnitude
					if distance < closestDistance then
						closestDistance = distance
						closestPlayer = player
					end
				end
			end
		end
		-- Finite State Player
		if closestPlayer then
			if closestPlayer ~= self.lastFollowedPlayer then
				self.lastFollowedPlayer = closestPlayer
				if not self.isFollowing then
					self.isFollowing = true
					print("Following")
					PlayLocalSoundEvent:SendToPlayer(closestPlayer, SoundKeys.SFX_CHASING_1, 4)
					PlayJumpScareZoomEvent:SendToPlayer(closestPlayer)
					StartChasingShakeEvent:SendToPlayer(closestPlayer)
				end
			end
		else
			if self.isFollowing and self.lastFollowedPlayer then
				self.isFollowing = false
				print("Not Following")
				StopLocalSoundEvent:SendToPlayer(self.lastFollowedPlayer, SoundKeys.SFX_CHASING_1)
				StopJumpScareZoomEvent:SendToPlayer(self.lastFollowedPlayer)
				StopChasingShakeEvent:SendToPlayer(self.lastFollowedPlayer)
				self.lastFollowedPlayer = nil
			end
		end
		return closestPlayer
	end
	function FollowAIComponent:updatePath()
		local npcHumanoid = (self.instance):FindFirstChildOfClass("Humanoid")
		local targetPlayer = self:findNearestPlayer()
		if npcHumanoid and targetPlayer then
			local character = targetPlayer.Character
			if character then
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
					local path = PathfindingService:CreatePath()
					path:ComputeAsync((self.instance).PrimaryPart.Position, humanoidRootPart.Position)
					if path.Status == Enum.PathStatus.Success then
						local waypoints = path:GetWaypoints()
						npcHumanoid:MoveTo(waypoints[2].Position)
					end
				end
			end
		end
	end
end
-- (Flamework) FollowAIComponent metadata
Reflect.defineMetadata(FollowAIComponent, "identifier", "game/src/systems/AISystem/services/crouch-ai-service@FollowAIComponent")
Reflect.defineMetadata(FollowAIComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(FollowAIComponent, "$c:init@Component", Component, { {
	tag = "CROUCH_AI",
	attributes = {},
} })
return {
	FollowAIComponent = FollowAIComponent,
}
