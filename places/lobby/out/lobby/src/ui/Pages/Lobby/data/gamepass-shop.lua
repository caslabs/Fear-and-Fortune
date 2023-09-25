-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local PurchaseItem = TS.import(script, script.Parent.Parent.Parent.Parent, "components", "Items", "ItemPurchase").default
local AutoScrollingFrame = TS.import(script, script.Parent.Parent.Parent.Parent, "components", "Dynamic", "ScrollingFrame").AutoScrollingFrame
local GamePasses = function(props, _param)
	local useState = _param.useState
	local _attributes = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = props.visible == "gamepasses",
	}
	local _children = {}
	local _length = #_children
	local _data = props.data
	local _arg0 = function(info)
		return Roact.createFragment({
			[info.name] = Roact.createElement(PurchaseItem, {
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
	local _attributes_1 = {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
	}
	local _children_1 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromOffset(152, 150),
		}),
	}
	local _length_1 = #_children_1
	for _k, _v in ipairs(_newValue) do
		_children_1[_length_1 + _k] = _v
	end
	_children[_length + 1] = Roact.createElement(AutoScrollingFrame, _attributes_1, _children_1)
	_children[_length + 2] = Roact.createElement("TextLabel", {
		Text = "[PLAYTEST EDITION] You can only window shop for now!",
		Size = UDim2.fromScale(0.4, 0.09),
		Position = UDim2.fromScale(0.5, 0.95),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.GothamBold,
	})
	return Roact.createFragment({
		GamepassPage = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(GamePasses)
return {
	default = default,
}
