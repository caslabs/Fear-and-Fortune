-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local StatueComponent
do
	local super = BaseComponent
	StatueComponent = setmetatable({}, {
		__tostring = function()
			return "StatueComponent"
		end,
		__index = super,
	})
	StatueComponent.__index = StatueComponent
	function StatueComponent.new(...)
		local self = setmetatable({}, StatueComponent)
		return self:constructor(...) or self
	end
	function StatueComponent:constructor(...)
		super.constructor(self, ...)
		self.flipState = false
		self.flipTimer = 0
		self.flipInterval = 5
	end
	function StatueComponent:getFloatHeight(time, amplitude, frequency, phase, startPosition)
		return amplitude * math.sin(frequency * time + phase) + startPosition.Y
	end
	function StatueComponent:updateModel(model, time, startPosition, startOrientation, amplitude, frequency, phase)
		local newPosition = Vector3.new(startPosition.X, self:getFloatHeight(time, amplitude, frequency, phase, startPosition), startPosition.Z)
		local yAngle = if self.flipState then math.pi else 0
		local _fn = model
		local _cFrame = CFrame.new(newPosition)
		local _arg0 = CFrame.fromOrientation(0, yAngle, 0)
		_fn:SetPrimaryPartCFrame(_cFrame * _arg0)
	end
	function StatueComponent:onStart()
		print("Statue Component Started")
		if self.instance:IsA("Model") then
			local model = self.instance
			print("Starting animation")
			local amplitude = 5
			local frequency = 1
			local phase = 0
			local startPosition = model.PrimaryPart.Position
			local startOrientation = Vector3.new(0, 0, 0)
			while true do
				-- Get the current time
				local time = tick()
				-- Check if it's time to flip
				if time - self.flipTimer >= self.flipInterval then
					self.flipState = not self.flipState
					self.flipTimer = time
				end
				-- Update the model's position and orientation
				self:updateModel(model, time, startPosition, startOrientation, amplitude, frequency, phase)
				-- Wait for the next frame
				RunService.Heartbeat:Wait()
			end
		end
	end
end
-- (Flamework) StatueComponent metadata
Reflect.defineMetadata(StatueComponent, "identifier", "tutorial/src/systems/LevelSystem/components/skull-component@StatueComponent")
Reflect.defineMetadata(StatueComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(StatueComponent, "$c:init@Component", Component, { {
	tag = "FloatingSkull",
	attributes = {},
} })
return {
	StatueComponent = StatueComponent,
}
