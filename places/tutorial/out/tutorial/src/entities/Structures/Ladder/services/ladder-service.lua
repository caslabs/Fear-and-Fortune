-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local LadderComponent
do
	local super = BaseComponent
	LadderComponent = setmetatable({}, {
		__tostring = function()
			return "LadderComponent"
		end,
		__index = super,
	})
	LadderComponent.__index = LadderComponent
	function LadderComponent.new(...)
		local self = setmetatable({}, LadderComponent)
		return self:constructor(...) or self
	end
	function LadderComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
	end
	function LadderComponent:onStart()
		print("Ladder Structure Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Place Down
			self:placeDown(player)
		end))
	end
	function LadderComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Place Down Ladder",
			ActionText = "Place Down",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 5,
		})
	end
	function LadderComponent:placeDown(player)
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		if not self.inventorySystem:checkItemInInventory(player, "Ladder") then
			print("Player " .. (player.Name .. " does not have a ladder in their inventory"))
			return nil
		end
		print("Attempting to place down ladder")
		-- Must have Ladder instance under the LadderTrigger
		local ladder = self.instance:FindFirstChild("Ladder")
		if ladder and ladder:IsA("BasePart") then
			-- TODO: Make a better inventory system
			-- Remove ladder from the player's inventory, for ALL players
			self.inventorySystem:removeItemFromInventory(player, "Ladder")
			-- Make Ladder appear
			ladder.CanCollide = true
			ladder.Transparency = 0
			print("[INFO] Ladder placed down")
			-- TODO: is this good? Play 3D Spatial Sound
			-- Broken, only plays once and then never again...
			local sound = "9114154635"
			local soundInstance = Make("Sound", {
				SoundId = "rbxassetid://" .. sound,
				Parent = ladder,
				Volume = 1,
				MaxDistance = 25,
				RollOffMode = Enum.RollOffMode.InverseTapered,
			})
			soundInstance:Play()
		else
			print("Could not find ladder")
		end
	end
end
-- (Flamework) LadderComponent metadata
Reflect.defineMetadata(LadderComponent, "identifier", "tutorial/src/entities/Structures/Ladder/services/ladder-service@LadderComponent")
Reflect.defineMetadata(LadderComponent, "flamework:parameters", { "tutorial/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(LadderComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(LadderComponent, "$c:init@Component", Component, { {
	tag = "LadderTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	LadderComponent = LadderComponent,
}
