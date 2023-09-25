-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Counter = TS.import(script, script, "counter").default
-- Currency Component
local Currency = function(props, _param)
	local useState = _param.useState
	local coinCurrency, setCoinCurrency = useState(0)
	local diamondCurrency, setDiamondCurrency = useState(0)
	return Roact.createFragment({
		Currency = Roact.createElement("Frame", {
			Size = UDim2.fromOffset(160, 40),
			Position = UDim2.new(0.99, 0, 0.9, 1),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			ZIndex = 0,
		}, {
			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 5),
				FillDirection = "Vertical",
				VerticalAlignment = "Center",
				SortOrder = "LayoutOrder",
			}),
			Roact.createElement(Counter, {
				img = "http://www.roblox.com/asset/?id=4743559705",
				amount = coinCurrency,
			}),
			Roact.createElement(Counter, {
				img = "http://www.roblox.com/asset/?id=3073836306",
				amount = diamondCurrency,
			}),
		}),
	})
end
local default = Hooks.new(Roact)(Currency)
return {
	default = default,
}
