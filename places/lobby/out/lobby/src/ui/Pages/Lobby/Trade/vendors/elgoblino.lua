-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local InventoryTradeItem = TS.import(script, script.Parent.Parent.Parent, "Inventory", "inventory-trade-component").default
local EmptyInventoryItem = TS.import(script, script.Parent.Parent.Parent, "Inventory", "empty-inventory-component").default
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local __TradeData2 = TS.import(script, script.Parent, "data", "_TradeData2")
local tradeInventoryList2 = __TradeData2.tradeInventoryList2
local itemValues2 = __TradeData2.itemValues2
local UpdateInventoryTradingEvent = Remotes.Client:Get("UpdateInventoryTrading")
local emptyInventoryItem = {
	name = "",
	quantity = 0,
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
-- Credit Screen Button
local ElGoblino = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local data, setData = useState({})
	local tradeData, settradeData = useState(tradeInventoryList2)
	local selectedTab, setSelectedTab = useState("vendor1")
	local tradeValue, setTradeValue = useState(0)
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
	local _array_1 = {}
	local _length_1 = #_array_1
	table.move(tradeData, 1, #tradeData, _length_1 + 1, _array_1)
	local filledTradeArray = _array_1
	do
		local i = #tradeData
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
			table.insert(filledTradeArray, emptyInventoryItem)
		end
	end
	useEffect(function()
		table.sort(filledTradeArray, sortInventory)
		filledTradeArray = filledTradeArray
		table.sort(filledInventoryArray, sortInventory)
		filledInventoryArray = filledInventoryArray
	end, {})
	local _data = props.data
	local _arg0 = function(item, index)
		local _value = item.name
		return if _value ~= "" and _value then (Roact.createFragment({
			[item.name] = Roact.createElement(InventoryTradeItem, {
				name = item.name,
				quantity = item.quantity,
				LayoutOrder = index,
				onClick = function()
					if item.quantity > 0 then
						-- Add this condition
						-- create a copy of item but with quantity 1 for the trade
						local _object = {}
						for _k, _v in pairs(item) do
							_object[_k] = _v
						end
						_object.quantity = 1
						local singleItem = _object
						-- reduce the quantity of this item in the player's inventory by 1
						local _filledInventoryArray = filledInventoryArray
						local _arg0_1 = function(inventoryItem)
							local _result
							if inventoryItem.name == item.name then
								local _object_1 = {}
								for _k, _v in pairs(inventoryItem) do
									_object_1[_k] = _v
								end
								_object_1.quantity = inventoryItem.quantity - 1
								_result = _object_1
							else
								_result = inventoryItem
							end
							return _result
						end
						-- ▼ ReadonlyArray.map ▼
						local _newValue = table.create(#_filledInventoryArray)
						for _k, _v in ipairs(_filledInventoryArray) do
							_newValue[_k] = _arg0_1(_v, _k - 1, _filledInventoryArray)
						end
						-- ▲ ReadonlyArray.map ▲
						local _arg0_2 = function(item)
							return item.quantity > 0
						end
						-- ▼ ReadonlyArray.filter ▼
						local _newValue_1 = {}
						local _length_2 = 0
						for _k, _v in ipairs(_newValue) do
							if _arg0_2(_v, _k - 1, _newValue) == true then
								_length_2 += 1
								_newValue_1[_length_2] = _v
							end
						end
						-- ▲ ReadonlyArray.filter ▲
						local updatedInventory = _newValue_1
						print("[DEBUG] updatedInventory", updatedInventory)
						-- check if the item already exists in the player's inventory
						local _filledTradeArray = filledTradeArray
						local _arg0_3 = function(inventoryItem)
							return inventoryItem.name == item.name
						end
						-- ▼ ReadonlyArray.findIndex ▼
						local _result = -1
						for _i, _v in ipairs(_filledTradeArray) do
							if _arg0_3(_v, _i - 1, _filledTradeArray) == true then
								_result = _i - 1
								break
							end
						end
						-- ▲ ReadonlyArray.findIndex ▲
						local existingItemIndex = _result
						local updatedTradeInventory
						if existingItemIndex ~= -1 then
							-- item exists, update the quantity
							local _filledTradeArray_1 = filledTradeArray
							local _arg0_4 = function(inventoryItem, index)
								local _result_1
								if index == existingItemIndex then
									local _object_1 = {}
									for _k, _v in pairs(inventoryItem) do
										_object_1[_k] = _v
									end
									_object_1.quantity = inventoryItem.quantity + 1
									_result_1 = _object_1
								else
									_result_1 = inventoryItem
								end
								return _result_1
							end
							-- ▼ ReadonlyArray.map ▼
							local _newValue_2 = table.create(#_filledTradeArray_1)
							for _k, _v in ipairs(_filledTradeArray_1) do
								_newValue_2[_k] = _arg0_4(_v, _k - 1, _filledTradeArray_1)
							end
							-- ▲ ReadonlyArray.map ▲
							updatedTradeInventory = _newValue_2
						else
							-- item does not exist, add it to the inventory
							local _array_2 = {}
							local _length_3 = #_array_2
							local _filledTradeArrayLength = #filledTradeArray
							table.move(filledTradeArray, 1, _filledTradeArrayLength, _length_3 + 1, _array_2)
							_length_3 += _filledTradeArrayLength
							_array_2[_length_3 + 1] = singleItem
							updatedTradeInventory = _array_2
						end
						-- Check if the item already exists in
						-- filledTradeArray.push(singleItem);
						print("[BOOGA0] updatedInventory", updatedInventory)
						-- Remove Empty Inventory Items
						-- updatedInventory = filledInventoryArray.filter((item) => item.name !== "");
						setData(updatedInventory)
						settradeData(updatedTradeInventory)
						if itemValues2[singleItem.name] ~= nil then
							setTradeValue(function(prevValue)
								return prevValue + itemValues2[singleItem.name]
							end)
						end
					end
				end,
			}),
		})) else (Roact.createFragment({
			["Empty_" .. tostring(index)] = Roact.createElement(EmptyInventoryItem, {
				LayoutOrder = index,
			}),
		}))
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_data)
	for _k, _v in ipairs(_data) do
		_newValue[_k] = _arg0(_v, _k - 1, _data)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes = {
		Size = UDim2.fromScale(0.77, 0.38),
		Position = UDim2.fromScale(0, 0.6),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
		Visible = props.isVisible,
	}
	local _children = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromScale(0.15, 0.09),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	local _length_2 = #_children
	for _k, _v in ipairs(_newValue) do
		_children[_length_2 + _k] = _v
	end
	return Roact.createElement("ScrollingFrame", _attributes, _children)
end
local default = Hooks.new(Roact)(ElGoblino)
return {
	default = default,
}
