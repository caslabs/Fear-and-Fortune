-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local Pages = TS.import(script, script.Parent.Parent, "Context").Pages
local Panel = TS.import(script, script.Parent.Parent, "Panels", "Panel").Panel
local ButtonDefault = TS.import(script, script.Parent.Parent, "components", "Inputs", "Buttons", "ButtonDefault").default
local SpectateHUD = function(props, _param)
	local useState = _param.useState
	return Roact.createElement(Panel, {
		index = Pages.spectate,
		visible = props.visible,
	}, {
		Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
		}, {
			Roact.createElement("UIListLayout", {
				SortOrder = "LayoutOrder",
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 100),
			}),
			Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 30),
			}),
			Roact.createElement(ButtonDefault, {
				onClick = function()
					Signals.switchToPreviousPlayer:Fire()
				end,
				text = "<",
				layout = 0,
				Size = UDim2.new(0.2, 0, 0.2, 0),
			}),
			Roact.createElement("TextLabel", {
				Text = "Player1",
				Size = UDim2.new(0.1, 0, 0.1, 0),
			}),
			Roact.createElement(ButtonDefault, {
				onClick = function()
					Signals.switchToNextPlayer:Fire()
				end,
				text = ">",
				layout = 1,
				Size = UDim2.new(0.2, 0, 0.2, 0),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(SpectateHUD)
return {
	default = default,
}
