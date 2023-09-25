-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local IronWoodComponent
do
	local super = BaseComponent
	IronWoodComponent = setmetatable({}, {
		__tostring = function()
			return "IronWoodComponent"
		end,
		__index = super,
	})
	IronWoodComponent.__index = IronWoodComponent
	function IronWoodComponent.new(...)
		local self = setmetatable({}, IronWoodComponent)
		return self:constructor(...) or self
	end
	function IronWoodComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function IronWoodComponent:onStart()
		print("IronWood Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab IronWood
			self:grab(player)
		end))
	end
	function IronWoodComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "IronWood",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function IronWoodComponent:grab(player)
		-- TODO: Make a better Inventory System
		-- This would add "IronWood" to ALL players' inventories. Good mechanic?
		self.inventorySystem:addItemToInventory(player, "IronWood")
		print("[INFO] Grabbing IronWood")
		self.instance:Destroy()
	end
end
-- (Flamework) IronWoodComponent metadata
Reflect.defineMetadata(IronWoodComponent, "identifier", "tutorial/src/entities/Resources/IRONWOOD/services/ironwood-service@IronWoodComponent")
Reflect.defineMetadata(IronWoodComponent, "flamework:parameters", { "tutorial/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(IronWoodComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(IronWoodComponent, "$c:init@Component", Component, { {
	tag = "IronWoodTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	IronWoodComponent = IronWoodComponent,
}
