-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local HumanMeatComponent
do
	local super = BaseComponent
	HumanMeatComponent = setmetatable({}, {
		__tostring = function()
			return "HumanMeatComponent"
		end,
		__index = super,
	})
	HumanMeatComponent.__index = HumanMeatComponent
	function HumanMeatComponent.new(...)
		local self = setmetatable({}, HumanMeatComponent)
		return self:constructor(...) or self
	end
	function HumanMeatComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function HumanMeatComponent:onStart()
		print("HumanMeat Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab HumanMeat
			self:grab(player)
		end))
	end
	function HumanMeatComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "HumanMeat",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function HumanMeatComponent:grab(player)
		-- TODO: Make a better Inventory System
		-- This would add "HumanMeat" to ALL players' inventories. Good mechanic?
		self.inventorySystem:addItemToInventory(player, "HumanMeat")
		print("[INFO] Grabbing HumanMeat")
		self.instance:Destroy()
	end
end
-- (Flamework) HumanMeatComponent metadata
Reflect.defineMetadata(HumanMeatComponent, "identifier", "game/src/entities/Resources/HumanMeat/services/human-meat-service@HumanMeatComponent")
Reflect.defineMetadata(HumanMeatComponent, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(HumanMeatComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(HumanMeatComponent, "$c:init@Component", Component, { {
	tag = "HumanMeatTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	HumanMeatComponent = HumanMeatComponent,
}
