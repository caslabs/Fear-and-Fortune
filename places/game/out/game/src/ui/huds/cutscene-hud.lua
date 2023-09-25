-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Pages = TS.import(script, script.Parent.Parent, "Context").Pages
local Panel = TS.import(script, script.Parent.Parent, "Panels", "Panel").Panel
local CutsceneHUD = function(props, _param)
	local useState = _param.useState
	local barHeightRatio = 0.1
	return Roact.createElement(Panel, {
		index = Pages.cutscene,
		visible = props.visible,
	}, {
		Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, barHeightRatio, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		}),
		Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, barHeightRatio, 0),
			Position = UDim2.new(0, 0, 1 - barHeightRatio, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		}),
	})
end
local default = Hooks.new(Roact)(CutsceneHUD)
return {
	default = default,
}
