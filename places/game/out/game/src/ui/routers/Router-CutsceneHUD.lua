-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Context = TS.import(script, script.Parent.Parent, "Context").Context
local CutsceneHUD = TS.import(script, script.Parent.Parent, "huds", "cutscene-hud").default
-- Create a context router for opening pages
local RouterCutsceneHUD
do
	RouterCutsceneHUD = Roact.Component:extend("RouterCutsceneHUD")
	function RouterCutsceneHUD:init(props)
		self:setState({
			viewIndex = 2,
		})
	end
	function RouterCutsceneHUD:setPage(index)
		self:setState({
			viewIndex = index,
		})
	end
	function RouterCutsceneHUD:render()
		return Roact.createElement(Context.Provider, {
			value = {
				viewIndex = self.state.viewIndex,
				setPage = function(index)
					return self:setPage(index)
				end,
			},
		}, {
			Roact.createElement(CutsceneHUD),
		})
	end
end
return {
	RouterCutsceneHUD = RouterCutsceneHUD,
}
