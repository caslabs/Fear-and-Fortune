-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Section = function(props, _param)
	local useState = _param.useState
	local _attributes = {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 1.2),
		BackgroundTransparency = 1,
	}
	local _children = {
		Roact.createElement("UIListLayout", {
			VerticalAlignment = "Top",
			FillDirection = "Vertical",
			HorizontalAlignment = "Center",
			SortOrder = "LayoutOrder",
		}),
		Roact.createElement("TextLabel", {
			TextSize = 36,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.2, 0.2),
			Text = props.title,
			LayoutOrder = 1,
		}),
		Roact.createElement("TextLabel", {
			TextSize = 12,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.2, 0.1),
			Text = props.description,
			LayoutOrder = 2,
			TextYAlignment = "Top",
		}),
	}
	local _length = #_children
	local _child = props[Roact.Children]
	if _child then
		for _k, _v in pairs(_child) do
			if type(_k) == "number" then
				_children[_length + _k] = _v
			else
				_children[_k] = _v
			end
		end
	end
	return Roact.createFragment({
		Section = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Section)
return {
	default = default,
}
