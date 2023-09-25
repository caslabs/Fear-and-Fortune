-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local Workspace = _services.Workspace
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
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
local UpdateInventoryEvent = Remotes.Server:Get("UpdateInventory")
local DropItemFromInventoryEvent = Remotes.Server:Get("DropItemFromInventory")
local EquipItemFromInventoryEvent = Remotes.Server:Get("EquipItemFromInventory")
local ToolPickupEvent = Remotes.Server:Get("ToolPickupEvent")
local InventorySystemService
do
	InventorySystemService = setmetatable({}, {
		__tostring = function()
			return "InventorySystemService"
		end,
	})
	InventorySystemService.__index = InventorySystemService
	function InventorySystemService.new(...)
		local self = setmetatable({}, InventorySystemService)
		return self:constructor(...) or self
	end
	function InventorySystemService:constructor(profileService)
		self.profileService = profileService
		self.inventories = {}
	end
	function InventorySystemService:onInit()
		print("InventorySystem service started")
		local addItemToAllInventoriesEvent = Remotes.Server:Get("AddItemToAllInventories")
		addItemToAllInventoriesEvent:Connect(function(player, item)
			return self:addItemToAllInventories(item)
		end)
	end
	function InventorySystemService:onStart()
		print("InventorySystem service started bruh")
		Players.PlayerAdded:Connect(function(player)
			self.inventories[player] = {}
			-- For playtesting purposes, give AxeTool by default
			self:addItemToInventory(player, "AxeTool")
		end)
		Players.PlayerAdded:Connect(TS.async(function(player)
			player.Chatted:Connect(function(message)
				return self:_onPlayerChat(player, message)
			end)
		end))
		Players.PlayerRemoving:Connect(function(player)
			local isExtracted = player:GetAttribute("HasExtracted")
			if isExtracted == true then
				self:saveInventory(player)
			else
				print("[INFO] Player left without extracting. Not saving data")
			end
		end)
		print("InventorySystem service started")
		-- Add Item
		local AddItemToInventoryEvent = Remotes.Server:Get("AddItemToInventory")
		AddItemToInventoryEvent:Connect(function(player, item)
			if player then
				self:addItemToInventory(player, item, 1)
			end
		end)
		-- Drop Item
		DropItemFromInventoryEvent:Connect(function(player, item)
			if player then
				self:dropItemFromInventory(player, item)
			end
		end)
		-- Equip Item
		EquipItemFromInventoryEvent:Connect(function(player, item)
			if player then
				self:equipItemFromInventory(player, item)
			end
		end)
		-- Add Item
		Signals.AddItem:Connect(function(player, item)
			if player then
				self:addItemToInventory(player, item, 1)
			end
		end)
	end
	function InventorySystemService:getInventory(player)
		return self.inventories[player]
	end
	InventorySystemService.loadInventory = TS.async(function(self, player)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		if profile and profile:IsActive() then
			local inventoryData = profile.Data.inventory
			for item, quantity in pairs(inventoryData) do
				self:addItemToInventory(player, tostring(item), quantity)
			end
		end
	end)
	InventorySystemService.saveInventory = TS.async(function(self, player)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		if profile and profile:IsActive() then
			local inventory = self.inventories[player]
			if inventory then
				local _arg0 = function(quantity, item)
					-- eslint-disable-next-line roblox-ts/lua-truthiness
					local _value = profile.Data.inventory[item]
					if _value ~= 0 and (_value == _value and _value) then
						profile.Data.inventory[item] += quantity
					else
						profile.Data.inventory[item] = quantity
					end
				end
				for _k, _v in pairs(inventory) do
					_arg0(_v, _k, inventory)
				end
				profile:Release()
			end
		end
	end)
	function InventorySystemService:addItemToInventory(player, item, quantity)
		if quantity == nil then
			quantity = 1
		end
		local inventory = self.inventories[player]
		if not inventory then
			inventory = {}
			local _inventories = self.inventories
			local _inventory = inventory
			_inventories[player] = _inventory
		end
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		local _condition = inventory[item]
		if not (_condition ~= 0 and (_condition == _condition and _condition)) then
			_condition = 0
		end
		local currentQuantity = _condition
		local _inventory = inventory
		local _arg1 = currentQuantity + quantity
		_inventory[item] = _arg1
		print("[INVENTORY] currentQuantity)", currentQuantity)
		print("[INVENTORY] quantity)", quantity)
		print("[INVENTORY] currentQuantity + quantity)", currentQuantity + quantity)
		-- Check if PickupSound Sound Instance is not yet available
		UpdateInventoryEvent:SendToPlayer(player, player, item, "add", currentQuantity + quantity)
	end
	function InventorySystemService:removeItemFromInventory(player, item)
		local inventory = self.inventories[player]
		if inventory then
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			local _condition = inventory[item]
			if not (_condition ~= 0 and (_condition == _condition and _condition)) then
				_condition = 0
			end
			local currentQuantity = _condition
			if currentQuantity > 1 then
				local _arg1 = currentQuantity - 1
				inventory[item] = _arg1
				UpdateInventoryEvent:SendToPlayer(player, player, item, "remove", currentQuantity - 1)
			else
				inventory[item] = nil
				UpdateInventoryEvent:SendToPlayer(player, player, item, "remove", 0)
			end
		end
	end
	function InventorySystemService:checkItemInInventory(player, item)
		local inventory = self.inventories[player]
		return if inventory then inventory[item] ~= nil else false
	end
	function InventorySystemService:addItemToAllInventories(item, quantity)
		if quantity == nil then
			quantity = 1
		end
		for player in pairs(self.inventories) do
			self:addItemToInventory(player, item, quantity)
		end
	end
	function InventorySystemService:removeItemFromAllInventories(item)
		for player in pairs(self.inventories) do
			self:removeItemFromInventory(player, item)
		end
	end
	function InventorySystemService:fire(player)
		print("Swing!")
	end
	function InventorySystemService:equipItemFromInventory(player, item)
		-- Remove Item from Inventory
		if self:checkItemInInventory(player, item) then
			self:removeItemFromInventory(player, item)
		end
		print("Item Equipped: ", item)
		-- Get the script
		local toolName = item .. "Trigger"
		print("Tool Name: ", toolName)
		print("tool", (Workspace:FindFirstChild(toolName)))
		print("Equip Tool Initiated")
		-- Add the tool to the player's backpack and destroy the instance in the Workspace.
		local _result = Workspace:FindFirstChild(toolName)
		if _result ~= nil then
			_result = _result:Clone()
		end
		local tool = _result
		tool.Parent = Workspace
		tool.Name = toolName
		tool.Parent = player.Character
		print("Tool Parent: ", tool.Parent)
		print("Tool created", tool)
		print(tool.Name)
		local _result_1 = tool.Parent
		if _result_1 ~= nil then
			_result_1 = _result_1:IsA("Model")
		end
		if _result_1 then
			if not player then
				error("Player not found!")
			end
			-- Check if the tool is already in the player's backpack.
			local playerBackpack = player:FindFirstChild("Backpack")
			if playerBackpack and not playerBackpack:FindFirstChild(tool.Name) then
				print("Tool is not in the player's backpack.")
				local _result_2 = playerBackpack
				if _result_2 ~= nil then
					_result_2 = _result_2:FindFirstChild(tool.Name)
				end
				print(_result_2)
				-- Only send the ToolPickupEvent if the tool is not already in the backpack.
				ToolPickupEvent:SendToPlayer(player, player, tool)
			else
				local _result_2 = playerBackpack
				if _result_2 ~= nil then
					_result_2 = _result_2:FindFirstChild(tool.Name)
				end
				print(_result_2)
				print("Tool is already in the player's backpack.")
			end
		else
			print("Tool does not have a parent or is not a model")
		end
	end
	function InventorySystemService:dropItemFromInventory(player, item)
		if self:checkItemInInventory(player, item) then
			self:removeItemFromInventory(player, item)
		end
		local character = player.Character
		if character then
			local primaryPart = character.PrimaryPart
			if primaryPart then
				local lastPosition = primaryPart.Position
				-- Drop Physical Block
				local dropRadius = 1
				local _vector3 = Vector3.new(math.random() * dropRadius - dropRadius / 2, 0, math.random() * dropRadius - dropRadius / 2)
				local dropPosition = lastPosition + _vector3
				local _binding = createPhysicalItem(item, dropPosition)
				local model = _binding.model
				local prompt = _binding.prompt
				print("POOPED ITEM")
				prompt.Triggered:Connect(function(otherPlayer)
					self:addItemToInventory(otherPlayer, item)
					model:Destroy()
				end)
			else
				-- Handle cases where PrimaryPart is undefined
				print("Primary part is not defined for the character")
			end
		else
			-- Handle cases where the character is not available
			print("Character is not available for the player")
		end
		print("Dropped Item")
	end
	function InventorySystemService:dropItem(item, position)
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
	function InventorySystemService:_onPlayerChat(player, message)
		-- TODO: DEV ONLY CAN START THE GAME
		if player.UserId == 11697914 then
			-- Give player a specific item using /give <item>
			local _binding = string.split(message, " ")
			local command = _binding[1]
			local item = _binding[2]
			if command == "/give" then
				self:addItemToInventory(player, item)
			end
		else
			print("Not a dev! Sorry!")
		end
	end
end
-- (Flamework) InventorySystemService metadata
Reflect.defineMetadata(InventorySystemService, "identifier", "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService")
Reflect.defineMetadata(InventorySystemService, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic" })
Reflect.defineMetadata(InventorySystemService, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(InventorySystemService, "$:flamework@Service", Service, { {
	loadOrder = 99999,
} })
return {
	InventorySystemService = InventorySystemService,
}
