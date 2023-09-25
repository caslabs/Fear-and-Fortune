-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local InteractiveLadderComponent
do
	local super = BaseComponent
	InteractiveLadderComponent = setmetatable({}, {
		__tostring = function()
			return "InteractiveLadderComponent"
		end,
		__index = super,
	})
	InteractiveLadderComponent.__index = InteractiveLadderComponent
	function InteractiveLadderComponent.new(...)
		local self = setmetatable({}, InteractiveLadderComponent)
		return self:constructor(...) or self
	end
	function InteractiveLadderComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function InteractiveLadderComponent:onStart()
		print("Ladder Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab Ladder
			self:grab(player)
		end))
	end
	function InteractiveLadderComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Ladder",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function InteractiveLadderComponent:grab(player)
		-- TODO: Make a better Inventory System
		-- This would add "Ladder" to ALL players' inventories. Good mechanic?
		self.inventorySystem:addItemToInventory(player, "Ladder")
		print("[INFO] Grabbing Ladder")
		self.instance:Destroy()
	end
end
-- (Flamework) InteractiveLadderComponent metadata
Reflect.defineMetadata(InteractiveLadderComponent, "identifier", "tutorial/src/entities/Structures/Ladder/services/ladder-entity-service@InteractiveLadderComponent")
Reflect.defineMetadata(InteractiveLadderComponent, "flamework:parameters", { "tutorial/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(InteractiveLadderComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(InteractiveLadderComponent, "$c:init@Component", Component, { {
	tag = "InteractiveLadderTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	InteractiveLadderComponent = InteractiveLadderComponent,
}
