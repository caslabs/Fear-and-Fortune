-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local VerticalFeature = function(props, _param)
	local useState = _param.useState
	local _attributes = {}
	local _condition = props.fontsize
	if _condition == nil then
		_condition = 15
	end
	_attributes.TextSize = _condition
	_attributes.TextColor3 = Color3.fromRGB(255, 255, 255)
	_attributes.BackgroundTransparency = 1
	_attributes.Size = UDim2.fromScale(0.2, 0.2)
	_attributes.Text = props.title
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.TextYAlignment = Enum.TextYAlignment.Top
	return Roact.createElement("TextLabel", _attributes)
end
local default = Hooks.new(Roact)(VerticalFeature)
return {
	default = default,
}
