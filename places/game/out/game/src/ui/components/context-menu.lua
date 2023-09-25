-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local DropItemFromInventoryEvent = Remotes.Client:Get("DropItemFromInventory")
local EquipItemFromInventoryEvent = Remotes.Client:Get("EquipItemFromInventory")
local ContextMenu = function(props)
	local _attributes = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}
	local _children = {}
	local _length = #_children
	local _child = props.visible and (Roact.createFragment({
		ContextMenu = Roact.createElement("Frame", {
			Size = UDim2.new(0, 150, 0, 100),
			Position = props.position,
			BackgroundColor3 = Color3.fromRGB(60, 60, 60),
			ZIndex = 10,
		}, {
			Equip = Roact.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0.5, 0),
				BackgroundColor3 = Color3.fromRGB(60, 60, 60),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Text = "Equip",
				ZIndex = 11,
				[Roact.Event.MouseButton1Click] = function()
					print("Equipped")
					EquipItemFromInventoryEvent:SendToServer(props.item)
					props.onClose()
				end,
			}),
			Drop = Roact.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0.5, 0),
				Position = UDim2.new(0, 0, 0.5, 0),
				BackgroundColor3 = Color3.fromRGB(60, 60, 60),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Text = "Drop",
				ZIndex = 11,
				[Roact.Event.MouseButton1Click] = function()
					print("Dropped")
					DropItemFromInventoryEvent:SendToServer(props.item)
					-- Delete itself
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
local default = Hooks.new(Roact)(ContextMenu)
return {
	default = default,
}
