-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local DrinkBar = TS.import(script, script.Parent.Parent.Parent, "ui", "components", "drink-bar").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
-- Define ToolData for the Rifle
-- TODO: Prototype
local animationInstance = Instance.new("Animation")
animationInstance.AnimationId = "rbxassetid://14299421654"
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local CanteenToolTrigger
do
	local super = BaseComponent
	CanteenToolTrigger = setmetatable({}, {
		__tostring = function()
			return "CanteenToolTrigger"
		end,
		__index = super,
	})
	CanteenToolTrigger.__index = CanteenToolTrigger
	function CanteenToolTrigger.new(...)
		local self = setmetatable({}, CanteenToolTrigger)
		return self:constructor(...) or self
	end
	function CanteenToolTrigger:constructor(...)
		super.constructor(self, ...)
	end
	function CanteenToolTrigger:onStart()
		print("Canteen Tool Controller Component Initiated")
		local tool = self.instance
		local player = Players.LocalPlayer
		local animationTrack
		local _humanoid = player.Character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChildOfClass("Humanoid")
		end
		local humanoid = _humanoid
		if humanoid then
			local animator = humanoid:FindFirstChildOfClass("Animator")
			if animator then
				animationTrack = animator:LoadAnimation(animationInstance)
			end
		end
		local handle = Roact.mount(Roact.createFragment({
			DrinkBarScreen = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
				DisplayOrder = -999,
			}, {
				Roact.createElement(DrinkBar, {
					durationD = 0,
					isVisible = false,
				}),
			}),
		}), PlayerGui)
		tool.Equipped:Connect(function()
			print("Tool Equipped")
			Signals.showDrinkBar:Fire(true)
		end)
		tool.Activated:Connect(function()
			Signals.showDrinkBar:Fire(true)
			print("Tool Activated Locally")
			self.holdStartTick = tick()
			local _result = animationTrack
			if _result ~= nil then
				_result:Play()
			end
			self.holdDurationTimer = RunService.Heartbeat:Connect(function()
				local _exp = tick()
				local _condition = self.holdStartTick
				if _condition == nil then
					_condition = 0
				end
				local holdDuration = _exp - _condition
				local normalizedDuration = math.clamp(holdDuration / 4, 0, 1) * 100
				Signals.updateDrinkBar:Fire(normalizedDuration)
			end)
		end)
		tool.Deactivated:Connect(function()
			print("Tool Deactivated Locally")
			local _result = self.holdDurationTimer
			if _result ~= nil then
				_result:Disconnect()
			end
			Signals.updateDrinkBar:Fire(0)
			Signals.showDrinkBar:Fire(false)
			local _result_1 = animationTrack
			if _result_1 ~= nil then
				_result_1:Stop()
			end
		end)
		tool.Unequipped:Connect(function()
			print("Tool Unequipped")
			Signals.showDrinkBar:Fire(false)
			local _result = animationTrack
			if _result ~= nil then
				_result:Stop()
			end
		end)
	end
end
-- (Flamework) CanteenToolTrigger metadata
Reflect.defineMetadata(CanteenToolTrigger, "identifier", "game/src/entities/Tools/Canteen/controller/canteen-controller@CanteenToolTrigger")
Reflect.defineMetadata(CanteenToolTrigger, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(CanteenToolTrigger, "$c:init@Component", Component, { {
	tag = "CanteenToolTriggerController",
	instanceGuard = t.instanceIsA("Tool"),
	attributes = {},
} })
return {
	CanteenToolTrigger = CanteenToolTrigger,
}
