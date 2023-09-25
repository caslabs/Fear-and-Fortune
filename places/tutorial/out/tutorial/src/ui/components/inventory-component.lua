-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Theme = TS.import(script, script.Parent.Parent, "theme").default
-- InventoryItem.ts
local InventoryItem = function(props, _param)
	local useState = _param.useState
	local highlighted, setHighlighted = useState(false)
	local _condition = highlighted
	if _condition then
		local _attributes = {}
		local _condition_1 = props.desc
		if _condition_1 == nil then
			_condition_1 = ""
		end
		_attributes.Text = _condition_1
		_attributes.BackgroundTransparency = 1
		_attributes.TextColor3 = Color3.fromRGB(255, 255, 255)
		_attributes.Font = Theme.FontNormal
		_attributes.TextSize = 18
		_attributes.AutomaticSize = "Y"
		_attributes.TextWrapped = true
		_condition = (Roact.createElement("TextLabel", _attributes))
	end
	local _attributes = {
		Text = props.name,
		BackgroundColor3 = if highlighted then props.color or Color3.fromRGB(255, 255, 255) else Color3.fromRGB(107, 105, 105),
		[Roact.Event.MouseEnter] = function()
			return setHighlighted(true)
		end,
		[Roact.Event.MouseLeave] = function()
			return setHighlighted(false)
		end,
	}
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
	if _condition then
		_children[_length + 1] = _condition
	end
	return Roact.createFragment({
		[props.name] = Roact.createElement("TextButton", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(InventoryItem)
return {
	default = default,
}
