-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local MusicSystemController = TS.import(script, script.Parent.Parent.Parent.Parent, "SystemsController", "MusicSystem", "music-controller").default
local MusicKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "MusicSystem", "MusicData").MusicKeys
local DeathScreen = TS.import(script, script.Parent.Parent.Parent.Parent, "CutsceneScreens", "Introduction", "screens", "death-screen")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local PlayerDeathEvent = Remotes.Client:Get("PlayerDeathEvent")
local DeathMechanic
do
	DeathMechanic = setmetatable({}, {
		__tostring = function()
			return "DeathMechanic"
		end,
	})
	DeathMechanic.__index = DeathMechanic
	function DeathMechanic.new(...)
		local self = setmetatable({}, DeathMechanic)
		return self:constructor(...) or self
	end
	function DeathMechanic:constructor(musicController)
		self.musicController = musicController
		self.deathScreenShown = false
	end
	function DeathMechanic:onInit()
	end
	function DeathMechanic:onStart()
		print("DeathMechanic Controller started")
		PlayerDeathEvent:Connect(function(player, message, hint)
			print("PlayerDeathEvent", player, message, hint)
			if not self.deathScreenShown then
				self:showDeathScreen(message, hint)
			end
		end)
	end
	function DeathMechanic:showDeathScreen(message, hint)
		wait(2)
		Signals.hideMouse:Fire()
		MusicSystemController:playMusic(MusicKeys.DEATH_MUSIC)
		-- Show only once
		if not self.deathScreenShown then
			self.handle = Roact.mount(Roact.createFragment({
				DeathNotification = Roact.createElement("ScreenGui", {
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
				}, {
					Roact.createElement(DeathScreen, {
						description = message,
						hint = hint,
					}),
				}),
			}), PlayerGui)
			self.deathScreenShown = true
		end
		wait(7)
		if self.handle then
			Roact.unmount(self.handle)
			self.handle = nil
		end
		Signals.PlayerDied:Fire()
		Signals.showMouse:Fire()
		self.deathScreenShown = false
	end
end
-- (Flamework) DeathMechanic metadata
Reflect.defineMetadata(DeathMechanic, "identifier", "game/src/mechanics/PlayerMechanics/DeathMechanic/controller/death-controller@DeathMechanic")
Reflect.defineMetadata(DeathMechanic, "flamework:parameters", { "game/src/systems/AudioSystem/MusicSystem/controller/music-controller@MusicSystemController" })
Reflect.defineMetadata(DeathMechanic, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(DeathMechanic, "$:flamework@Controller", Controller, {})
return {
	default = DeathMechanic,
}
