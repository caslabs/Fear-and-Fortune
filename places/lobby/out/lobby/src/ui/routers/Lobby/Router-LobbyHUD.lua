-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local LobbyHUD = TS.import(script, script.Parent.Parent.Parent, "huds", "lobby-hud").default
local TwitterHUD = TS.import(script, script.Parent.Parent.Parent, "huds", "twitter-hud").default
local TutorialHUD = TS.import(script, script.Parent.Parent.Parent, "huds", "tutorial-hud").default
local Context = TS.import(script, script.Parent, "Context-LobbyHUD").Context
-- Create a context router for opening pages
local RouterLobbyHUD
do
	RouterLobbyHUD = Roact.Component:extend("RouterLobbyHUD")
	function RouterLobbyHUD:init(props)
		self:setState({
			viewIndex = 1,
		})
	end
	function RouterLobbyHUD:setPage(index)
		self:setState({
			viewIndex = index,
		})
	end
	function RouterLobbyHUD:render()
		return Roact.createElement(Context.Provider, {
			value = {
				viewIndex = self.state.viewIndex,
				setPage = function(index)
					return self:setPage(index)
				end,
			},
		}, {
			Roact.createElement(LobbyHUD),
			Roact.createElement(TwitterHUD),
			Roact.createElement(TutorialHUD),
		})
	end
end
return {
	RouterLobbyHUD = RouterLobbyHUD,
}
