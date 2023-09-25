-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local RunService = _services.RunService
local Players = _services.Players
local Player = Players.LocalPlayer
local CustomMouse = function(props, _param)
	local useState = _param.useState
	local mouse = Player:GetMouse()
	local isVisible, setIsVisible = useState(true)
	local position, setPosition = useState(UDim2.new(0, mouse.X, 0, mouse.Y))
	local color, setColor = useState(Color3.new(1, 1, 1))
	useState(function()
		Signals.hideMouse:Connect(function()
			setIsVisible(false)
		end)
		Signals.showMouse:Connect(function()
			setIsVisible(true)
		end)
		RunService.Stepped:Connect(function()
			setPosition(UDim2.new(0, mouse.X, 0, mouse.Y))
		end)
	end)
	return Roact.createFragment({
		CustomCursorGui = Roact.createElement("ScreenGui", {
			DisplayOrder = 9999999,
		}, {
			CustomCursorIcon = Roact.createElement("ImageLabel", {
				Image = "rbxassetid://5992580992",
				Size = UDim2.new(0, 50, 0, 50),
				BackgroundTransparency = 1,
				ZIndex = 9999999,
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageColor3 = color,
				Visible = isVisible,
				Position = position,
			}),
		}),
	})
end
local default = Hooks.new(Roact)(CustomMouse)
return {
	CustomMouse = CustomMouse,
	default = default,
}
