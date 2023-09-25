-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local UpdateInventoryEvent = Remotes.Server:Get("UpdateInventory")
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
	function InventorySystemService:constructor()
		self.inventories = {}
	end
	function InventorySystemService:onInit()
		print("InventorySystem service started")
		local addItemToAllInventoriesEvent = Remotes.Server:Get("AddItemToAllInventories")
		addItemToAllInventoriesEvent:Connect(function(player, item)
			return self:addItemToAllInventories(item)
		end)
	end
	function InventorySystemService:addItemToAllInventories(item)
		for player in pairs(self.inventories) do
			self:addItemToInventory(player, item)
		end
	end
	function InventorySystemService:removeItemFromAllInventories(item)
		for player in pairs(self.inventories) do
			self:removeItemFromInventory(player, item)
		end
	end
	function InventorySystemService:addItemToInventory(player, item)
		local inventory = self.inventories[player]
		if not inventory then
			inventory = {}
			local _inventories = self.inventories
			local _inventory = inventory
			_inventories[player] = _inventory
		end
		inventory[item] = true
		UpdateInventoryEvent:SendToPlayer(player, player, item, "add")
	end
	function InventorySystemService:removeItemFromInventory(player, item)
		local inventory = self.inventories[player]
		if inventory then
			inventory[item] = nil
			UpdateInventoryEvent:SendToPlayer(player, player, item, "remove")
		end
	end
	function InventorySystemService:checkItemInInventory(player, item)
		local inventory = self.inventories[player]
		return if inventory then inventory[item] ~= nil else false
	end
end
-- (Flamework) InventorySystemService metadata
Reflect.defineMetadata(InventorySystemService, "identifier", "tutorial/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService")
Reflect.defineMetadata(InventorySystemService, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(InventorySystemService, "$:flamework@Service", Service, { {} })
return {
	InventorySystemService = InventorySystemService,
}
