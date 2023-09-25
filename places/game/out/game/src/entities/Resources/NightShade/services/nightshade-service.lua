-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local NightShadeComponent
do
	local super = BaseComponent
	NightShadeComponent = setmetatable({}, {
		__tostring = function()
			return "NightShadeComponent"
		end,
		__index = super,
	})
	NightShadeComponent.__index = NightShadeComponent
	function NightShadeComponent.new(...)
		local self = setmetatable({}, NightShadeComponent)
		return self:constructor(...) or self
	end
	function NightShadeComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function NightShadeComponent:onStart()
		print("NightShade Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab NightShade
			self:grab(player)
		end))
	end
	function NightShadeComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "NightShade",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function NightShadeComponent:grab(player)
		-- TODO: Make a better Inventory System
		-- This would add "NightShade" to ALL players' inventories. Good mechanic?
		self.inventorySystem:addItemToInventory(player, "NightShade")
		print("[INFO] Grabbing NightShade")
		self.instance:Destroy()
	end
end
-- (Flamework) NightShadeComponent metadata
Reflect.defineMetadata(NightShadeComponent, "identifier", "game/src/entities/Resources/NightShade/services/nightshade-service@NightShadeComponent")
Reflect.defineMetadata(NightShadeComponent, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(NightShadeComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(NightShadeComponent, "$c:init@Component", Component, { {
	tag = "NightShadeTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	NightShadeComponent = NightShadeComponent,
}
