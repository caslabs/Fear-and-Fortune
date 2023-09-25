-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Context = TS.import(script, script.Parent.Parent, "Context").Context
local PlayHUD = TS.import(script, script.Parent.Parent, "huds", "play-hud").default
local Inventory = TS.import(script, script.Parent.Parent, "screens", "inventory").default
local Toggles = TS.import(script, script.Parent.Parent, "screens", "toggles").default
local inventoryList = TS.import(script, script.Parent.Parent, "screens", "_inventoryData").inventoryList
-- Add the new HUDs to the routerProps
local RouterPlayHUD
do
	RouterPlayHUD = Roact.Component:extend("RouterPlayHUD")
	function RouterPlayHUD:init(props)
		self:setState({
			viewIndex = 1,
		})
	end
	function RouterPlayHUD:setPage(index)
		self:setState({
			viewIndex = index,
		})
	end
	function RouterPlayHUD:render()
		local HUDComponent
		-- TODO: Create Class System then load the HUD
		local _exp = self.props.profession
		repeat
			if _exp == "Soldier" then
				HUDComponent = PlayHUD
				print("Switched to Soldier HUD")
				break
			end
			HUDComponent = PlayHUD
			print("Switched to Default HUD")
			break
		until true
		return Roact.createElement(Context.Provider, {
			value = {
				viewIndex = self.state.viewIndex,
				setPage = function(index)
					return self:setPage(index)
				end,
			},
		}, {
			Roact.createElement(HUDComponent),
			Roact.createElement(Toggles),
			Roact.createElement(Inventory, {
				data = inventoryList,
			}),
		})
	end
end
return {
	RouterPlayHUD = RouterPlayHUD,
}
