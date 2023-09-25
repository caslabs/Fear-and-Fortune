-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local RouterPlayHUD = TS.import(script, script.Parent.Parent.Parent.Parent, "ui", "routers", "Router-PlayHUD").RouterPlayHUD
local RouterSpectateHUD = TS.import(script, script.Parent.Parent.Parent.Parent, "ui", "routers", "Router-SpectateHUD").RouterSpectateHUD
local RouterCutsceneHUD = TS.import(script, script.Parent.Parent.Parent.Parent, "ui", "routers", "Router-CutsceneHUD").RouterCutsceneHUD
local RouterLobbyHUD = TS.import(script, script.Parent.Parent.Parent.Parent, "ui", "routers", "Router-LobbyHUD").RouterLobbyHUD
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local RouterMerchantHUD = TS.import(script, script.Parent.Parent.Parent.Parent, "ui", "routers", "Router-MerchantHUD").RouterMerchantHUD
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
		Signals.switchToPlayHUD:Connect(function()
			print("switching to Play HUD under HUDController")
			self:switchToPlayHUD()
		end)
		Signals.switchToCutsceneHUD:Connect(function()
			print("switching to Cutscene HUD under HUDController")
			self:switchToCutsceneHUD()
		end)
		Signals.switchToLobbyHUD:Connect(function()
			self.cameraMechanic:enableTitleCamera()
			self.handle = self:mountComponent(Roact.createElement(RouterLobbyHUD))
		end)
		Signals.switchToShopHUD:Connect(function()
			self.cameraMechanic:enableShopCamera()
			self:switchToMerchantHUD()
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
		self.handle = self:mountComponent(Roact.createElement(RouterLobbyHUD))
	end
	function HUDController:switchToPlayHUD()
		if not self.isMountedDynamicMosue then
			self.mouseController:initiateDynamicCustomCursor()
			self.isMountedDynamicMosue = true
		end
		-- Initalize it for the first time
		self.cameraMechanic:enableFirstPerson()
		self.cameraMechanic:enableHeadBobbing()
		self.cameraMechanic:enableCameraSway()
		-- Then initalize for every character death - this is due
		-- to the behavior of our initating playHUD.
		self.characterController.onCharacterAdded:Connect(function()
			self.cameraMechanic:enableFirstPerson()
			self.cameraMechanic:enableHeadBobbing()
			print("Initialize camera effect upon death")
		end)
		--[[
			since, this is the first, we don't need to check if theres any handles
			if (this.handle) {
			Roact.unmount(this.handle);
			this.handle = this.mountComponent(<RouterPlayHUD profession="Medic" />);
			}
		]]
		self.handle = self:mountComponent(Roact.createElement(RouterPlayHUD, {
			profession = "Medic",
		}))
	end
	function HUDController:switchtoPlayHUDMID()
		if not self.isMountedDynamicMosue then
			self.mouseController:initiateDynamicCustomCursor()
			self.isMountedDynamicMosue = true
		end
		-- Initalize it for the first time
		self.cameraMechanic:enableFirstPerson()
		self.cameraMechanic:enableHeadBobbing()
		self.cameraMechanic:enableCameraSway()
		-- Then initalize for every character death - this is due
		-- to the behavior of our initating playHUD.
		self.characterController.onCharacterAdded:Connect(function()
			self.cameraMechanic:enableFirstPerson()
			self.cameraMechanic:enableHeadBobbing()
			print("Initialize camera effect upon death")
		end)
		--[[
			since, this is the first, we don't need to check if theres any handles
			if (this.handle) {
			Roact.unmount(this.handle);
			this.handle = this.mountComponent(<RouterPlayHUD profession="Medic" />);
			}
		]]
		self.handle = self:mountComponent(Roact.createElement(RouterPlayHUD, {
			profession = "Medic",
		}))
		print("Switched to Play HUD Enabled")
	end
	function HUDController:switchToSpectateHUD()
		self.cameraMechanic:enableSpectateCamera()
		print("switching to Spectate HUD")
		if self.handle then
			Roact.unmount(self.handle)
			self.handle = self:mountComponent(Roact.createElement(RouterSpectateHUD))
		end
	end
	function HUDController:switchToCutsceneHUD()
		print("switching to Cutscene HUD")
		if self.handle then
			Roact.unmount(self.handle)
			self.handle = self:mountComponent(Roact.createElement(RouterCutsceneHUD))
		end
	end
	function HUDController:switchToMerchantHUD()
		print("switching to Merchant HUD")
		if self.handle then
			Roact.unmount(self.handle)
			self.handle = self:mountComponent(Roact.createElement(RouterMerchantHUD))
		end
	end
end
-- (Flamework) HUDController metadata
Reflect.defineMetadata(HUDController, "identifier", "game/src/mechanics/PlayerMechanics/UIMechanic/controller/hud-controller@HUDController")
Reflect.defineMetadata(HUDController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller@CameraMechanic", "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic", "game/src/mechanics/PlayerMechanics/UIMechanic/controller/mouse-controller@MouseController" })
Reflect.defineMetadata(HUDController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(HUDController, "$:flamework@Controller", Controller, { {
	loadOrder = 2,
} })
return {
	HUDController = HUDController,
}
