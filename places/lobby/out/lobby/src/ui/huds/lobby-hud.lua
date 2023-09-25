-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Pages = TS.import(script, script.Parent.Parent, "routers", "Lobby", "Context-LobbyHUD").Pages
local Panel = TS.import(script, script.Parent.Parent, "Pages", "Panels", "PanelLobby", "Panel").Panel
local Lobby = TS.import(script, script.Parent.Parent, "Pages", "Lobby").default
local LobbyHUD = function(props, _param)
	local useState = _param.useState
	return Roact.createElement(Panel, {
		index = Pages.lobby,
		visible = props.visible,
	}, {
		Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
		}),
		Roact.createElement(Lobby),
	})
end
local default = Hooks.new(Roact)(LobbyHUD)
return {
	default = default,
}
