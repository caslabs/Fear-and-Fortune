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
local AxeModelComponent
do
	local super = BaseComponent
	AxeModelComponent = setmetatable({}, {
		__tostring = function()
			return "AxeModelComponent"
		end,
		__index = super,
	})
	AxeModelComponent.__index = AxeModelComponent
	function AxeModelComponent.new(...)
		local self = setmetatable({}, AxeModelComponent)
		return self:constructor(...) or self
	end
	function AxeModelComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function AxeModelComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Makeshift Axe",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function AxeModelComponent:grab(player)
		print("Axe Tool Component Initiated")
		-- Add to inventory
		self.inventorySystem:addItemToInventory(player, "AxeTool")
		self.instance:Destroy()
	end
	function AxeModelComponent:onStart()
		print("Rifle Tool Component Initiated")
		local tool = self.instance
		print("Rifle Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to RifleComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab IronWood
			self:grab(player)
		end))
	end
end
-- (Flamework) AxeModelComponent metadata
Reflect.defineMetadata(AxeModelComponent, "identifier", "game/src/entities/Tools/Axe/services/axe-component-service@AxeModelComponent")
Reflect.defineMetadata(AxeModelComponent, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(AxeModelComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(AxeModelComponent, "$c:init@Component", Component, { {
	tag = "AxeTrigger",
	instanceGuard = t.instanceIsA("Model"),
	attributes = {},
} })
return {
	AxeModelComponent = AxeModelComponent,
}
