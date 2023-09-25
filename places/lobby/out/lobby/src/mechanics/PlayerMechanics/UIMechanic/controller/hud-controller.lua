-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local RouterLobbyHUD = TS.import(script, script.Parent.Parent.Parent.Parent, "ui", "routers", "Lobby", "Router-LobbyHUD").RouterLobbyHUD
local RouterTitleHUD = TS.import(script, script.Parent.Parent.Parent.Parent, "ui", "routers", "Title", "Router-TitleHUD").RouterTitleHUD
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local HUDController
do
	HUDController = setmetatable({}, {
		__tostring = function()
			return "HUDController"
		end,
	})
	HUDController.__index = HUDController
	function HUDController.new(...)
		local self = setmetatable({}, HUDController)
		return self:constructor(...) or self
	end
	function HUDController:constructor(cameraMechanic, characterController, mouseController)
		self.cameraMechanic = cameraMechanic
		self.characterController = characterController
		self.mouseController = mouseController
		self.isMountedDynamicMosue = false
	end
	function HUDController:onStart()
		print("HUDController started")
		Signals.switchToLobbyHUD:Connect(function()
			self.cameraMechanic:enableLobbyCamera()
			self:switchToLobbyHUD()
		end)
		Signals.switchToTitleHUD:Connect(function()
			self.cameraMechanic:enableTitleCamera()
			self:switchToTitleHUD()
			print("Signaled...")
		end)
	end
	function HUDController:mountComponent(component)
		return Roact.mount(Roact.createFragment({
			HUD = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
			}, {
				component,
			}),
		}), PlayerGui)
	end
	function HUDController:switchToTitleHUD()
		self.handle = self:mountComponent(Roact.createElement(RouterTitleHUD))
		print("switching to Title HUD under HUDController")
	end
	function HUDController:switchToLobbyHUD()
		if not self.isMountedDynamicMosue then
			self.mouseController:initiateDynamicCustomCursor()
			self.isMountedDynamicMosue = true
		end
		self.handle = self:mountComponent(Roact.createElement(RouterLobbyHUD))
		--[[
			if (this.handle) {
			Roact.unmount(this.handle);
			this.handle = this.mountComponent(<RouterLobbyHUD />);
			}
		]]
	end
end
-- (Flamework) HUDController metadata
Reflect.defineMetadata(HUDController, "identifier", "lobby/src/mechanics/PlayerMechanics/UIMechanic/controller/hud-controller@HUDController")
Reflect.defineMetadata(HUDController, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller@CameraMechanic", "lobby/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic", "lobby/src/mechanics/PlayerMechanics/UIMechanic/controller/mouse-controller@MouseController" })
Reflect.defineMetadata(HUDController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(HUDController, "$:flamework@Controller", Controller, { {
	loadOrder = 0,
} })
return {
	HUDController = HUDController,
}
