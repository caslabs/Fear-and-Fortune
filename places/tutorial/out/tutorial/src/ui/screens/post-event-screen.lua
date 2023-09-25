-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local _Context = TS.import(script, script.Parent.Parent, "Context")
local Context = _Context.Context
local Pages = _Context.Pages
local Panel = TS.import(script, script.Parent.Parent, "Panels", "Panel").Panel
-- Post Event Screen
local PostEventScreen = function(props, _param)
	local useState = _param.useState
	local barHeightRatio = 0.1
	print("Initiated Post Event Screen")
	return Roact.createElement(Context.Consumer, {
		render = function(value)
			return Roact.createElement(Panel, {
				index = Pages.titleScreen,
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
				}, {
					Roact.createElement("TextButton", {
						Text = "You Lost!",
						Size = UDim2.new(0.2, 0, 1, 0),
						Position = UDim2.new(0.4, 0, -1.5, 0),
						[Roact.Event.MouseButton1Click] = function()
							value.setPage(Pages.play)
						end,
					}),
				}),
			})
		end,
	})
end
local default = Hooks.new(Roact)(PostEventScreen)
return {
	default = default,
}
