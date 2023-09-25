-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local GetPlayerEvent = Remotes.Server:Get("GetPlayer")
local AppearanceComponent
do
	local super = BaseComponent
	AppearanceComponent = setmetatable({}, {
		__tostring = function()
			return "AppearanceComponent"
		end,
		__index = super,
	})
	AppearanceComponent.__index = AppearanceComponent
	function AppearanceComponent.new(...)
		local self = setmetatable({}, AppearanceComponent)
		return self:constructor(...) or self
	end
	function AppearanceComponent:constructor(...)
		super.constructor(self, ...)
	end
	function AppearanceComponent:onStart()
		print("Appearance Object Component Initiated")
		-- Get the user ID of the player
		-- Get Character Appearance
		GetPlayerEvent:Connect(function(player)
			print("Player added, ID: ", player.UserId)
			-- get the player's humanoid appearance
			local humanoidDescription = Players:GetHumanoidDescriptionFromUserId(player.UserId)
			print("Humanoid description: ", humanoidDescription);
			-- Apply the humanoid description to the instance
			(self.instance:WaitForChild("Humanoid")):ApplyDescription(humanoidDescription)
			print("Humanoid description applied")
		end)
	end
end
-- (Flamework) AppearanceComponent metadata
Reflect.defineMetadata(AppearanceComponent, "identifier", "lobby/src/systems/MatchMakingSystem/services/ironwood-service@AppearanceComponent")
Reflect.defineMetadata(AppearanceComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(AppearanceComponent, "$c:init@Component", Component, { {
	tag = "AppearanceTrigger",
	instanceGuard = t.instanceIsA("Model"),
	attributes = {},
} })
return {
	AppearanceComponent = AppearanceComponent,
}
