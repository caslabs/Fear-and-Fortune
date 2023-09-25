-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local IronWoodComponent
do
	local super = BaseComponent
	IronWoodComponent = setmetatable({}, {
		__tostring = function()
			return "IronWoodComponent"
		end,
		__index = super,
	})
	IronWoodComponent.__index = IronWoodComponent
	function IronWoodComponent.new(...)
		local self = setmetatable({}, IronWoodComponent)
		return self:constructor(...) or self
	end
	function IronWoodComponent:constructor(...)
		super.constructor(self, ...)
	end
	function IronWoodComponent:onStart()
		print("IronWood Object Component Initiated")
	end
end
-- (Flamework) IronWoodComponent metadata
Reflect.defineMetadata(IronWoodComponent, "identifier", "lobby/src/entities/Structures/Gate/services/player-char-service@IronWoodComponent")
Reflect.defineMetadata(IronWoodComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(IronWoodComponent, "$c:init@Component", Component, { {
	tag = "IronWoodTrigger",
	instanceGuard = t.instanceIsA("Model"),
	attributes = {},
} })
return {
	IronWoodComponent = IronWoodComponent,
}
