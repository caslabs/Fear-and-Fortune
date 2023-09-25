-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local CurrencyItem = function(props, _param)
	local useState = _param.useState
	return Roact.createFragment({
		CurrencyItem = Roact.createElement("TextButton", {
			Text = "+ " .. tostring(props.amount),
			Size = UDim2.fromScale(0.9, 0.1),
			BorderSizePixel = 0,
			TextSize = 24,
			Font = Enum.Font.SourceSansBold,
			[Roact.Event.MouseButton1Click] = function()
				print("Bought")
			end,
		}, {
			Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 6),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(CurrencyItem)
return {
	default = default,
}
