-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local WeirwoodSilverComponent
do
	local super = BaseComponent
	WeirwoodSilverComponent = setmetatable({}, {
		__tostring = function()
			return "WeirwoodSilverComponent"
		end,
		__index = super,
	})
	WeirwoodSilverComponent.__index = WeirwoodSilverComponent
	function WeirwoodSilverComponent.new(...)
		local self = setmetatable({}, WeirwoodSilverComponent)
		return self:constructor(...) or self
	end
	function WeirwoodSilverComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function WeirwoodSilverComponent:onStart()
		print("WeirwoodSilver Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab WeirwoodSilver
			self:grab(player)
		end))
	end
	function WeirwoodSilverComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "WeirwoodSilver",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function WeirwoodSilverComponent:grab(player)
		-- TODO: Make a better Inventory System
		-- This would add "WeirwoodSilver" to ALL players' inventories. Good mechanic?
		self.inventorySystem:addItemToInventory(player, "WeirwoodSilver")
		print("[INFO] Grabbing WeirwoodSilver")
		self.instance:Destroy()
	end
end
-- (Flamework) WeirwoodSilverComponent metadata
Reflect.defineMetadata(WeirwoodSilverComponent, "identifier", "game/src/entities/Resources/WeirwoodSilver/services/weirwoodsilver-service@WeirwoodSilverComponent")
Reflect.defineMetadata(WeirwoodSilverComponent, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(WeirwoodSilverComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(WeirwoodSilverComponent, "$c:init@Component", Component, { {
	tag = "WeirwoodSilverTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	WeirwoodSilverComponent = WeirwoodSilverComponent,
}
