-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Theme = TS.import(script, script.Parent.Parent.Parent, "theme").default
local function calculateTextSize(text)
	local minFontSize = 10
	local maxFontSize = 14
	local scaleFactor = 10
	local fontSize = minFontSize + scaleFactor / #text
	return math.clamp(fontSize, minFontSize, maxFontSize)
end
local CraftItem = function(props, _param)
	local useState = _param.useState
	local promptVisible, setPromptVisible = useState(false)
	local _attributes = {
		Text = props.title,
		BackgroundColor3 = if props.active then Color3.fromRGB(60, 60, 60) else Color3.fromRGB(45, 45, 45),
	}
	local _condition = props.layoutOrder
	if _condition == nil then
		_condition = 1
	end
	_attributes.LayoutOrder = _condition
	_attributes[Roact.Event.MouseButton1Click] = props.onClick
	_attributes.TextSize = calculateTextSize(props.title)
	_attributes.TextColor3 = if props.active then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(200, 200, 200)
	local _children = {
		Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
		}),
	}
	local _length = #_children
	local _attributes_1 = {
		Size = UDim2.fromScale(1, 1),
	}
	local _condition_1 = props.desc
	if _condition_1 == nil then
		_condition_1 = ""
	end
	_attributes_1.Text = _condition_1
	_attributes_1.BorderSizePixel = 0
	_attributes_1.BackgroundTransparency = 1
	_attributes_1.TextColor3 = Color3.fromRGB(255, 255, 255)
	_attributes_1.Font = Theme.FontNormal
	_attributes_1.TextSize = 18
	_attributes_1.AutomaticSize = "Y"
	_attributes_1.TextWrapped = true
	_attributes_1.Visible = promptVisible
	_children.Desc = Roact.createElement("TextLabel", _attributes_1)
	return Roact.createFragment({
		Item = Roact.createElement("TextButton", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(CraftItem)
return {
	default = default,
}
