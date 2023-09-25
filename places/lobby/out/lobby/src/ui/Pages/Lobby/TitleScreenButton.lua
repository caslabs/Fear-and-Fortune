-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
-- Title Screen Button
local TitleScreenButton = function(props, _param)
	local useState = _param.useState
	local buttonText, setButtonText = useState("Invite Friends")
	return Roact.createFragment({
		TitleScreenButton = Roact.createElement("Frame", {
			Size = UDim2.fromScale(0.1, 0.045),
			Position = UDim2.new(0.8, 0, 0.011, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 1,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		}, {
			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = "Vertical",
				VerticalAlignment = "Top",
				SortOrder = "LayoutOrder",
			}),
			Button = Roact.createElement("TextButton", {
				Text = "View Title Screen",
				FontSize = Enum.FontSize.Size8,
				TextSize = 8,
				Size = UDim2.fromScale(1, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				ZIndex = 5,
				BackgroundTransparency = 0.5,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				[Roact.Event.MouseButton1Click] = function() end,
			}, {
				Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
				Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 6),
					PaddingBottom = UDim.new(0, 6),
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
				}),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(TitleScreenButton)
return {
	default = default,
}
