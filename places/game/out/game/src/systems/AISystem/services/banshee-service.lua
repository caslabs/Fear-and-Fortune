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
local Workspace = _services.Workspace
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
local function createPhysicalItem(item, position)
	-- assuming the item has a Model property that refers to a Roblox model ID
	local model = Instance.new("Part")
	model.Parent = Workspace
	model.Position = position
	-- create and configure the ProximityPrompt for the item
	local prompt = Instance.new("ProximityPrompt")
	prompt.ObjectText = item
	prompt.ActionText = "Pick up"
	prompt.Parent = model
	-- return the model and prompt for further use
	return {
		model = model,
		prompt = prompt,
	}
end
-- Events
local DamagePlayerEvent = Remotes.Server:Get("DamagePlayer")
local BansheeComponent
do
	local super = BaseComponent
	BansheeComponent = setmetatable({}, {
		__tostring = function()
			return "BansheeComponent"
		end,
		__index = super,
	})
	BansheeComponent.__index = BansheeComponent
	function BansheeComponent.new(...)
		local self = setmetatable({}, BansheeComponent)
		return self:constructor(...) or self
	end
	function BansheeComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
		self.isFollowing = false
		self.lastFollowedPlayer = nil
		self.isDead = false
	end
	function BansheeComponent:onStart()
		print("Banshee Component Started")
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
			humanoid.Died:Connect(function()
				return self:onDeath()
			end)
			print("Touched Event Connected")
		end
	end
	function BansheeComponent:onTouch(otherPart)
		local character = otherPart.Parent
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChild("Humanoid")
		end
		local humanoid = _humanoid
		if humanoid and humanoid:IsA("Humanoid") then
			-- It's a player! Subtract health.
			print("Touched Player!")
			humanoid.Health -= 5
			-- Find the Player instance associated with the character model
			local player = Players:GetPlayerFromCharacter(character)
			-- Guard - if player is alive, prevent error of fidning attribute of a non-existent player
			-- If the player was found, set the attribute
			if player then
				-- Make sure the player instance is still valid
				if player:IsA("Player") then
					player:SetAttribute("LastDamageByBanshee", true)
				end
			end
		end
	end
	function BansheeComponent:findNearestPlayer()
		local npcPosition = (self.instance).PrimaryPart.Position
		local closestPlayer = nil
		local closestDistance = DETECTION_RADIUS
		for _, player in ipairs(Players:GetPlayers()) do
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
	function BansheeComponent:updatePath()
		if self.isDead then
			return nil
		end
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
	function BansheeComponent:onDeath()
		print("Banshee Died")
		self.isDead = true
		if self.lastFollowedPlayer then
			self.isFollowing = false
			print("Not Following")
			StopLocalSoundEvent:SendToPlayer(self.lastFollowedPlayer, SoundKeys.SFX_CHASING_1)
			StopJumpScareZoomEvent:SendToPlayer(self.lastFollowedPlayer)
			StopChasingShakeEvent:SendToPlayer(self.lastFollowedPlayer)
			self.lastFollowedPlayer = nil
		end
		-- Let's drop a loot
		local dropPosition = (self.instance).PrimaryPart.Position
		local _binding = createPhysicalItem("BansheeResidue", dropPosition)
		local model = _binding.model
		local prompt = _binding.prompt
		prompt.Triggered:Connect(function(otherPlayer)
			self.inventorySystem:addItemToInventory(otherPlayer, "BansheeResidue", 1)
			model:Destroy()
		end)
	end
end
-- (Flamework) BansheeComponent metadata
Reflect.defineMetadata(BansheeComponent, "identifier", "game/src/systems/AISystem/services/banshee-service@BansheeComponent")
Reflect.defineMetadata(BansheeComponent, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(BansheeComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(BansheeComponent, "$c:init@Component", Component, { {
	tag = "Banshee",
	attributes = {},
} })
return {
	BansheeComponent = BansheeComponent,
}
