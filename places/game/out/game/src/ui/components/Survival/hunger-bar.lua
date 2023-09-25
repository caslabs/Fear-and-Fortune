-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local HungerBar = function(props, _param)
	local useState = _param.useState
	local isVisible, setIsVisible = useState(props.hunger < 50)
	useState(function()
		if props.hunger == 100 and isVisible then
			setIsVisible(false)
		elseif props.hunger < 100 and not isVisible then
			setIsVisible(true)
		end
	end)
	return Roact.createFragment({
		HungerBar = Roact.createElement("TextLabel", {
			Position = UDim2.new(0.06, 0, 0.89, 0),
			Size = UDim2.new(0.02, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Text = "",
		}, {
			Roact.createElement("TextLabel", {
				Text = "",
				Size = UDim2.new(1, 0, props.hunger / 100, 0),
				BackgroundTransparency = 0.8,
				Visible = true,
				BackgroundColor3 = Color3.fromRGB(205, 133, 63),
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, 0),
			}),
			Roact.createElement("ImageLabel", {
				Image = "rbxassetid://9432891155",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(1, 0, 0.1, 0),
				BackgroundTransparency = 1,
				ImageTransparency = 0.5,
			}),
		}),
	})
end
local default = Hooks.new(Roact)(HungerBar)
return {
	default = default,
}
