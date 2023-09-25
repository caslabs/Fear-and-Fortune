-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local DropItemFromInventoryEvent = Remotes.Client:Get("DropItemFromInventory")
local EquipItemFromInventoryEvent = Remotes.Client:Get("EquipItemFromInventory")
local ContextHotbarMenu = function(props)
	local _attributes = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}
	local _children = {}
	local _length = #_children
	local _child = props.visible and (Roact.createFragment({
		ContextHotbarMenu = Roact.createElement("Frame", {
			Size = UDim2.new(0, 150, 0, 100),
			Position = props.position,
			BackgroundColor3 = Color3.fromRGB(60, 60, 60),
			ZIndex = 10,
		}, {
			Drop = Roact.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0.5, 0),
				BackgroundColor3 = Color3.fromRGB(60, 60, 60),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Text = "Drop",
				ZIndex = 11,
				[Roact.Event.MouseButton1Click] = function()
					print("Drop")
					Signals.DropTool:Fire(props.item)
					props.onClose()
				end,
			}),
		}),
	}))
	if _child then
		_children[_length + 1] = _child
	end
	return Roact.createElement("Frame", _attributes, _children)
end
local default = Hooks.new(Roact)(ContextHotbarMenu)
return {
	default = default,
}
