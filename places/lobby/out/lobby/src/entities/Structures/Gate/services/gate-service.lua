-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
-- TODO: Refactor this to be a generic door component
local GateComponent
do
	local super = BaseComponent
	GateComponent = setmetatable({}, {
		__tostring = function()
			return "GateComponent"
		end,
		__index = super,
	})
	GateComponent.__index = GateComponent
	function GateComponent.new(...)
		local self = setmetatable({}, GateComponent)
		return self:constructor(...) or self
	end
	function GateComponent:constructor(...)
		super.constructor(self, ...)
	end
	function GateComponent:onStart()
		print("Gate Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Open Door
			self:moveDoor()
		end))
	end
	function GateComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Gate",
			ActionText = "Open",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
		})
	end
	function GateComponent:moveDoor()
		print("[INFO] Attempting to move door")
		if self.instance:IsA("Model") and (self.instance).PrimaryPart then
			local primaryPart = (self.instance).PrimaryPart
			primaryPart.Anchored = false
			primaryPart:SetNetworkOwner()
			RunService.Heartbeat:Connect(function()
				local _position = primaryPart.Position
				local _vector3 = Vector3.new(0, 0, 0.1)
				primaryPart.Position = _position + _vector3
			end)
			print("[INFO] Moving Door")
		elseif self.instance:IsA("BasePart") then
			local basePart = self.instance
			basePart.Anchored = false
			basePart:SetNetworkOwner()
			RunService.Heartbeat:Connect(function()
				local _position = basePart.Position
				local _vector3 = Vector3.new(0, 0, 0.1)
				basePart.Position = _position + _vector3
			end)
			print("[INFO] Moving Door2")
		end
	end
end
-- (Flamework) GateComponent metadata
Reflect.defineMetadata(GateComponent, "identifier", "lobby/src/entities/Structures/Gate/services/gate-service@GateComponent")
Reflect.defineMetadata(GateComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(GateComponent, "$c:init@Component", Component, { {
	tag = "Gate",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	GateComponent = GateComponent,
}
