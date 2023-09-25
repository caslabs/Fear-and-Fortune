-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local EmptyInventoryItem = TS.import(script, script.Parent, "empty-inventory-component").default
local HotbarInventoryComponent = TS.import(script, script.Parent, "hotbar-inventory-component").default
local HotbarSlot = function(props)
	local handleUserInput = function()
		-- Propagate event to parent component
		local _ = props.onUserInput and props.onUserInput(props.slotNumber)
	end
	return Roact.createFragment({
		["Slot " .. tostring(props.slotNumber)] = Roact.createElement("TextButton", {
			LayoutOrder = props.LayoutOrder,
			BackgroundTransparency = 1,
			TextTransparency = 1,
			[Roact.Event.Activated] = handleUserInput,
		}, {
			["Slot Number"] = Roact.createElement("TextLabel", {
				Text = tostring(props.slotNumber),
				Position = UDim2.fromScale(0.8, 0.25),
				TextColor3 = if props.selected then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(125, 125, 125),
				ZIndex = 9999,
				TextStrokeTransparency = 1,
			}),
			if props.item then (Roact.createFragment({
				[props.item.name] = Roact.createElement(HotbarInventoryComponent, {
					name = props.item.name,
					quantity = props.item.quantity,
					LayoutOrder = props.LayoutOrder,
				}),
			})) else (Roact.createFragment({
				["Empty_" .. tostring(props.slotNumber)] = Roact.createElement(EmptyInventoryItem, {
					LayoutOrder = props.LayoutOrder,
				}),
			})),
		}),
	})
end
local default = Hooks.new(Roact)(HotbarSlot)
return {
	default = default,
}
