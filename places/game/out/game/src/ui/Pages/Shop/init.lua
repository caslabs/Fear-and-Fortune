-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Pages = TS.import(script, script.Parent.Parent, "Context").Pages
local CloseShop = TS.import(script, script.Parent.Parent, "Panels", "Close-Shop").default
local Gamepasses = TS.import(script, script, "gamepass-shop").default
local _shop_manager = TS.import(script, script, "shop-manager")
local setCurrentTab = _shop_manager.setCurrentTab
local getCurrentTab = _shop_manager.getCurrentTab
local getPageVisible = _shop_manager.getPageVisible
local setPageVisibleGlob = _shop_manager.setPageVisibleGlob
local ItemsList = TS.import(script, script, "data", "items-list").ItemsList
local GamepassesList = TS.import(script, script, "data", "gamepasses-list").GamepassesList
local Panel = TS.import(script, script.Parent.Parent, "Panels", "Panel").Panel
local Tab = TS.import(script, script.Parent.Parent, "Panels", "Tab").default
local Inventory = TS.import(script, script, "inventory").default
local Shop = function(props, _param)
	local useState = _param.useState
	local tabChosen, setTabChosen = useState(getCurrentTab())
	local pageVisible, setPageVisible = useState(getPageVisible())
	return Roact.createFragment({
		Shop = Roact.createElement(Panel, {
			index = Pages.merchant,
			visible = props.visible,
		}, {
			Roact.createElement("UIListLayout", {
				FillDirection = "Horizontal",
				HorizontalAlignment = "Center",
				SortOrder = "LayoutOrder",
				VerticalAlignment = "Center",
			}),
			Shop = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(504, 360),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(70, 70, 70),
			}, {
				Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
				Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
				}),
				Roact.createElement(CloseShop),
				Tabs = Roact.createElement("Frame", {
					Size = UDim2.new(1, -46, 0, 40),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
				}, {
					Roact.createElement("UIListLayout", {
						FillDirection = "Horizontal",
						Padding = UDim.new(0, 6),
					}),
					Roact.createElement(Tab, {
						text = "Inventory",
						page = "inventory",
						active = "inventory" == tabChosen,
						onClick = function(page)
							setTabChosen("Inventory")
							setCurrentTab("Inventory")
							setPageVisible(page)
							setPageVisibleGlob(page)
						end,
					}),
					Roact.createElement(Tab, {
						text = "Gamepass",
						page = "gamepasses",
						active = "Gamepass" == tabChosen,
						onClick = function(page)
							setTabChosen("Gamepass")
							setCurrentTab("Gamepass")
							setPageVisible(page)
							setPageVisibleGlob(page)
						end,
					}),
				}),
				Roact.createElement(Inventory, {
					visible = pageVisible,
					data = ItemsList,
				}),
				Roact.createElement(Gamepasses, {
					visible = pageVisible,
					data = GamepassesList,
				}),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(Shop)
return {
	default = default,
}
