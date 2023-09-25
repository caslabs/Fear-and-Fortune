-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local DataStoreService = TS.import(script, TS.getModule(script, "@rbxts", "services")).DataStoreService
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local ProfileService = TS.import(script, TS.getModule(script, "@rbxts", "profileservice").src)
-- TODO: Test if successful_expeditions is counted
local profileTemplate = {
	successful_expeditions = 0,
}
-- TODO: Test if new datastore works
local profileStore = ProfileService.GetProfileStore("PlayerData", profileTemplate)
-- TODO: Test if successful_expeditions is counted
local ExitPortalActivationComponent
do
	local super = BaseComponent
	ExitPortalActivationComponent = setmetatable({}, {
		__tostring = function()
			return "ExitPortalActivationComponent"
		end,
		__index = super,
	})
	ExitPortalActivationComponent.__index = ExitPortalActivationComponent
	function ExitPortalActivationComponent.new(...)
		local self = setmetatable({}, ExitPortalActivationComponent)
		return self:constructor(...) or self
	end
	function ExitPortalActivationComponent:constructor(inventorySystem)
		super.constructor(self)
		self.inventorySystem = inventorySystem
		self.ExpeditionData = DataStoreService:GetOrderedDataStore("ExpeditionLeaderboard")
	end
	function ExitPortalActivationComponent:onStart()
		print("ExitPortalActivation Structure Component Initiated")
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
	function ExitPortalActivationComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Activate Exit Portal",
			ActionText = "Perform Ritual",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 5,
		})
	end
	function ExitPortalActivationComponent:placeDown(player)
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		if not self.inventorySystem:checkItemInInventory(player, "CultRune") then
			-- TODO: Inform audio and visual que to player
			print("Player " .. (player.Name .. " does not have a CultRune in their inventory"))
			return nil
		end
		print("Attempting to place down ExitPortalActivation")
		-- Must have ExitPortalActivation instance under the ExitPortalActivationTrigger
		local ExitPortalActivation = self.instance:FindFirstChild("ExitPortalBase")
		if ExitPortalActivation and ExitPortalActivation:IsA("BasePart") then
			-- TODO: Make a better inventory system
			-- Remove ExitPortalActivation from the player's inventory, for ALL players
			self.inventorySystem:removeItemFromInventory(player, "CultRune")
			-- Make ExitPortalActivation Appear
			ExitPortalActivation.CanCollide = true
			ExitPortalActivation.Transparency = 0
			-- Put ExitPortal from Workspace ontop of ExitPortalActivation
			local _ExitPortal = Workspace:FindFirstChild("ExitPortal")
			if _ExitPortal ~= nil then
				_ExitPortal = _ExitPortal:Clone()
			end
			local ExitPortal = _ExitPortal
			-- TODO: Apparently i need to recraete our Exit Portal Trigger?
			if ExitPortal and ExitPortal:IsA("Model") then
				ExitPortal.Parent = ExitPortalActivation
				-- Place 5 studs on top of ExitPortal
				local _fn = ExitPortal
				local _cFrame = ExitPortalActivation.CFrame
				local _vector3 = Vector3.new(0, 5, 0)
				_fn:SetPrimaryPartCFrame(_cFrame + _vector3)
			else
				warn("Could not find ExitPortal")
			end
			print("[INFO] ExitPortalActivation placed down")
			-- TODO: is this good? Play 3D Spatial Sound
			-- Broken, only plays once and then never again...
			local soundID = "13983704227"
			local sound = "rbxassetid://" .. soundID
			local soundInstance = Instance.new("Sound")
			soundInstance.SoundId = sound
			soundInstance.Parent = ExitPortalActivation
			soundInstance.Volume = 7
			soundInstance.MaxDistance = 10
			soundInstance:Play()
		else
			print("Could not find ExitPortalActivation")
		end
	end
end
-- (Flamework) ExitPortalActivationComponent metadata
Reflect.defineMetadata(ExitPortalActivationComponent, "identifier", "game/src/entities/Structures/ExitPortal/services/exit-portal-service@ExitPortalActivationComponent")
Reflect.defineMetadata(ExitPortalActivationComponent, "flamework:parameters", { "game/src/systems/InventorySystem/services/inventory-system-service@InventorySystemService" })
Reflect.defineMetadata(ExitPortalActivationComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(ExitPortalActivationComponent, "$c:init@Component", Component, { {
	tag = "ExitPortalPlacementTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	ExitPortalActivationComponent = ExitPortalActivationComponent,
}
