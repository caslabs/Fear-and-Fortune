-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Context = TS.import(script, script.Parent.Parent, "Context").Context
local Shop = TS.import(script, script.Parent.Parent, "Pages", "Shop").default
-- TODO: Make this component a functional hook. Blocker: setPage on routerState
-- Create a context router for opening pages
local RouterMerchantHUD
do
	RouterMerchantHUD = Roact.Component:extend("RouterMerchantHUD")
	function RouterMerchantHUD:init(props)
		self:setState({
			viewIndex = 5,
		})
	end
	function RouterMerchantHUD:setPage(index)
		self:setState({
			viewIndex = index,
		})
	end
	function RouterMerchantHUD:render()
		return Roact.createElement(Context.Provider, {
			value = {
				viewIndex = self.state.viewIndex,
				setPage = function(index)
					return self:setPage(index)
				end,
			},
		}, {
			Roact.createElement(Shop),
		})
	end
end
return {
	RouterMerchantHUD = RouterMerchantHUD,
}
