-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Tab
do
	Tab = Roact.Component:extend("Tab")
	function Tab:init()
	end
	function Tab:calculateTextSize(text)
		local minFontSize = 14
		local maxFontSize = 24
		local scaleFactor = 10
		local fontSize = minFontSize + scaleFactor / #text
		return math.clamp(fontSize, minFontSize, maxFontSize)
	end
	function Tab:render()
		local textSize = self:calculateTextSize(self.props.text)
		return Roact.createFragment({
			Tab = Roact.createElement("TextButton", {
				Text = self.props.text,
				Size = UDim2.fromScale(1, 0.13),
				BackgroundColor3 = if self.props.active then Color3.fromRGB(60, 60, 60) else Color3.fromRGB(40, 40, 40),
				BorderSizePixel = 0,
				TextColor3 = if self.props.active then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(200, 200, 200),
				ZIndex = 2,
				Font = Enum.Font.SourceSansBold,
				TextSize = textSize,
				TextXAlignment = Enum.TextXAlignment.Center,
				[Roact.Event.MouseButton1Click] = function()
					self.props.onClick(self.props.page)
				end,
			}, {
				Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
			}),
		})
	end
end
local default = Tab
return {
	default = default,
}
