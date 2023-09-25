-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Context = TS.import(script, script.Parent, "Context-TitleHUD").Context
local TitleHUD = TS.import(script, script.Parent.Parent.Parent, "huds", "title-hud").default
-- Create a context router for opening pages
local RouterTitleHUD
do
	RouterTitleHUD = Roact.Component:extend("RouterTitleHUD")
	function RouterTitleHUD:init(props)
		self:setState({
			viewIndex = 1,
		})
	end
	function RouterTitleHUD:setPage(index)
		self:setState({
			viewIndex = index,
		})
	end
	function RouterTitleHUD:render()
		return Roact.createElement(Context.Provider, {
			value = {
				viewIndex = self.state.viewIndex,
				setPage = function(index)
					return self:setPage(index)
				end,
			},
		}, {
			Roact.createElement(TitleHUD),
		})
	end
end
return {
	RouterTitleHUD = RouterTitleHUD,
}
