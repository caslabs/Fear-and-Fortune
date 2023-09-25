-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Player = Players.LocalPlayer
local DEFAULT_SETTING_PROFILE = {
	Audio = {
		Music = 10,
		Ambience = 10,
		Sound = 10,
	},
	Game = {
		FOV = 70,
	},
}
local SettingController
do
	SettingController = setmetatable({}, {
		__tostring = function()
			return "SettingController"
		end,
	})
	SettingController.__index = SettingController
	function SettingController.new(...)
		local self = setmetatable({}, SettingController)
		return self:constructor(...) or self
	end
	function SettingController:constructor()
	end
	function SettingController:onInit()
	end
	function SettingController:onStart()
		print("Started setting")
	end
	function SettingController:loadSettingProfile()
		print("Transitioning to spectating...")
	end
end
-- (Flamework) SettingController metadata
Reflect.defineMetadata(SettingController, "identifier", "game/src/mechanics/PlayerMechanics/SettingMechanic/controller/setting-controller@SettingController")
Reflect.defineMetadata(SettingController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(SettingController, "$:flamework@Controller", Controller, {})
return {
	default = SettingController,
}
