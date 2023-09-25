-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local PlayGunShakeEvent = Remotes.Server:Get("PlayGunShake")
local ToolPickupEvent = Remotes.Server:Get("ToolPickupEvent")
local ToolRemovedEvent = Remotes.Server:Get("ToolRemovedEvent")
local UpdateAmmoEvent = Remotes.Server:Get("UpdateAmmoEvent")
local activatedConnection
local animationInstance = Instance.new("Animation")
animationInstance.AnimationId = "rbxassetid://567480700O"
local rifleData = {
	ammo = 8,
	maxAmmo = 8,
}
local PickaxeModelComponent
do
	local super = BaseComponent
	PickaxeModelComponent = setmetatable({}, {
		__tostring = function()
			return "PickaxeModelComponent"
		end,
		__index = super,
	})
	PickaxeModelComponent.__index = PickaxeModelComponent
	function PickaxeModelComponent.new(...)
		local self = setmetatable({}, PickaxeModelComponent)
		return self:constructor(...) or self
	end
	function PickaxeModelComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function PickaxeModelComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Makeshift Pickaxe",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function PickaxeModelComponent:grab(player)
		print("Pickaxe Tool Component Initiated")
		-- Add to inventory
		self.inventorySystem:addItemToInventory(player, "PickaxeTool")
		self.instance:Destroy()
	end
	function PickaxeModelComponent:onStart()
		print("Axe Tool Component Initiated")
		local tool = self.instance
		print("Pickaxe Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to Pickaxe because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab IronWood
			self:grab(player)
		end))
	end
end
-- (Flamework) PickaxeModelComponent metadata
Reflect.defineMetadata(PickaxeModelComponent, "identifier", "game/src/entities/Tools/Pickaxe/services/pickaxe-component-service@PickaxeModelComponent")
Reflect.defineMetadata(PickaxeModelComponent, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(PickaxeModelComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(PickaxeModelComponent, "$c:init@Component", Component, { {
	tag = "PickaxeTrigger",
	instanceGuard = t.instanceIsA("Model"),
	attributes = {},
} })
return {
	PickaxeModelComponent = PickaxeModelComponent,
}
