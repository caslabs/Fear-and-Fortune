-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Context = TS.import(script, script.Parent.Parent, "Context").Context
local SpectateHUD = TS.import(script, script.Parent.Parent, "huds", "spectate-hud").default
-- Create a context router for opening pages
local RouterSpectateHUD
do
	RouterSpectateHUD = Roact.Component:extend("RouterSpectateHUD")
	function RouterSpectateHUD:init(props)
		self:setState({
			viewIndex = 3,
		})
	end
	function RouterSpectateHUD:setPage(index)
		self:setState({
			viewIndex = index,
		})
	end
	function RouterSpectateHUD:render()
		return Roact.createElement(Context.Provider, {
			value = {
				viewIndex = self.state.viewIndex,
				setPage = function(index)
					return self:setPage(index)
				end,
			},
		}, {
			Roact.createElement(SpectateHUD),
		})
	end
end
return {
	RouterSpectateHUD = RouterSpectateHUD,
}
