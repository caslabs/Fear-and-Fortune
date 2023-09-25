-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local ItemPurchase = TS.import(script, script.Parent.Parent.Parent, "components", "Items", "ItemPurchase").default
-- Pet Shop Tab
local Pets = function(props, _param)
	local useState = _param.useState
	local _data = props.data
	local _arg0 = function(info)
		return Roact.createFragment({
			[info.name] = Roact.createElement(ItemPurchase, {
				title = info.name,
				desc = info.desc,
				color = info.color,
			}),
		})
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_data)
	for _k, _v in ipairs(_data) do
		_newValue[_k] = _arg0(_v, _k - 1, _data)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes = {
		Size = UDim2.new(1, 0, 1, -46),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = props.visible == "pets",
	}
	local _children = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromOffset(156, 142),
		}),
	}
	local _length = #_children
	for _k, _v in ipairs(_newValue) do
		_children[_length + _k] = _v
	end
	return Roact.createFragment({
		MoneyPage = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Pets)
return {
	default = default,
}
