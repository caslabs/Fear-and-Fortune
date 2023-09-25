-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local CraftSystemService
do
	CraftSystemService = setmetatable({}, {
		__tostring = function()
			return "CraftSystemService"
		end,
	})
	CraftSystemService.__index = CraftSystemService
	function CraftSystemService.new(...)
		local self = setmetatable({}, CraftSystemService)
		return self:constructor(...) or self
	end
	function CraftSystemService:constructor(inventoryService)
		self.inventoryService = inventoryService
	end
	function CraftSystemService:onInit()
		print("CraftSystemController initialized")
	end
	function CraftSystemService:onStart()
		print("CraftSystemController started")
		local CheckCraftingIngredientsEvent = Remotes.Server:Get("CheckCraftingIngredients")
		CheckCraftingIngredientsEvent:Connect(function(player, player2, item, ingredients)
			if player then
				self:craftItem(player, item, ingredients)
			end
		end)
	end
	function CraftSystemService:checkCraftingIngredients(player, item, ingredients)
		-- The 'requiredIngredients' are now passed from the client
		local requiredIngredients = ingredients
		local playerInventory = self.inventoryService:getInventory(player)
		if not playerInventory then
			return false
		end
		for _, ingredient in ipairs(requiredIngredients) do
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			local _itemName = ingredient.itemName
			local _condition = playerInventory[_itemName]
			if not (_condition ~= 0 and (_condition == _condition and _condition)) then
				_condition = 0
			end
			local playerIngredientQuantity = _condition
			if playerIngredientQuantity < ingredient.quantity then
				print("[CRAFTING] Failed!")
				return false
			end
		end
		print("[CRAFTING] Sucesss!")
		return true
	end
	function CraftSystemService:craftItem(player, item, ingredients)
		local hasIngredients = self:checkCraftingIngredients(player, item, ingredients)
		if hasIngredients then
			for _, ingredient in ipairs(ingredients) do
				do
					local i = 0
					local _shouldIncrement = false
					while true do
						if _shouldIncrement then
							i += 1
						else
							_shouldIncrement = true
						end
						if not (i < ingredient.quantity) then
							break
						end
						self.inventoryService:removeItemFromInventory(player, ingredient.itemName)
					end
				end
			end
			print("[CRAFTING] Player " .. (player.Name .. (" successfully crafted " .. item)))
			self.inventoryService:addItemToInventory(player, item)
			return true
		else
			print("[CRAFTING] Player " .. (player.Name .. (" doesn't have the necessary ingredients to craft " .. item)))
			return false
		end
	end
end
-- (Flamework) CraftSystemService metadata
Reflect.defineMetadata(CraftSystemService, "identifier", "game/src/systems/CraftingSystem/services/crafting-system-services@CraftSystemService")
Reflect.defineMetadata(CraftSystemService, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(CraftSystemService, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(CraftSystemService, "$:flamework@Service", Service, { {} })
return {
	default = CraftSystemService,
}
