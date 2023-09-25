-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local AutoTextLabel = TS.import(script, script.Parent.Parent, "TextLabel").AutoTextLabel
local Counter = function(props, _param)
	local useState = _param.useState
	return Roact.createFragment({
		Diamond = Roact.createElement("Frame", {
			Size = UDim2.fromOffset(160, 40),
			Position = UDim2.new(0.98, 0, 0.9, 1),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.9,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			ZIndex = 0,
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
			Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = "Horizontal",
				Padding = UDim.new(0, 6),
				HorizontalAlignment = "Center",
			}),
			Icon = Roact.createElement("ImageLabel", {
				Image = props.img,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				ZIndex = 0,
			}, {
				Roact.createElement("UIAspectRatioConstraint", {
					AspectRatio = 1,
				}),
			}),
			Roact.createElement(AutoTextLabel, {
				Size = UDim2.fromScale(1, 1),
				TextSize = 36,
				Font = Enum.Font.SourceSansSemibold,
				BackgroundTransparency = 1,
				Text = tostring(props.amount),
				LayoutOrder = 2,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 0,
			}),
		}),
	})
end
local default = Hooks.new(Roact)(Counter)
return {
	default = default,
}
