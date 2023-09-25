-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local StarterGui = TS.import(script, TS.getModule(script, "@rbxts", "services")).StarterGui
local Toggle = TS.import(script, script.Parent.Parent, "components", "toggles").default
local ContextActionService = TS.import(script, TS.getModule(script, "@rbxts", "services")).ContextActionService
local _Context = TS.import(script, script.Parent.Parent, "Context")
local Context = _Context.Context
local Pages = _Context.Pages
local startInventoryState = Enum.UserInputState.Begin
local startSettingState = Enum.UserInputState.Begin
local startCraftingState = Enum.UserInputState.Begin
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
-- Toggles Between PlayHUD and Inventory
local Toggles = function(props, _param)
	local useState = _param.useState
	ContextActionService:UnbindAction("RbxPlayerListToggle")
	return Roact.createElement(Context.Consumer, {
		render = function(value)
			local handleInventoryInput
			ContextActionService:BindAction("OpenInventory", function(_, s)
				return handleInventoryInput(s)
			end, true, Enum.KeyCode.Tab)
			local handleSettingInput
			ContextActionService:BindAction("OpenSetting", function(_, s)
				return handleSettingInput(s)
			end, true, Enum.KeyCode.Z)
			-- TODO: optimize this later
			function handleInventoryInput(state)
				if state == startInventoryState then
					local index = Pages.inventory
					if value.viewIndex == index then
						value.setPage(Pages.play)
					else
						value.setPage(index)
					end
				end
			end
			function handleSettingInput(state)
				if state == startSettingState then
					local index = Pages.setting
					if value.viewIndex == index then
						value.setPage(Pages.play)
					else
						value.setPage(index)
					end
				end
			end
			return Roact.createFragment({
				InventoryToggle = Roact.createElement("Frame", {
					Size = UDim2.fromOffset(150, 35),
					Position = UDim2.new(0, 250, 0, 2),
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
				}, {
					Roact.createElement("UIListLayout", {
						SortOrder = "LayoutOrder",
						FillDirection = "Horizontal",
						HorizontalAlignment = "Left",
						Padding = UDim.new(0, 10),
					}),
					InventoryToggleComponent = Roact.createElement(Toggle, {
						onClick = function()
							local index = Pages.inventory
							if value.viewIndex == index then
								value.setPage(1)
							else
								value.setPage(index)
							end
						end,
						text = "[Tab] Inventory",
						caption = "[Tab] Inventory",
						layout = 1,
					}),
					SettingToggleComponent = Roact.createElement(Toggle, {
						onClick = function()
							local index = Pages.setting
							if value.viewIndex == index then
								value.setPage(1)
							else
								value.setPage(index)
							end
						end,
						text = "[Z] Setting",
						caption = "[Z] Setting",
						layout = 1,
					}),
				}),
			})
		end,
	})
end
local default = Hooks.new(Roact)(Toggles)
return {
	default = default,
}
