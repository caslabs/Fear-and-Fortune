-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local CraftingTableComponent
do
	local super = BaseComponent
	CraftingTableComponent = setmetatable({}, {
		__tostring = function()
			return "CraftingTableComponent"
		end,
		__index = super,
	})
	CraftingTableComponent.__index = CraftingTableComponent
	function CraftingTableComponent.new(...)
		local self = setmetatable({}, CraftingTableComponent)
		return self:constructor(...) or self
	end
	function CraftingTableComponent:constructor()
		super.constructor(self)
	end
	function CraftingTableComponent:onStart()
		print("CraftingTable Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab CraftingTable
			self:interact(player)
		end))
	end
	function CraftingTableComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Crafting Table",
			ActionText = "Craft",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function CraftingTableComponent:interact(player)
		Signals.OpenCraft:Fire()
		print("[CRAFT] Opening CraftingTable")
	end
end
-- (Flamework) CraftingTableComponent metadata
Reflect.defineMetadata(CraftingTableComponent, "identifier", "game/src/systems/CraftingSystem/controller/crafting-table-controller@CraftingTableComponent")
Reflect.defineMetadata(CraftingTableComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(CraftingTableComponent, "$c:init@Component", Component, { {
	tag = "CraftTableStructureTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	CraftingTableComponent = CraftingTableComponent,
}
