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
local BansheeTrapComponent
do
	local super = BaseComponent
	BansheeTrapComponent = setmetatable({}, {
		__tostring = function()
			return "BansheeTrapComponent"
		end,
		__index = super,
	})
	BansheeTrapComponent.__index = BansheeTrapComponent
	function BansheeTrapComponent.new(...)
		local self = setmetatable({}, BansheeTrapComponent)
		return self:constructor(...) or self
	end
	function BansheeTrapComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function BansheeTrapComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Banshee Trap",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function BansheeTrapComponent:grab(player)
		print("Banshee Trap Tool Component Initiated")
		-- Add to inventory
		self.inventorySystem:addItemToInventory(player, "BansheeTrapTool")
		self.instance:Destroy()
	end
	function BansheeTrapComponent:onStart()
		print("Banshee Trap Tool Component Initiated")
		local tool = self.instance
		print("Banshee Trap Tool Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to BansheeTrapComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab IronWood
			self:grab(player)
		end))
	end
end
-- (Flamework) BansheeTrapComponent metadata
Reflect.defineMetadata(BansheeTrapComponent, "identifier", "game/src/entities/Resources/IronWood/services/bansheetrap-component-service@BansheeTrapComponent")
Reflect.defineMetadata(BansheeTrapComponent, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(BansheeTrapComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(BansheeTrapComponent, "$c:init@Component", Component, { {
	tag = "BansheeTrapTrigger",
	instanceGuard = t.instanceIsA("Model"),
	attributes = {},
} })
return {
	BansheeTrapComponent = BansheeTrapComponent,
}
