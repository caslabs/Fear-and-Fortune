-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
-- Define ToolData for the Rifle
-- TODO: Prototype
local animationInstance = Instance.new("Animation")
animationInstance.AnimationId = "rbxassetid://14314972060"
local PickaxeToolTrigger
do
	local super = BaseComponent
	PickaxeToolTrigger = setmetatable({}, {
		__tostring = function()
			return "PickaxeToolTrigger"
		end,
		__index = super,
	})
	PickaxeToolTrigger.__index = PickaxeToolTrigger
	function PickaxeToolTrigger.new(...)
		local self = setmetatable({}, PickaxeToolTrigger)
		return self:constructor(...) or self
	end
	function PickaxeToolTrigger:constructor(...)
		super.constructor(self, ...)
	end
	function PickaxeToolTrigger:onStart()
		print("Pickaxe Tool Controller Component Initiated")
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
		tool.Equipped:Connect(function()
			print("Tool Equipped")
			animationTrack:Play()
		end)
		tool.Unequipped:Connect(function()
			print("Tool Unequipped")
			animationTrack:Stop()
		end)
	end
end
-- (Flamework) PickaxeToolTrigger metadata
Reflect.defineMetadata(PickaxeToolTrigger, "identifier", "game/src/entities/Tools/Pickaxe/controller/pickaxe-controller@PickaxeToolTrigger")
Reflect.defineMetadata(PickaxeToolTrigger, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(PickaxeToolTrigger, "$c:init@Component", Component, { {
	tag = "PickaxeToolTriggerController",
	instanceGuard = t.instanceIsA("Tool"),
	attributes = {},
} })
return {
	PickaxeToolTrigger = PickaxeToolTrigger,
}
