-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local StarterGui = _services.StarterGui
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local SoundSystemController = TS.import(script, script.Parent.Parent, "SoundSystem", "sound-system-controller").default
local Notification = TS.import(script, game:GetService("ReplicatedStorage"), "MechanicsManager", "NotificationsManager", "notification")
local IntroScreen = TS.import(script, script.Parent.Parent.Parent, "CutsceneScreens", "Introduction", "screens", "intro-screen")
local landmarks = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "WorldBuildingSystem", "landmarks").landmarks
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
-- TODO: Experimental Gas Mask Breahting
local gasMaskBreathing = Instance.new("Sound")
gasMaskBreathing.SoundId = "rbxassetid://13868760171"
gasMaskBreathing.Volume = 0.5
gasMaskBreathing.Looped = true
gasMaskBreathing.Parent = game:GetService("SoundService")
--[[
	an event system or event bus
	that enables communication and coordination
	of higher-flow game logic
]]
local EventFlowController
do
	EventFlowController = setmetatable({}, {
		__tostring = function()
			return "EventFlowController"
		end,
	})
	EventFlowController.__index = EventFlowController
	function EventFlowController.new(...)
		local self = setmetatable({}, EventFlowController)
		return self:constructor(...) or self
	end
	function EventFlowController:constructor(hudController, cameraMechanic, dayNightCycleController)
		self.hudController = hudController
		self.cameraMechanic = cameraMechanic
		self.dayNightCycleController = dayNightCycleController
		-- Title -> Intro -> Play -> End
		self.tasks = { function(done)
			return self:startGame(done)
		end }
	end
	function EventFlowController:onStart()
		print("Event System Controller started")
		self:runNextTask()
	end
	function EventFlowController:runNextTask()
		if #self.tasks > 0 then
			local nextTask = table.remove(self.tasks, 1)
			if nextTask then
				nextTask(function()
					return self:runNextTask()
				end)
			end
		else
			print("All tasks completed")
		end
	end
	function EventFlowController:showTitleScreen(done)
		-- Hide default UIs like PlayerList
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
		Signals.switchToLobbyHUD:Fire()
		-- Check
		if PlayerGui:WaitForChild("LOADING_SCREEN") then
			print("Found Loading Screen")
			wait(1)
			PlayerGui:WaitForChild("LOADING_SCREEN"):Destroy()
		else
			print("Deleted")
		end
		PlayerGui:WaitForChild("LOADING_SCREEN"):Destroy()
		print("[EVENT] Awaiting for the player to singal title...")
		-- Wait for the signal to be fired
		Signals.finishedTitleScreen:Wait()
		SoundSystemController:stopSound(SoundKeys.SFX_SNOW_AMBIENCE)
		-- Perform action after signal has been fired
		done()
	end
	function EventFlowController:playIntroduction(done)
		-- Check
		if PlayerGui:WaitForChild("LOADING_SCREEN") then
			print("Found Loading Screen")
			wait(1)
			PlayerGui:WaitForChild("LOADING_SCREEN"):Destroy()
		else
			print("Deleted")
		end
		PlayerGui:WaitForChild("LOADING_SCREEN"):Destroy()
		-- Play the introduction cutscene
		-- When the cutscene is over, call done()
		print("[EVENT] Playing Introduction")
		print("[EVENT] Awaiting for the player to finish introduction...")
		Signals.hideMouse:Fire()
		-- TODO: temp notification popup
		local handle = Roact.mount(Roact.createFragment({
			IntroductionScene = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
			}, {
				Roact.createElement(IntroScreen, {
					description = "Journal Entry - June 1st, 1912",
				}),
			}),
		}), PlayerGui)
		Signals.finishedIntroduction:Wait()
		Roact.unmount(handle)
		done()
	end
	function EventFlowController:startGame(done)
		-- Check
		if PlayerGui:WaitForChild("LOADING_SCREEN") then
			print("Found Loading Screen")
			wait(1)
			PlayerGui:WaitForChild("LOADING_SCREEN"):Destroy()
		else
			print("Deleted")
		end
		PlayerGui:WaitForChild("LOADING_SCREEN"):Destroy()
		Signals.hideMouse:Fire()
		Signals.switchToPlayHUD:Fire()
		Signals.hideMouse:Fire()
		-- Waking Up
		SoundSystemController:playAmbienceSound(SoundKeys.SFX_SNOW_AMBIENCE)
		-- this.dayNightCycleController.startNextDay();
		-- Switch to the PlayHUD
		print("[EVENT] Playing Play Session")
		print("[EVENT] Starting Game")
		-- When the game is ready, call done()
		gasMaskBreathing:Stop()
		-- SoundSystemController.playSound(SoundKeys.SFX_AIR_GASP_LONG, 5);
		Signals.showMouse:Fire()
		wait(4.5)
		-- gasMaskBreathing.Volume = 0.2;
		-- gasMaskBreathing.Play();
		print("Signaling to landmark")
		-- Landmark Notification
		local handle = Roact.mount(Roact.createFragment({
			LandMarkNotification = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
				DisplayOrder = -999,
			}, {
				Roact.createElement(Notification, {
					title = landmarks.VILLAGE,
				}),
			}),
		}), PlayerGui)
		wait(15)
		Roact.unmount(handle)
		done()
	end
end
-- (Flamework) EventFlowController metadata
Reflect.defineMetadata(EventFlowController, "identifier", "game/src/systems/GameFlowSystem/controller/event-flow-controller@EventFlowController")
Reflect.defineMetadata(EventFlowController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/UIMechanic/controller/hud-controller@HUDController", "game/src/mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller@CameraMechanic", "game/src/systems/EnvironmentSystem/TimeSystem/DayNightSystem/controller/day-night-cycle-controller@DayNightCycleController" })
Reflect.defineMetadata(EventFlowController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(EventFlowController, "$:flamework@Controller", Controller, { {
	loadOrder = 99999,
} })
return {
	EventFlowController = EventFlowController,
}
