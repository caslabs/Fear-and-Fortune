-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local UpdateInventoryEvent = Remotes.Server:Get("UpdateInventory")
local UpdateInventoryTradingEvent = Remotes.Server:Get("UpdateInventoryTrading")
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
	function InventorySystemService:onStart()
		print("InventorySystem service started")
		Players.PlayerAdded:Connect(TS.async(function(player)
			local profile = self.profileService:getProfile(player)
			while not profile do
				TS.await(TS.Promise.delay(1))
				profile = self.profileService:getProfile(player)
			end
			if profile then
				local inventoryData = profile.Data.inventory
				for item, quantity in pairs(inventoryData) do
					print("[INVENTORY] Adding " .. tostring(item) .. " x " .. tostring(quantity) .. " to inventory")
					self:updateInventory(player, tostring(item), quantity)
				end
			else
				print("[INVENTORY] Failed to load profile for " .. player.Name)
			end
		end))
		Players.PlayerRemoving:Connect(function(player)
			local inventory = self.inventories[player]
			if inventory then
				local _profile = self.profileService
				if _profile ~= nil then
					_profile = _profile:getProfile(player)
				end
				local profile = _profile
				if profile and profile:IsActive() then
					for item, quantity in pairs(inventory) do
						profile.Data.inventory[item] = quantity
					end
					profile:Release()
				end
				self.inventories[player] = nil
			end
		end)
	end
	function InventorySystemService:updateInventory(player, item, quantity)
		local inventory = self.inventories[player]
		if not inventory then
			inventory = {}
			local _inventories = self.inventories
			local _inventory = inventory
			_inventories[player] = _inventory
		end
		inventory[item] = quantity
		print(quantity)
		-- if quantity is 0, remove from inventory
		if quantity > 0 then
			print("adding item to inventory " .. item .. " x " .. tostring(quantity))
			UpdateInventoryEvent:SendToPlayer(player, player, item, "add", quantity)
			UpdateInventoryTradingEvent:SendToPlayer(player, player, item, "add", quantity)
		else
			print("removing item to inventory " .. item .. " x " .. tostring(quantity))
			UpdateInventoryEvent:SendToPlayer(player, player, item, "remove", quantity)
			UpdateInventoryTradingEvent:SendToPlayer(player, player, item, "remove", quantity)
		end
	end
	function InventorySystemService:addItemToInventory(player, item)
		local inventory = self.inventories[player]
		if inventory then
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			local _condition = inventory[item]
			if not (_condition ~= 0 and (_condition == _condition and _condition)) then
				_condition = 0
			end
			local quantity = _condition
			quantity += 1
			self:updateInventory(player, item, quantity)
		end
	end
	function InventorySystemService:removeItemFromInventory(player, item)
		local inventory = self.inventories[player]
		if inventory and inventory[item] ~= nil then
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			local _condition = inventory[item]
			if not (_condition ~= 0 and (_condition == _condition and _condition)) then
				_condition = 0
			end
			local quantity = _condition
			quantity = if quantity > 0 then quantity - 1 else 0
			self:updateInventory(player, item, quantity)
		end
	end
	function InventorySystemService:getInventory(player)
		return self.inventories[player]
	end
	function InventorySystemService:checkItemInInventory(player, item)
		local inventory = self.inventories[player]
		return if inventory then inventory[item] ~= nil else false
	end
	function InventorySystemService:setInventory(player, newData)
		print("new stash data 4.1 " .. tostring(newData))
		-- Clear the current inventory
		local inventory = self.inventories[player]
		-- Iterate through the new data and add it to the inventory
		--[[
			["EldritchStone"] = -1,
			["HumanHeart"] = 2,
			["HumanMeat"] = -1
		]]
		for item, quantity in pairs(newData) do
			print("[OOGA] " .. tostring(item) .. " x " .. tostring(quantity))
			self:updateInventory(player, tostring(item), quantity)
		end
		print("[AFTER TRADE] " .. tostring(inventory))
		print("[INVENTORY] Set inventory for " .. player.Name)
	end
end
-- (Flamework) InventorySystemService metadata
Reflect.defineMetadata(InventorySystemService, "identifier", "lobby/src/systems/InventorySystem/services/inventory-service@InventorySystemService")
Reflect.defineMetadata(InventorySystemService, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic" })
Reflect.defineMetadata(InventorySystemService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(InventorySystemService, "$:flamework@Service", Service, { {
	loadOrder = 99999,
} })
return {
	InventorySystemService = InventorySystemService,
}
