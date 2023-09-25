-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local EldritchStoneComponent
do
	local super = BaseComponent
	EldritchStoneComponent = setmetatable({}, {
		__tostring = function()
			return "EldritchStoneComponent"
		end,
		__index = super,
	})
	EldritchStoneComponent.__index = EldritchStoneComponent
	function EldritchStoneComponent.new(...)
		local self = setmetatable({}, EldritchStoneComponent)
		return self:constructor(...) or self
	end
	function EldritchStoneComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function EldritchStoneComponent:onStart()
		print("Eldritch Stone Object Component Initiated")
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
	function EldritchStoneComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Eldritch Stone",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function EldritchStoneComponent:grab(player)
		-- TODO: Make a better Inventory System
		-- This would add "Ladder" to ALL players' inventories. Good mechanic?
		self.inventorySystem:addItemToInventory(player, "EldritchStone")
		print("[INFO] Grabbing Ladder")
		self.instance:Destroy()
	end
end
-- (Flamework) EldritchStoneComponent metadata
Reflect.defineMetadata(EldritchStoneComponent, "identifier", "tutorial/src/entities/Resources/ELDRITCHSTONE/services/eldritchstone-service@EldritchStoneComponent")
Reflect.defineMetadata(EldritchStoneComponent, "flamework:parameters", { "tutorial/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(EldritchStoneComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(EldritchStoneComponent, "$c:init@Component", Component, { {
	tag = "EldritchStoneTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	EldritchStoneComponent = EldritchStoneComponent,
}
