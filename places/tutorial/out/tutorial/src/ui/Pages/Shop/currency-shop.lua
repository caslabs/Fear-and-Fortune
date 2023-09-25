-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local CurrencyItem = TS.import(script, script.Parent, "currency-item").default
-- Currency Shop that lists all currency products
local CurrencyShop = function(props, _param)
	local useState = _param.useState
	return Roact.createFragment({
		CurrencyShop = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(70, 70, 70),
			Size = UDim2.fromOffset(200, 360),
		}, {
			Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 10),
				HorizontalAlignment = "Center",
			}),
			Roact.createElement("TextLabel", {
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 0, 50),
				BackgroundTransparency = 1,
				Text = "Currency Shop",
				TextSize = 20,
			}),
			Roact.createElement(CurrencyItem, {
				amount = 100,
			}),
			Roact.createElement(CurrencyItem, {
				amount = 500,
			}),
			Roact.createElement(CurrencyItem, {
				amount = 1000,
			}),
			Roact.createElement(CurrencyItem, {
				amount = 5000,
			}),
		}),
	})
end
local default = Hooks.new(Roact)(CurrencyShop)
return {
	default = default,
}
