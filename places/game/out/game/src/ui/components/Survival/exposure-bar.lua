-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local ExposureBar = function(props, _param)
	local useState = _param.useState
	local isVisible, setIsVisible = useState(props.exposure < 50)
	useState(function()
		if props.exposure == 100 and isVisible then
			setIsVisible(false)
		elseif props.exposure < 100 and not isVisible then
			setIsVisible(true)
		end
	end)
	return Roact.createFragment({
		ExposureBar = Roact.createElement("TextLabel", {
			Position = UDim2.new(0.95, 0, 0.05, 0),
			Size = UDim2.new(0.25, 0, 0.02, 0),
			AnchorPoint = Vector2.new(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Text = "",
		}, {
			Roact.createElement("TextLabel", {
				Text = "",
				Size = UDim2.new(props.exposure / 100, 0, 1, 0),
				BackgroundTransparency = 0.8,
				Visible = true,
				BackgroundColor3 = Color3.fromRGB(173, 216, 230),
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 0.7, 0),
			}),
			Roact.createElement("ImageLabel", {
				Image = "rbxassetid://11793738396",
				AnchorPoint = Vector2.new(1, 0.4),
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0.1, 0, 2, 0),
				BackgroundTransparency = 1,
				ImageTransparency = 0.5,
			}),
		}),
	})
end
local default = Hooks.new(Roact)(ExposureBar)
return {
	default = default,
}
