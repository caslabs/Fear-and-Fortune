-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local _Context = TS.import(script, script.Parent.Parent, "Context")
local Context = _Context.Context
local Pages = _Context.Pages
local PlayHUD = TS.import(script, script.Parent.Parent, "huds", "play-hud").default
local Inventory = TS.import(script, script.Parent.Parent, "screens", "inventory").default
local Toggles = TS.import(script, script.Parent.Parent, "screens", "toggles").default
local inventoryList = TS.import(script, script.Parent.Parent, "screens", "_inventoryData").inventoryList
local Craft = TS.import(script, script.Parent.Parent, "screens", "craft").default
local CraftingList = TS.import(script, script.Parent.Parent, "screens", "crafting-list").CraftingList
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local Hotbar = TS.import(script, script.Parent.Parent, "screens", "hotbar").default
local PartyMembers = TS.import(script, script.Parent.Parent, "components", "Party", "members").default
local Setting = TS.import(script, script.Parent.Parent, "screens", "setting").default
-- TODO: Add the new HUDs to the routerProps
local RouterPlayHUD
do
	RouterPlayHUD = Roact.Component:extend("RouterPlayHUD")
	function RouterPlayHUD:init(props)
		self:setState({
			viewIndex = 1,
		})
		Signals.OpenCraft:Connect(function()
			self:setPage(Pages.craft)
			print("[CRAFT] Opening CraftingTable")
		end)
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
			Roact.createElement(PlayHUD),
			Roact.createElement(Toggles),
			Roact.createElement(Inventory, {
				data = inventoryList,
			}),
			Roact.createElement(Setting),
			Roact.createElement(Hotbar, {
				data = {},
			}),
			Roact.createElement(Craft, {
				data = CraftingList,
			}),
			Roact.createElement(PartyMembers, {
				memberCount = 1,
			}),
		})
	end
end
return {
	RouterPlayHUD = RouterPlayHUD,
}
