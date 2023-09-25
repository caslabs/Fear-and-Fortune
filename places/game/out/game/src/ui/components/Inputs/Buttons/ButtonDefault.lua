-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "theme").default
-- A generic Default Button
local DefaultButton = function(props, _param)
	local useState = _param.useState
	return Roact.createFragment({
		Button = Roact.createElement("TextButton", {
			Text = props.text,
			FontSize = Enum.FontSize.Size24,
			Font = Theme.FontPrimary,
			Size = props.Size or UDim2.new(0.5, 0, 0.2, 0),
			Position = UDim2.new(0.25, 0, 0.7, 0),
			BorderSizePixel = 0,
			LayoutOrder = props.layout,
			[Roact.Event.MouseButton1Click] = function()
				return props.onClick()
			end,
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
local default = Hooks.new(Roact)(DefaultButton)
return {
	default = default,
}
