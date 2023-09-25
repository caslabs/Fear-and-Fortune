-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local AddExposureEvent = Remotes.Server:Get("AddExposure")
local CampFireComponent
do
	local super = BaseComponent
	CampFireComponent = setmetatable({}, {
		__tostring = function()
			return "CampFireComponent"
		end,
		__index = super,
	})
	CampFireComponent.__index = CampFireComponent
	function CampFireComponent.new(...)
		local self = setmetatable({}, CampFireComponent)
		return self:constructor(...) or self
	end
	function CampFireComponent:constructor(...)
		super.constructor(self, ...)
		self.debounce = false
		self.playersInProximity = {}
	end
	function CampFireComponent:onStart()
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local part = self.instance
		local radius = Instance.new("NumberValue")
		radius.Value = 10
		radius.Name = "Radius"
		radius.Parent = part
		local proximityPart = Instance.new("Part")
		proximityPart.Name = "ProximityPart"
		proximityPart.Anchored = true
		proximityPart.CanCollide = false
		proximityPart.Transparency = 1
		proximityPart.Shape = Enum.PartType.Cylinder
		proximityPart.Orientation = Vector3.new(0, 0, 90)
		proximityPart.Size = Vector3.new(radius.Value * 2, radius.Value * 2, radius.Value * 2)
		proximityPart.Position = part.PrimaryPart.Position
		proximityPart.Parent = part
		proximityPart.Touched:Connect(function(hit)
			return self:playerEntered(hit)
		end)
		proximityPart.TouchEnded:Connect(function(hit)
			return self:playerLeft(hit)
		end)
		print("CampFireComponent initialized")
	end
	function CampFireComponent:playerEntered(hit)
		if self.debounce then
			return nil
		end
		self.debounce = true
		local character = hit.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if player and not (self.playersInProximity[player] ~= nil) then
			self.playersInProximity[player] = true
			print(player.Name .. " entered the radius.")
			AddExposureEvent:SendToPlayer(player, true)
		end
		self.debounce = false
	end
	function CampFireComponent:playerLeft(hit)
		if self.debounce then
			return nil
		end
		self.debounce = true
		local character = hit.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if player and self.playersInProximity[player] ~= nil then
			self.playersInProximity[player] = nil
			print(player.Name .. " left the radius.")
			AddExposureEvent:SendToPlayer(player, false)
		end
		self.debounce = false
	end
end
-- (Flamework) CampFireComponent metadata
Reflect.defineMetadata(CampFireComponent, "identifier", "game/src/entities/Resources/IronWood/services/campfire-component-service@CampFireComponent")
Reflect.defineMetadata(CampFireComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(CampFireComponent, "$c:init@Component", Component, { {
	tag = "CampFireTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	CampFireComponent = CampFireComponent,
}
