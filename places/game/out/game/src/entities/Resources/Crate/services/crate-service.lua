-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local CrateComponent
do
	local super = BaseComponent
	CrateComponent = setmetatable({}, {
		__tostring = function()
			return "CrateComponent"
		end,
		__index = super,
	})
	CrateComponent.__index = CrateComponent
	function CrateComponent.new(...)
		local self = setmetatable({}, CrateComponent)
		return self:constructor(...) or self
	end
	function CrateComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function CrateComponent:onStart()
		print("Crate Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab Crate
			self:grab(player)
		end))
	end
	function CrateComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Crate",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function CrateComponent:grab(player)
		-- TODO: Need a Energy System - Food / Water ?
		self.inventorySystem:addItemToInventory(player, "Berry")
		print("[INFO] Grabbing Crate")
		self.instance:Destroy()
	end
end
-- (Flamework) CrateComponent metadata
Reflect.defineMetadata(CrateComponent, "identifier", "game/src/entities/Resources/Crate/services/crate-service@CrateComponent")
Reflect.defineMetadata(CrateComponent, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(CrateComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(CrateComponent, "$c:init@Component", Component, { {
	tag = "CrateTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	CrateComponent = CrateComponent,
}
