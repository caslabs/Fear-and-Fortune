-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local DayIndicator = TS.import(script, script.Parent.Parent.Parent, "ui", "screens", "day-indicator")
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local soundSystemController = TS.import(script, script.Parent.Parent, "SoundSystem", "sound-system-controller").default
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local DayNightCycleController
do
	DayNightCycleController = setmetatable({}, {
		__tostring = function()
			return "DayNightCycleController"
		end,
	})
	DayNightCycleController.__index = DayNightCycleController
	function DayNightCycleController.new(...)
		local self = setmetatable({}, DayNightCycleController)
		return self:constructor(...) or self
	end
	function DayNightCycleController:constructor(soundSystemController)
		self.soundSystemController = soundSystemController
	end
	function DayNightCycleController:onInit()
		print("DayNightCycleController initiated")
	end
	function DayNightCycleController:onStart()
		print("DayNightCycleController started")
		self:_handleInput()
	end
	function DayNightCycleController:_handleInput()
		--[[
			UserInputService.InputBegan.Connect((input) => {
			if (input.KeyCode === Enum.KeyCode.J) {
			this.startNextDay();
			}
			});
		]]
		print("[DAY CONTROLLER] Added _handleInput")
	end
	function DayNightCycleController:startNextDay()
		print("[DAY CONTROLLER] Next Day Starting")
		soundSystemController:playSound(SoundKeys.SFX_DAY_1, 10)
		local handle = Roact.mount(Roact.createFragment({
			LandMarkNotification = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
				DisplayOrder = 9999999,
			}, {
				Roact.createElement(DayIndicator, {
					title = "Day 1",
				}),
			}),
		}), PlayerGui)
		wait(8.3)
		Roact.unmount(handle)
		soundSystemController:playSound(SoundKeys.SFX_INTRO, 10)
	end
end
-- (Flamework) DayNightCycleController metadata
Reflect.defineMetadata(DayNightCycleController, "identifier", "game/src/systems/EnvironmentSystem/TimeSystem/DayNightSystem/controller/day-night-cycle-controller@DayNightCycleController")
Reflect.defineMetadata(DayNightCycleController, "flamework:parameters", { "game/src/systems/AudioSystem/SoundSystem/controller/sound-system-controller@SoundSystemController" })
Reflect.defineMetadata(DayNightCycleController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(DayNightCycleController, "$:flamework@Controller", Controller, { {} })
return {
	DayNightCycleController = DayNightCycleController,
}
