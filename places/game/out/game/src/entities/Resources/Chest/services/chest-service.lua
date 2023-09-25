-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local ChestComponent
do
	local super = BaseComponent
	ChestComponent = setmetatable({}, {
		__tostring = function()
			return "ChestComponent"
		end,
		__index = super,
	})
	ChestComponent.__index = ChestComponent
	function ChestComponent.new(...)
		local self = setmetatable({}, ChestComponent)
		return self:constructor(...) or self
	end
	function ChestComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function ChestComponent:onStart()
		print("Chest Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab Chest
			self:grab(player)
		end))
	end
	function ChestComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Chest",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function ChestComponent:grab(player)
		-- TODO: Make a better Inventory System
		-- This would add "Chest" to ALL players' inventories. Good mechanic?
		self.inventorySystem:addItemToInventory(player, "GoldAmulet")
		print("[INFO] Grabbing Chest")
		self.instance:Destroy()
	end
end
-- (Flamework) ChestComponent metadata
Reflect.defineMetadata(ChestComponent, "identifier", "game/src/entities/Resources/Chest/services/chest-service@ChestComponent")
Reflect.defineMetadata(ChestComponent, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(ChestComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(ChestComponent, "$c:init@Component", Component, { {
	tag = "ChestTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	ChestComponent = ChestComponent,
}
