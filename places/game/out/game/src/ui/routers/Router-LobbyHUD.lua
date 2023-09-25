-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Context = TS.import(script, script.Parent.Parent, "Context").Context
local TitleScreen = TS.import(script, script.Parent.Parent.Parent, "CutsceneScreens", "Introduction", "screens", "title-screen").default
-- Create a context router for opening pages
local RouterLobbyHUD
do
	RouterLobbyHUD = Roact.Component:extend("RouterLobbyHUD")
	function RouterLobbyHUD:init(props)
		self:setState({
			viewIndex = 4,
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
			Roact.createElement(TitleScreen),
		})
	end
end
return {
	RouterLobbyHUD = RouterLobbyHUD,
}
