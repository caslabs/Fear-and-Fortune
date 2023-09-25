-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
-- Tab component used for swapping tabs in pages
local Tab = function(props, _param)
	local useState = _param.useState
	return Roact.createFragment({
		Tab = Roact.createElement("TextButton", {
			Text = props.text,
			Size = UDim2.fromOffset(100, 40),
			BackgroundColor3 = if props.active then Color3.fromRGB(54, 54, 54) else Color3.fromRGB(107, 105, 105),
			BorderSizePixel = 0,
			TextSize = 24,
			ZIndex = 2,
			AutomaticSize = "X",
			Font = Enum.Font.SourceSansBold,
			[Roact.Event.MouseButton1Click] = function()
				props.onClick(props.page)
				SoundSystemController:playSound(SoundKeys.UI_CLOSE)
			end,
		}, {
			Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 6),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(Tab)
return {
	default = default,
}
