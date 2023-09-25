-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local Workspace = _services.Workspace
local RunService = _services.RunService
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Maid = TS.import(script, TS.getModule(script, "@rbxts", "maid").Maid)
local baseplate = Workspace:WaitForChild("TutorialNode"):WaitForChild("Baseplate")
local deathRules = { {
	condition = function(lastPosition)
		return lastPosition.Y < baseplate.Position.Y
	end,
	message = "You fell to your death",
	hint = "Try not to fall next time...",
}, {
	condition = function(lastPosition, player)
		return player:GetAttribute("JustReset")
	end,
	message = "Another soul claimed...",
	hint = "You took the easy way out",
}, {
	condition = function(lastPosition, player)
		return player:GetAttribute("LastDamagedByAI")
	end,
	message = "You died to the Eyeless",
	hint = "Try not to look at it again... ",
}, {
	condition = function(lastPosition, player)
		return player:GetAttribute("LastDamageByBanshee")
	end,
	message = "You died to the Banshee",
	hint = "Save up your energy before confrontation... ",
}, {
	condition = function(lastPosition, player)
		return player:GetAttribute("LastDamageBy_Crouch")
	end,
	message = "You died to the _Crouch",
	hint = "Avoid noises by crouching...",
}, {
	condition = function(lastPosition, player)
		return player:GetAttribute("LastDamageBySurvival")
	end,
	message = "You died by your own hands",
	hint = "Try maintain your hunger and thirst...",
} }
local function CloneMe(char)
	-- a function that clones a player
	char.Archivable = true
	local clone = char:Clone()
	char.Archivable = false
	-- Remove the Humanoid, which removes the health bar
	local humanoid = clone:FindFirstChild("Humanoid")
	humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.BreakJointsOnDeath = false
	-- Remove the BillboardGui, which removes the player name above the character
	local head = clone:FindFirstChild("Head")
	if head then
		local billboardGui = head:FindFirstChild("BillboardGui")
		if billboardGui then
			billboardGui:Destroy()
		end
	end
	return clone
end
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
local PlayerDeathEvent = Remotes.Server:Get("PlayerDeathEvent")
local PlayerDeathSurvivalEvent = Remotes.Server:Get("PlayerDeathSurvival")
local DeathMechanic
do
	DeathMechanic = setmetatable({}, {
		__tostring = function()
			return "DeathMechanic"
		end,
	})
	DeathMechanic.__index = DeathMechanic
	function DeathMechanic.new(...)
		local self = setmetatable({}, DeathMechanic)
		return self:constructor(...) or self
	end
	function DeathMechanic:constructor(inventorySystem)
		self.inventorySystem = inventorySystem
		self.maid = Maid.new()
	end
	function DeathMechanic:attachProximityPrompt(instance, ignorePlayer)
		-- checking for undefined
		if instance then
			local prompt = Make("ProximityPrompt", {
				ObjectText = "HumanMeat",
				ActionText = "Harvest",
				Parent = if instance:IsA("Model") then instance else instance,
				HoldDuration = 1,
			})
			-- Disable prompt for ignorePlayer
			Players.PlayerAdded:Connect(function(player)
				if player == ignorePlayer then
					prompt.Enabled = false
				end
			end)
			return prompt
		end
	end
	function DeathMechanic:grab(instance, player)
		-- TODO: Make a better Inventory System
		-- This would add "WeirwoodSilver" to ALL players' inventories. Good mechanic?
		self.inventorySystem:addItemToInventory(player, "HumanMeat")
		print("[INFO] Grabbing Human Meat")
		if instance then
			-- checking for undefined
			instance:Destroy()
		end
	end
	function DeathMechanic:onStart()
		print("DeathMechanic Service started")
		Players.PlayerAdded:Connect(function(player)
			player:SetAttribute("JustReset", false)
			player:SetAttribute("LastDamageBySurvival", false)
			PlayerDeathSurvivalEvent:Connect(function()
				player:SetAttribute("LastDamageBySurvival", true)
				print("PlayerDeathSurvivalEvent triggered")
			end)
			player.CharacterAdded:Connect(function(character)
				local humanoid = character:WaitForChild("Humanoid")
				humanoid.BreakJointsOnDeath = false
				local instance = character:FindFirstChild("HumanoidRootPart")
				-- Record the last known health of the character.
				local lastHealth = humanoid.Health
				-- Record the last known position of the character every second.
				local lastPosition
				local recording = RunService.Heartbeat:Connect(function()
					if character.PrimaryPart then
						lastPosition = character.PrimaryPart.Position
						lastHealth = humanoid.Health
					end
				end)
				humanoid.Died:Connect(function()
					recording:Disconnect()
					-- Create a clone of the player's character
					-- Create a clone of the player's character
					-- If the player's health dropped rapidly (e.g., within a single frame), they probably reset their character.
					if lastHealth == humanoid.MaxHealth then
					end
					local inventory = self.inventorySystem:getInventory(player)
					-- eslint-disable-next-line roblox-ts/lua-truthiness
					if inventory then
						local dropRadius = 5
						local _arg0 = function(quantity, item)
							do
								local i = 0
								local _shouldIncrement = false
								while true do
									if _shouldIncrement then
										i += 1
									else
										_shouldIncrement = true
									end
									if not (i < quantity) then
										break
									end
									-- calculate a random position around the player to drop the item
									local _lastPosition = lastPosition
									local _vector3 = Vector3.new(math.random() * dropRadius - dropRadius / 2, 0, math.random() * dropRadius - dropRadius / 2)
									local dropPosition = _lastPosition + _vector3
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
						end
						for _k, _v in pairs(inventory) do
							_arg0(_v, _k, inventory)
						end
						-- clear the player's local inventory
						table.clear(inventory)
					end
					for _, rule in ipairs(deathRules) do
						if rule.condition(lastPosition, player) then
							print(player.Name .. (" " .. (rule.message .. ".")))
							print("hint: " .. rule.hint)
							-- Ping to Client to show the death screen
							PlayerDeathEvent:SendToPlayer(player, player, rule.message, rule.hint)
							-- Ping to Client to show the death screen
							PlayerDeathEvent:SendToPlayer(player, player, rule.message, rule.hint)
							print("Cloning character for " .. player.Name)
							-- const characterClone = character.Clone() as Model;
							local characterClone = CloneMe(character)
							-- Nudge the player's dead body
							if not characterClone then
								warn("Failed to clone character for " .. player.Name)
								return nil
							end
							characterClone:SetPrimaryPartCFrame(CFrame.new(lastPosition))
							characterClone.Parent = Workspace
							local descendants = characterClone:GetDescendants()
							do
								local i = 0
								local _shouldIncrement = false
								while true do
									if _shouldIncrement then
										i += 1
									else
										_shouldIncrement = true
									end
									if not (i < #descendants) then
										break
									end
									local desc = descendants[i + 1]
									if desc:IsA("Motor6D") and desc.Parent then
										local part0 = desc.Part0
										local jointName = desc.Name
										if part0 then
											local socket = Instance.new("BallSocketConstraint")
											local attachment0Instance = desc.Parent:FindFirstChild(jointName .. "Attachment") or desc.Parent:FindFirstChild(jointName .. "RigAttachment")
											local attachment1Instance = part0:FindFirstChild(jointName .. "Attachment") or part0:FindFirstChild(jointName .. "RigAttachment")
											if attachment0Instance and attachment1Instance then
												socket.Attachment0 = attachment0Instance
												socket.Attachment1 = attachment1Instance
												socket.Parent = desc.Parent
												desc:Destroy()
											end
										end
									end
								end
							end
							if character ~= nil then
								player.Character = nil
								character:ClearAllChildren()
								character:Destroy()
							end
							-- Nudge the player's dead body
							-- If PrimaryPart is not set, set it to HumanoidRootPart
							-- Add the ProximityPrompt to the clone
							local prompt = self:attachProximityPrompt(characterClone, player)
							if prompt then
								self.maid:GiveTask(prompt.Triggered:Connect(function(otherPlayer)
									self:grab(characterClone, otherPlayer)
									characterClone:Destroy()
								end))
							end
							break
						end
					end
					player:SetAttribute("JustReset", false)
					player:SetAttribute("LastDamagedByAI", false)
				end)
			end)
		end)
	end
end
-- (Flamework) DeathMechanic metadata
Reflect.defineMetadata(DeathMechanic, "identifier", "game/src/mechanics/PlayerMechanics/DeathMechanic/services/death-service@DeathMechanic")
Reflect.defineMetadata(DeathMechanic, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(DeathMechanic, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(DeathMechanic, "$:flamework@Service", Service, { {} })
return {
	default = DeathMechanic,
}
