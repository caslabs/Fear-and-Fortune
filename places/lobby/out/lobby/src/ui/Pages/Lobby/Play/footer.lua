-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Footer = function(props, _param)
	local useState = _param.useState
	return Roact.createElement("TextLabel", {
		TextSize = 9,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0.2, 0.2),
		Text = props.title,
		LayoutOrder = props.LayoutOrder,
		TextYAlignment = "Bottom",
	})
end
local default = Hooks.new(Roact)(Footer)
return {
	default = default,
}
