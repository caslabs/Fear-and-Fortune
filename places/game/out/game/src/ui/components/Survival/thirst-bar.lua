-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local ThirstBar = function(props, _param)
	local useState = _param.useState
	local isVisible, setIsVisible = useState(props.thirst < 50)
	useState(function()
		if props.thirst == 100 and isVisible then
			setIsVisible(false)
		elseif props.thirst < 100 and not isVisible then
			setIsVisible(true)
		end
	end)
	return Roact.createFragment({
		ThirstBar = Roact.createElement("TextLabel", {
			Position = UDim2.new(0.03, 0, 0.89, 0),
			Size = UDim2.new(0.02, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Text = "",
		}, {
			Roact.createElement("TextLabel", {
				Text = "",
				Size = UDim2.new(1, 0, props.thirst / 100, 0),
				BackgroundTransparency = 0.8,
				Visible = true,
				BackgroundColor3 = Color3.fromRGB(135, 206, 235),
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, 0),
			}),
			Roact.createElement("ImageLabel", {
				Image = "rbxassetid://418594604",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(1, 0, 0.1, 0),
				BackgroundTransparency = 1,
				ImageTransparency = 0.5,
			}),
		}),
	})
end
local default = Hooks.new(Roact)(ThirstBar)
return {
	default = default,
}
