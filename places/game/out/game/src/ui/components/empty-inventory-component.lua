-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local EmptyInventoryItem = function(props)
	return Roact.createFragment({
		EmptyInventoryItem = Roact.createElement("Frame", {
			BackgroundColor3 = props.color or Color3.fromRGB(38, 33, 33),
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.fromScale(1, 1),
		}, {
			Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 6),
			}),
			Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6),
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(EmptyInventoryItem)
return {
	default = default,
}
