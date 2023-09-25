-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local UserInputService = _services.UserInputService
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local CustomMouse = TS.import(script, script.Parent.Parent.Parent.Parent, "ui", "components", "custom-mouse").default
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local MouseController
do
	MouseController = setmetatable({}, {
		__tostring = function()
			return "MouseController"
		end,
	})
	MouseController.__index = MouseController
	function MouseController.new(...)
		local self = setmetatable({}, MouseController)
		return self:constructor(...) or self
	end
	function MouseController:constructor(characterController)
		self.characterController = characterController
		self.mouseIconVisiblity = true
	end
	function MouseController:onStart()
		print("MouseController started")
		-- Hide Mouse
		UserInputService.MouseIconEnabled = false
	end
	function MouseController:iniateCustomCursor()
		local mouse = Player:GetMouse()
		mouse.Icon = "rbxassetid://5992580992"
	end
	function MouseController:initiateDynamicCustomCursor()
		-- Mount Component
		local handle = Roact.mount(Roact.createFragment({
			DynamicCustomMouseIcon = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
			}, {
				Roact.createElement(CustomMouse),
			}),
		}), PlayerGui)
	end
	function MouseController:handleButton(button)
		button.MouseEnter:Connect(function()
			Signals.mouseColor:Fire(Color3.new(0.81, 0.74, 0.74))
		end)
		button.MouseLeave:Connect(function()
			Signals.mouseColor:Fire(Color3.new(1, 1, 1))
		end)
	end
	function MouseController:readButtons()
		local allGuiObjects = PlayerGui:GetDescendants()
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #allGuiObjects) then
					break
				end
				local guiObject = allGuiObjects[i + 1]
				if guiObject:IsA("GuiButton") then
					local obj = allGuiObjects[i + 1]
					if obj:IsA("GuiButton") then
						self:handleButton(obj)
					end
				end
			end
		end
	end
end
-- (Flamework) MouseController metadata
Reflect.defineMetadata(MouseController, "identifier", "lobby/src/mechanics/PlayerMechanics/UIMechanic/controller/mouse-controller@MouseController")
Reflect.defineMetadata(MouseController, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(MouseController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(MouseController, "$:flamework@Controller", Controller, { {
	loadOrder = 5,
} })
return {
	MouseController = MouseController,
}
