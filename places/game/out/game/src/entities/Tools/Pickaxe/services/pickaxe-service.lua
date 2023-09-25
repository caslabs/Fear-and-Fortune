-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local Workspace = _services.Workspace
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
-- Define ToolData for the Rifle
-- TODO: Prototype
local canteenData = {
	ammo = 3,
	maxAmmo = 3,
}
local PlayGunShakeEvent = Remotes.Server:Get("PlayGunShake")
local ToolPickupEvent = Remotes.Server:Get("ToolPickupEvent")
local ToolRemovedEvent = Remotes.Server:Get("ToolRemovedEvent")
local UpdateAmmoEvent = Remotes.Server:Get("UpdateAmmoEvent")
local AddThirstEvent = Remotes.Server:Get("AddThirst")
-- TODO: is this good? Play 3D Spatial Sound
-- Broken, only plays once and then never again...
local soundID = "7935556153"
local sound = "rbxassetid://" .. soundID
local soundInstance = Instance.new("Sound")
soundInstance.SoundId = sound
local animationInstance = Instance.new("Animation")
animationInstance.AnimationId = "rbxassetid://14315086620"
local treeHitSound = Instance.new("Sound")
treeHitSound.SoundId = "rbxassetid://159798370"
treeHitSound.Volume = 10
treeHitSound.RollOffMaxDistance = 10
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
local PickaxeService
do
	local super = BaseComponent
	PickaxeService = setmetatable({}, {
		__tostring = function()
			return "PickaxeService"
		end,
		__index = super,
	})
	PickaxeService.__index = PickaxeService
	function PickaxeService.new(...)
		local self = setmetatable({}, PickaxeService)
		return self:constructor(...) or self
	end
	function PickaxeService:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
		self.canteenData = {
			ammo = 3,
			maxAmmo = 3,
		}
		self.isReleased = false
		self.fireConnected = false
		self.lastSwing = 0
		self.swingCooldown = 1
	end
	function PickaxeService:onStart()
		print("Pickaxe Tool Component Initiated")
		local tool = self.instance
		local timeActivated
		tool:GetPropertyChangedSignal("Parent"):Connect(function()
			-- Loop through all the parts of the tool and set CanCollide to false
			for _, part in ipairs(tool:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
			-- If the tool is picked up by a player.
			local _result = tool.Parent
			if _result ~= nil then
				_result = _result:IsA("Model")
			end
			local _condition = _result
			if _condition then
				_condition = Players:GetPlayerFromCharacter(tool.Parent)
			end
			if _condition then
				local player = Players:GetPlayerFromCharacter(tool.Parent)
				if not player then
					error("Player not found!")
				end
				-- Check if the tool is already in the player's backpack.
				local playerBackpack = player:FindFirstChild("Backpack")
				if playerBackpack and not playerBackpack:FindFirstChild(tool.Name) then
					print("Tool is not in the player's backpack.")
					local _result_1 = playerBackpack
					if _result_1 ~= nil then
						_result_1 = _result_1:FindFirstChild(tool.Name)
					end
					print(_result_1)
					-- Only send the ToolPickupEvent if the tool is not already in the backpack.
					ToolPickupEvent:SendToPlayer(player, player, tool, self.canteenData)
					UpdateAmmoEvent:SendToPlayer(player, self.canteenData.ammo)
				else
					local _result_1 = playerBackpack
					if _result_1 ~= nil then
						_result_1 = _result_1:FindFirstChild(tool.Name)
					end
					print(_result_1)
					print("Tool is already in the player's backpack.")
				end
				-- Bind to mouse button 1 for PC users
				if not self.fireConnected then
					tool.Activated:Connect(function()
						local timeActivated = tick()
						self:swing(player)
					end)
					self.fireConnected = true
				end
			end
		end)
	end
	function PickaxeService:swing(player)
		local currentTime = tick()
		-- cooldown check
		if currentTime - self.lastSwing < self.swingCooldown then
			print("Cooldown")
			return nil
		end
		-- Update the last swing
		self.lastSwing = currentTime
		print("Swing Cooldown: ", self.lastSwing)
		local animatiorHandler
		-- Load Animation onto Player
		local _humanoid = player.Character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChildOfClass("Humanoid")
		end
		local humanoid = _humanoid
		if humanoid then
			local animator = humanoid:FindFirstChildOfClass("Animator")
			if animator then
				local animationTrack = animator:LoadAnimation(animationInstance)
				animationTrack.Priority = Enum.AnimationPriority.Action
				animationTrack:Play()
				animatiorHandler = animationTrack
				print("SWING BABY SWING")
			end
		end
		local tool = self.instance
		local hitbox = tool:FindFirstChild("Hitbox")
		if hitbox then
			self:checkCollision(hitbox)
		end
		print("Swing!")
	end
	function PickaxeService:checkCollision(hitbox)
		-- Get the size of the hitbox
		local size = hitbox.Size
		-- Get the CFrame of the hitbox
		local cframe = hitbox.CFrame
		-- Create the OverlapParams
		local overlapParams = OverlapParams.new()
		overlapParams.FilterType = Enum.RaycastFilterType.Blacklist
		overlapParams.FilterDescendantsInstances = { self.instance }
		overlapParams.MaxParts = math.huge
		-- Get all parts in the Overlap space
		local parts = Workspace:GetPartsInPart(hitbox, overlapParams)
		for _, part in ipairs(parts) do
			-- Make sure the part is not part of the tool
			if part.Parent ~= self.instance.Parent then
				-- The part belongs to another player, so it was touched by the hitbox
				print(part.Name .. " was touched by the hitbox")
				-- get position
				-- IronWoodTree
				if part.Name == "IronWoodTree" then
					local item = "IronWood"
					local ironWoodPart = part
					local dropRadius = 5
					local soundID = "159798328"
					local sound = "rbxassetid://" .. soundID
					local soundInstance = Instance.new("Sound")
					soundInstance.SoundId = sound
					soundInstance.Parent = self.instance
					soundInstance.Volume = 7
					soundInstance.MaxDistance = 10
					soundInstance:Play()
					-- eslint-disable-next-line roblox-ts/lua-truthiness
					local _value = part:GetAttribute("hitCount")
					if not (_value ~= 0 and (_value == _value and (_value ~= "" and _value))) then
						part:SetAttribute("hitCount", 1)
					else
						-- Increment the hit count
						local currentHitCount = part:GetAttribute("hitCount")
						local _fn = part
						currentHitCount += 1
						_fn:SetAttribute("hitCount", currentHitCount)
						treeHitSound:Play()
						print("Hit Count: ", part:GetAttribute("hitCount"))
						-- Check if hit count is enough to destroy the tree
						if (part:GetAttribute("hitCount")) >= 3 then
							-- Your drop items code...
							do
								local i = 0
								local _shouldIncrement = false
								while true do
									if _shouldIncrement then
										i += 1
									else
										_shouldIncrement = true
									end
									if not (i < 3) then
										break
									end
									-- calculate a random position around the player to drop the item
									local _position = ironWoodPart.Position
									local _vector3 = Vector3.new(math.random() * dropRadius - dropRadius / 2, 0, math.random() * dropRadius - dropRadius / 2)
									local dropPosition = _position + _vector3
									-- create the physical item
									local _binding = createPhysicalItem(item, dropPosition)
									local model = _binding.model
									local prompt = _binding.prompt
									-- connect the trigger to the prompt
									prompt.Triggered:Connect(function(otherPlayer)
										self.inventorySystem:addItemToInventory(otherPlayer, item)
										model:Destroy()
									end)
								end
							end
							-- Destroy the part
							part:Destroy()
						end
					end
				end
				-- Wood
				if part.Name == "WoodTree" then
					local item = "Wood"
					local woodPart = part
					local leafPart = part
					local leafItem = "Leaf"
					local dropRadius = 5
					-- eslint-disable-next-line roblox-ts/lua-truthiness
					local soundID = "159798328"
					local sound = "rbxassetid://" .. soundID
					local soundInstance = Instance.new("Sound")
					soundInstance.SoundId = sound
					soundInstance.Parent = self.instance
					soundInstance.Volume = 7
					soundInstance.MaxDistance = 10
					soundInstance:Play()
					-- eslint-disable-next-line roblox-ts/lua-truthiness
					local _value = part:GetAttribute("hitCount")
					if not (_value ~= 0 and (_value == _value and (_value ~= "" and _value))) then
						part:SetAttribute("hitCount", 1)
					else
						-- Increment the hit count
						local currentHitCount = part:GetAttribute("hitCount")
						local _fn = part
						currentHitCount += 1
						_fn:SetAttribute("hitCount", currentHitCount)
						treeHitSound:Play()
						-- Check if hit count is enough to destroy the tree
						if (part:GetAttribute("hitCount")) >= 3 then
							-- Your drop items code...
							do
								local i = 0
								local _shouldIncrement = false
								while true do
									if _shouldIncrement then
										i += 1
									else
										_shouldIncrement = true
									end
									if not (i < 3) then
										break
									end
									-- calculate a random position around the player to drop the item
									local _position = woodPart.Position
									local _vector3 = Vector3.new(math.random() * dropRadius - dropRadius / 2, 0, math.random() * dropRadius - dropRadius / 2)
									local dropPosition = _position + _vector3
									-- create the physical item
									local _binding = createPhysicalItem(item, dropPosition)
									local model = _binding.model
									local prompt = _binding.prompt
									-- connect the trigger to the prompt
									prompt.Triggered:Connect(function(otherPlayer)
										self.inventorySystem:addItemToInventory(otherPlayer, item)
										model:Destroy()
									end)
								end
							end
							-- Your drop items code...
							do
								local i = 0
								local _shouldIncrement = false
								while true do
									if _shouldIncrement then
										i += 1
									else
										_shouldIncrement = true
									end
									if not (i < 3) then
										break
									end
									-- calculate a random position around the player to drop the item
									local _position = leafPart.Position
									local _vector3 = Vector3.new(math.random() * dropRadius - dropRadius / 2, 0, math.random() * dropRadius - dropRadius / 2)
									local dropPosition = _position + _vector3
									-- create the physical item
									local _binding = createPhysicalItem(leafItem, dropPosition)
									local model = _binding.model
									local prompt = _binding.prompt
									-- connect the trigger to the prompt
									prompt.Triggered:Connect(function(otherPlayer)
										self.inventorySystem:addItemToInventory(otherPlayer, leafItem)
										model:Destroy()
									end)
								end
							end
							-- Destroy the part
							local _result = part.Parent
							if _result ~= nil then
								_result:Destroy()
							end
							part:Destroy()
						end
					end
				end
			end
		end
	end
end
-- (Flamework) PickaxeService metadata
Reflect.defineMetadata(PickaxeService, "identifier", "game/src/entities/Tools/Pickaxe/services/pickaxe-service@PickaxeService")
Reflect.defineMetadata(PickaxeService, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(PickaxeService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(PickaxeService, "$c:init@Component", Component, { {
	tag = "PickaxeToolTriggerService",
	instanceGuard = t.instanceIsA("Tool"),
	attributes = {},
} })
return {
	PickaxeService = PickaxeService,
}
