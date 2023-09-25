-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
-- Tab component used for swapping tabs in pages
local Tab
do
	Tab = Roact.Component:extend("Tab")
	function Tab:init(props)
	end
	function Tab:render()
		return Roact.createFragment({
			Div = Roact.createElement("TextButton", {
				Text = self.props.text,
				Size = UDim2.fromOffset(100, 40),
				BorderSizePixel = 0,
				TextSize = 24,
				Font = Enum.Font.SourceSansBold,
			}, {
				Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
			}),
		})
	end
end
return {
	Tab = Tab,
}
