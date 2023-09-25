-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local InventoryItem = TS.import(script, script.Parent, "inventory-component").default
local EmptyInventoryItem = TS.import(script, script.Parent, "empty-inventory-component").default
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local itemDesc = TS.import(script, script.Parent, "description").itemDesc
local UpdateInventoryEvent = Remotes.Client:Get("UpdateInventory")
local emptyInventoryItem = {
	name = "",
	quantity = 0,
	desc = "",
}
local function sortInventory(a, b)
	if a.name == "" and b.name ~= "" then
		return false
	elseif a.name ~= "" and b.name == "" then
		return true
	else
		-- If you need secondary sorting conditions, you can add them here
		return false
	end
end
local function returnDesc(itemName)
	return itemDesc[itemName]
end
-- TODO: is there a better way? Had to use Global as setData was not updating the data variable
local full_inventory = {}
local Inventory = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local data, setData = useState({})
	local backpackData, setBackpackData = useState({})
	local selectedTab, setSelectedTab = useState("inventory")
	local selectedItem, setSelectedItem = useState("")
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
					local newData = full_inventory
					if existingItemIndex >= 0 then
						local existingItem = newData[existingItemIndex + 1]
						if action == "add" then
							existingItem.quantity += quantity
						elseif action == "remove" then
							if existingItem.quantity > 1 then
								print(existingItem.quantity)
								existingItem.quantity += quantity
							else
								local _newData = newData
								local _arg0_1 = function(data)
									return data.name ~= item
								end
								-- ▼ ReadonlyArray.filter ▼
								local _newValue = {}
								local _length = 0
								for _k, _v in ipairs(_newData) do
									if _arg0_1(_v, _k - 1, _newData) == true then
										_length += 1
										_newValue[_length] = _v
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
							desc = "",
						}
						table.insert(_newData, _arg0_1)
					end
					print("[DEBUG-INVENTORY-TAB] New inventory data:", newData)
					full_inventory = newData
					return full_inventory
				end)
			end
		end)
		return function()
			return connection:Disconnect()
		end
	end, {})
	local _array = {}
	local _length = #_array
	table.move(data, 1, #data, _length + 1, _array)
	local filledInventoryArray = _array
	do
		local i = #data
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < 50) then
				break
			end
			table.insert(filledInventoryArray, emptyInventoryItem)
		end
	end
	table.sort(filledInventoryArray, sortInventory)
	filledInventoryArray = filledInventoryArray
	local _array_1 = {}
	local _length_1 = #_array_1
	table.move(backpackData, 1, #backpackData, _length_1 + 1, _array_1)
	local filledBackpackArray = _array_1
	do
		local i = #backpackData
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < 10) then
				break
			end
			table.insert(filledBackpackArray, emptyInventoryItem)
		end
	end
	table.sort(filledBackpackArray, sortInventory)
	filledBackpackArray = filledBackpackArray
	local filledArray = if selectedTab == "inventory" then filledInventoryArray else filledBackpackArray
	local _attributes = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = props.visible == "inventory",
	}
	local _children = {
		TabButtons = Roact.createElement("Frame", {
			Size = UDim2.new(0.2, 0, 0.3, 0),
			Position = UDim2.fromScale(0.8, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(0, 0, 0),
		}, {
			InventoryTabButton = Roact.createElement("TextButton", {
				Text = "Inventory",
				TextSize = 13,
				Font = "GothamBold",
				Size = UDim2.fromScale(1, 0.35),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				[Roact.Event.MouseButton1Click] = function()
					return setSelectedTab("inventory")
				end,
				BackgroundColor3 = if selectedTab == "inventory" then Color3.fromRGB(128, 128, 128) else Color3.fromRGB(45, 45, 45),
			}),
			BackpackTabButton = Roact.createElement("TextButton", {
				Text = "Backpack",
				Font = "GothamBold",
				TextSize = 13,
				Size = UDim2.fromScale(1, 0.35),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Position = UDim2.fromScale(0, 0.4),
				[Roact.Event.MouseButton1Click] = function()
					return setSelectedTab("backpack")
				end,
				BackgroundColor3 = if selectedTab == "backpack" then Color3.fromRGB(128, 128, 128) else Color3.fromRGB(45, 45, 45),
			}),
		}),
	}
	local _length_2 = #_children
	local _filledInventoryArray = filledInventoryArray
	local _arg0 = function(item, index)
		local _value = item.name
		return if _value ~= "" and _value then (Roact.createFragment({
			[item.name] = Roact.createElement(InventoryItem, {
				name = item.name,
				quantity = item.quantity,
				LayoutOrder = index,
				onClick = function()
					setSelectedItem(returnDesc(item.name))
				end,
			}),
		})) else (Roact.createFragment({
			["Empty_" .. tostring(index)] = Roact.createElement(EmptyInventoryItem, {
				LayoutOrder = index,
			}),
		}))
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_filledInventoryArray)
	for _k, _v in ipairs(_filledInventoryArray) do
		_newValue[_k] = _arg0(_v, _k - 1, _filledInventoryArray)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_1 = {
		Size = UDim2.fromScale(0.77, 1),
		Position = UDim2.fromScale(0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
		Visible = selectedTab == "inventory",
	}
	local _children_1 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromScale(0.15, 0.09),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	local _length_3 = #_children_1
	for _k, _v in ipairs(_newValue) do
		_children_1[_length_3 + _k] = _v
	end
	_children[_length_2 + 1] = Roact.createElement("ScrollingFrame", _attributes_1, _children_1)
	local _filledBackpackArray = filledBackpackArray
	local _arg0_1 = function(item, index)
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
	local _newValue_1 = table.create(#_filledBackpackArray)
	for _k, _v in ipairs(_filledBackpackArray) do
		_newValue_1[_k] = _arg0_1(_v, _k - 1, _filledBackpackArray)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_2 = {
		Size = UDim2.fromScale(0.77, 1),
		Position = UDim2.fromScale(0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
		Visible = selectedTab == "backpack",
	}
	local _children_2 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromScale(0.2, 0.1),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	local _length_4 = #_children_2
	for _k, _v in ipairs(_newValue_1) do
		_children_2[_length_4 + _k] = _v
	end
	_children[_length_2 + 2] = Roact.createElement("ScrollingFrame", _attributes_2, _children_2)
	_children[_length_2 + 3] = Roact.createElement("TextLabel", {
		Text = if selectedItem ~= "" and selectedItem then selectedItem else "",
		Size = UDim2.fromScale(0.25, 0.3),
		Position = UDim2.fromScale(0.89, 1),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.GothamBold,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	_children[_length_2 + 4] = Roact.createElement("TextLabel", {
		Text = selectedTab .. (" (" .. (tostring(#data) .. ("/" .. ((if selectedTab == "inventory" then "50" else "10") .. ")")))),
		Size = UDim2.fromScale(0.4, 0.09),
		Position = UDim2.fromScale(0.5, 0.95),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.GothamBold,
	})
	return Roact.createFragment({
		InventoryPage = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Inventory)
return {
	default = default,
}
