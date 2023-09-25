-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Pages = TS.import(script, script.Parent.Parent, "Context").Pages
local Panel = TS.import(script, script.Parent.Parent, "Panels", "Panel").Panel
local InventoryItem = TS.import(script, script.Parent.Parent, "components", "inventory-component").default
local EmptyInventoryItem = TS.import(script, script.Parent.Parent, "components", "empty-inventory-component").default
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
-- TODO: is there a better way? Had to use Global as setData was not updating the data variable
local full_inventory = {}
local UpdateInventoryEvent = Remotes.Client:Get("UpdateInventory")
print("Inventory loaded")
local Inventory = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local data, setData = useState({})
	useEffect(function()
		local connection = UpdateInventoryEvent:Connect(function(player, item, action, quantity)
			print("[DEBUG] Calling UpdateInventoryEvent")
			if player == Players.LocalPlayer then
				setData(function(prevData)
					local _arg0 = function(data)
						return data.name == item
					end
					-- ▼ ReadonlyArray.findIndex ▼
					local _result = -1
					for _i, _v in ipairs(prevData) do
						if _arg0(_v, _i - 1, prevData) == true then
							_result = _i - 1
							break
						end
					end
					-- ▲ ReadonlyArray.findIndex ▲
					local existingItemIndex = _result
					local _array = {}
					local _length = #_array
					table.move(prevData, 1, #prevData, _length + 1, _array)
					local newData = _array
					if existingItemIndex >= 0 then
						local existingItem = newData[existingItemIndex + 1]
						if action == "add" then
							existingItem.quantity = quantity
						elseif action == "remove" then
							if existingItem.quantity > 1 then
								existingItem.quantity -= 1
							else
								local _newData = newData
								local _arg0_1 = function(data)
									return data.name ~= item
								end
								-- ▼ ReadonlyArray.filter ▼
								local _newValue = {}
								local _length_1 = 0
								for _k, _v in ipairs(_newData) do
									if _arg0_1(_v, _k - 1, _newData) == true then
										_length_1 += 1
										_newValue[_length_1] = _v
									end
								end
								-- ▲ ReadonlyArray.filter ▲
								newData = _newValue
							end
						end
					elseif action == "add" then
						local _newData = newData
						local _arg0_1 = {
							name = item,
							quantity = quantity,
						}
						table.insert(_newData, _arg0_1)
					end
					print("[DEBUG] New inventory data:", newData)
					return newData
				end)
			end
		end)
		return function()
			return connection:Disconnect()
		end
	end, {})
	local _attributes = {
		index = Pages.inventory,
		visible = props.visible,
	}
	local _children = {
		Roact.createElement("TextButton", {
			Modal = true,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 0),
		}),
	}
	local _length = #_children
	local _attributes_1 = {
		Size = UDim2.new(0.4, 0, 0.7, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	}
	local _children_1 = {}
	local _length_1 = #_children_1
	local _arg0 = function(item, index)
		local _value = item.name
		return if _value ~= "" and _value then (Roact.createFragment({
			[item.name] = Roact.createElement(InventoryItem, {
				name = item.name,
				quantity = item.quantity,
				LayoutOrder = index,
			}),
		})) else (Roact.createFragment({
			["Empty_" .. tostring(index)] = Roact.createElement(EmptyInventoryItem, {
				LayoutOrder = index,
			}),
		}))
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#data)
	for _k, _v in ipairs(data) do
		_newValue[_k] = _arg0(_v, _k - 1, data)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_2 = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	}
	local _children_2 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromScale(0.2, 0.1),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	local _length_2 = #_children_2
	for _k, _v in ipairs(_newValue) do
		_children_2[_length_2 + _k] = _v
	end
	_children_1[_length_1 + 1] = Roact.createElement("ScrollingFrame", _attributes_2, _children_2)
	_children_1[_length_1 + 2] = Roact.createElement("TextLabel", {
		Text = "backpack " .. (tostring(#data) .. "/10"),
		Size = UDim2.fromScale(0.4, 0.09),
		Position = UDim2.fromScale(0.5, 0.9),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.GothamBold,
	})
	_children.Inventory = Roact.createElement("Frame", _attributes_1, _children_1)
	return Roact.createFragment({
		Inventory = Roact.createElement(Panel, _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Inventory)
return {
	default = default,
}
