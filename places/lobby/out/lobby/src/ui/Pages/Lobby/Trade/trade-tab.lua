-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local InventoryTradeItem = TS.import(script, script.Parent.Parent, "Inventory", "inventory-trade-component").default
local EmptyInventoryItem = TS.import(script, script.Parent.Parent, "Inventory", "empty-inventory-component").default
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local __TradeData = TS.import(script, script.Parent, "vendors", "data", "_TradeData")
local tradeInventoryList = __TradeData.tradeInventoryList
local itemValues = __TradeData.itemValues
local tradeInventoryList2 = TS.import(script, script.Parent, "vendors", "data", "_TradeData2").tradeInventoryList2
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
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
local function reorderInventory(inventory)
	table.sort(inventory, sortInventory)
	return inventory
end
local function compareInventories(oldInventory, newInventory)
	local oldInventoryMap = {}
	local newInventoryMap = {}
	local changes = {}
	local _arg0 = function(item)
		local _name = item.name
		local _quantity = item.quantity
		oldInventoryMap[_name] = _quantity
	end
	for _k, _v in ipairs(oldInventory) do
		_arg0(_v, _k - 1, oldInventory)
	end
	local _arg0_1 = function(item)
		local _name = item.name
		local _quantity = item.quantity
		newInventoryMap[_name] = _quantity
	end
	for _k, _v in ipairs(newInventory) do
		_arg0_1(_v, _k - 1, newInventory)
	end
	local _arg0_2 = function(value, key)
		local _condition = newInventoryMap[key]
		if _condition == nil then
			_condition = 0
		end
		local newQuantity = _condition
		local diff = newQuantity - value
		if diff ~= 0 then
			changes[key] = diff
		end
	end
	for _k, _v in pairs(oldInventoryMap) do
		_arg0_2(_v, _k, oldInventoryMap)
	end
	local _arg0_3 = function(value, key)
		if not (oldInventoryMap[key] ~= nil) then
			changes[key] = value
		end
	end
	for _k, _v in pairs(newInventoryMap) do
		_arg0_3(_v, _k, newInventoryMap)
	end
	return changes
end
-- TODO: Apparently UpdateInventory is a one-to-one event, so we need to create a new event for trading
local TradeRequestEvent = Remotes.Client:Get("TradeRequest")
local full_inventory = {}
local player = Players.LocalPlayer
local Trade = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local data, setData = useState({})
	local tradeData, settradeData = useState(tradeInventoryList)
	local tradeData2, settradeData2 = useState(tradeInventoryList2)
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
	local _array_2 = {}
	local _length_2 = #_array_2
	table.move(tradeData2, 1, #tradeData2, _length_2 + 1, _array_2)
	local filledTradeArray2 = _array_2
	do
		local i = #tradeData2
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
			table.insert(filledTradeArray2, emptyInventoryItem)
		end
	end
	-- TODO : Fix Trading synchronization
	useEffect(function()
		print("[TRADE] Running useEffect in Trade tab")
		local connection1 = UpdateInventoryTradingEvent:Connect(function(player, item, action, quantity)
			print("[TRADE] Calling UpdateInventoryTradingEvent in Trade tab")
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
						print(existingItem)
						if action == "add" then
							existingItem.quantity += quantity
						elseif action == "remove" then
							print("[PLEASE] Remove item from inventory")
							if existingItem.quantity > 1 then
								print(existingItem.quantity)
								existingItem.quantity += quantity
								print("[BOOGA1], newData")
							else
								local _newData = newData
								local _arg0_1 = function(data)
									return data.name ~= item
								end
								-- ▼ ReadonlyArray.filter ▼
								local _newValue = {}
								local _length_3 = 0
								for _k, _v in ipairs(_newData) do
									if _arg0_1(_v, _k - 1, _newData) == true then
										_length_3 += 1
										_newValue[_length_3] = _v
									end
								end
								-- ▲ ReadonlyArray.filter ▲
								newData = _newValue
								print(newData)
								print("[BOOGA2], newData")
							end
						end
					elseif action == "add" then
						local _newData = newData
						local _arg0_1 = {
							name = item,
							quantity = quantity,
						}
						table.insert(_newData, _arg0_1)
						print("[BOOGA-INFINITY], newData")
					end
					print("[DEBUG-TRADING-TAB] New inventory data:", newData)
					full_inventory = newData
					return full_inventory
				end)
			end
		end)
		return function()
			return connection1:Disconnect()
		end
	end, {})
	local _attributes = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = props.visible == "trade",
	}
	local _children = {
		TabButtons = Roact.createElement("Frame", {
			Size = UDim2.new(0.2, 0, 1, 0),
			Position = UDim2.fromScale(0.8, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(0, 0, 0),
		}, {
			TabButtonBackground = Roact.createElement("ImageLabel", {
				Size = UDim2.fromScale(1, 0.25),
				Position = UDim2.fromScale(0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Image = if selectedTab == "vendor1" then "rbxassetid://14034815981" else "rbxassetid://14041849448",
				ScaleType = "Crop",
			}),
			VendorHeader = Roact.createElement("TextLabel", {
				Text = "Vendors",
				Font = "GothamBold",
				TextSize = 13,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0.1),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Position = UDim2.fromScale(0, 0.25),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			}),
			BackpackTabButton = Roact.createElement("TextButton", {
				Text = "Pocketcat",
				Font = "GothamBold",
				TextSize = 13,
				Size = UDim2.fromScale(1, 0.1),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Position = UDim2.fromScale(0, 0.33),
				[Roact.Event.MouseButton1Click] = function()
					setSelectedTab("vendor1")
					SoundSystemController:playSound(SoundKeys.SFX_MR_KITTEN)
				end,
				BackgroundColor3 = if selectedTab == "vendor1" then Color3.fromRGB(128, 128, 128) else Color3.fromRGB(45, 45, 45),
			}),
			ElGoblinoMerchant = Roact.createElement("TextButton", {
				Text = "El Goblino",
				Font = "GothamBold",
				TextSize = 13,
				Size = UDim2.fromScale(1, 0.1),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Position = UDim2.fromScale(0, 0.45),
				[Roact.Event.MouseButton1Click] = function()
					setSelectedTab("vendor2")
					SoundSystemController:playSound(SoundKeys.SFX_EL_GOBLINO)
				end,
				BackgroundColor3 = if selectedTab == "vendor2" then Color3.fromRGB(128, 128, 128) else Color3.fromRGB(45, 45, 45),
			}),
			SellButton = Roact.createElement("TextButton", {
				Text = "Trade (" .. (tostring(tradeValue) .. "s)\n [LOCKED]"),
				Font = "GothamBold",
				TextSize = 13,
				Size = UDim2.fromScale(1, 0.1),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				[Roact.Event.MouseButton1Click] = function()
					print("Selling items")
					print("NEW STASH DATA 1", data)
					print("NEW STASH DATA 2", full_inventory)
					print(compareInventories(full_inventory, data))
					-- TradeRequestEvent.SendToServer(tradeValue, compareInventories(full_inventory, data));
					-- TradeRequestEvent.SendToServer(tradeValue, compareInventories(full_inventory, data));
					print("DATA, ", data)
					-- setTradeValue(0);
				end,
				BackgroundColor3 = Color3.fromRGB(128, 128, 128),
			}),
		}),
		Roact.createElement("TextLabel", {
			Text = if selectedTab == "inventory" then "Player" elseif selectedTab == "vendor1" then "Pocketcat" else "El Goblino",
			Size = UDim2.fromScale(0.3, 0.025),
			TextScaled = true,
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
		}),
		Roact.createElement("TextLabel", {
			Text = "Your inventory (" .. (tostring(#data) .. ("/" .. ((if selectedTab == "inventory" then "50" else "50") .. ")"))),
			Size = UDim2.fromScale(0.3, 0.025),
			TextScaled = true,
			Position = UDim2.fromScale(0, 0.55),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
		}),
		Roact.createElement("TextLabel", {
			Text = if selectedTab == "vendor1" then "My trade's in whispers, silence my cheat, care to guess my cravings of such meat?" else "El Goblino, dweller of caverns deep, trades in trinkets of dreams and sleep; shadows whisper, in jingles and clink, 'Dare you barter on the brink?",
			Size = UDim2.fromScale(1, 0.025),
			TextScaled = true,
			Position = UDim2.fromScale(0.35, 1.1),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Bottom,
		}),
	}
	local _length_3 = #_children
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
						local _newValue = table.create(#filledInventoryArray)
						for _k, _v in ipairs(filledInventoryArray) do
							_newValue[_k] = _arg0_1(_v, _k - 1, filledInventoryArray)
						end
						-- ▲ ReadonlyArray.map ▲
						local _arg0_2 = function(item)
							return item.quantity > 0
						end
						-- ▼ ReadonlyArray.filter ▼
						local _newValue_1 = {}
						local _length_4 = 0
						for _k, _v in ipairs(_newValue) do
							if _arg0_2(_v, _k - 1, _newValue) == true then
								_length_4 += 1
								_newValue_1[_length_4] = _v
							end
						end
						-- ▲ ReadonlyArray.filter ▲
						local updatedInventory = _newValue_1
						print("[DEBUG] updatedInventory", updatedInventory)
						-- check if the item already exists in the player's inventory
						local _arg0_3 = function(inventoryItem)
							return inventoryItem.name == item.name
						end
						-- ▼ ReadonlyArray.findIndex ▼
						local _result = -1
						for _i, _v in ipairs(filledTradeArray) do
							if _arg0_3(_v, _i - 1, filledTradeArray) == true then
								_result = _i - 1
								break
							end
						end
						-- ▲ ReadonlyArray.findIndex ▲
						local existingItemIndex = _result
						local updatedTradeInventory
						if existingItemIndex ~= -1 then
							-- item exists, update the quantity
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
							local _newValue_2 = table.create(#filledTradeArray)
							for _k, _v in ipairs(filledTradeArray) do
								_newValue_2[_k] = _arg0_4(_v, _k - 1, filledTradeArray)
							end
							-- ▲ ReadonlyArray.map ▲
							updatedTradeInventory = _newValue_2
						else
							-- item does not exist, add it to the inventory
							local _array_3 = {}
							local _length_5 = #_array_3
							local _filledTradeArrayLength = #filledTradeArray
							table.move(filledTradeArray, 1, _filledTradeArrayLength, _length_5 + 1, _array_3)
							_length_5 += _filledTradeArrayLength
							_array_3[_length_5 + 1] = singleItem
							updatedTradeInventory = _array_3
							local _updatedTradeInventory = updatedTradeInventory
							local _arg0_4 = function(item)
								return item.name ~= ""
							end
							-- ▼ ReadonlyArray.filter ▼
							local _newValue_2 = {}
							local _length_6 = 0
							for _k, _v in ipairs(_updatedTradeInventory) do
								if _arg0_4(_v, _k - 1, _updatedTradeInventory) == true then
									_length_6 += 1
									_newValue_2[_length_6] = _v
								end
							end
							-- ▲ ReadonlyArray.filter ▲
							updatedTradeInventory = _newValue_2
							do
								local i = #updatedTradeInventory
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
									table.insert(updatedTradeInventory, emptyInventoryItem)
								end
							end
							print("[BOOGA0] updatedTradeInventory", updatedTradeInventory)
						end
						-- Check if the item already exists in
						-- filledTradeArray.push(singleItem);
						print("[BOOGA0] updatedInventory", updatedInventory)
						-- Remove Empty Inventory Items
						-- updatedInventory = filledInventoryArray.filter((item) => item.name !== "");
						setData(updatedInventory)
						settradeData(updatedTradeInventory)
						print("updatedTradeInventory", updatedTradeInventory)
						if itemValues[singleItem.name] ~= nil then
							setTradeValue(function(prevValue)
								return prevValue + itemValues[singleItem.name]
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
	local _newValue = table.create(#filledInventoryArray)
	for _k, _v in ipairs(filledInventoryArray) do
		_newValue[_k] = _arg0(_v, _k - 1, filledInventoryArray)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_1 = {
		Size = UDim2.fromScale(0.77, 0.38),
		Position = UDim2.fromScale(0, 0.6),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
	}
	local _children_1 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromScale(0.15, 0.09),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	local _length_4 = #_children_1
	for _k, _v in ipairs(_newValue) do
		_children_1[_length_4 + _k] = _v
	end
	_children[_length_3 + 1] = Roact.createElement("ScrollingFrame", _attributes_1, _children_1)
	local _arg0_1 = function(item, index)
		local _value = item.name
		return if _value ~= "" and _value then (Roact.createFragment({
			[item.name] = Roact.createElement(InventoryTradeItem, {
				name = item.name,
				quantity = item.quantity,
				LayoutOrder = index,
				onClick = function()
					if item.quantity > 0 then
						-- create a copy of item but with quantity 1 for the trade
						local _object = {}
						for _k, _v in pairs(item) do
							_object[_k] = _v
						end
						_object.quantity = 1
						local singleItem = _object
						-- reduce the quantity of this item in the trade inventory by 1
						local _arg0_2 = function(tradeItem)
							local _result
							if tradeItem.name == item.name then
								local _object_1 = {}
								for _k, _v in pairs(tradeItem) do
									_object_1[_k] = _v
								end
								_object_1.quantity = tradeItem.quantity - 1
								_result = _object_1
							else
								_result = tradeItem
							end
							return _result
						end
						-- ▼ ReadonlyArray.map ▼
						local _newValue_1 = table.create(#filledTradeArray)
						for _k, _v in ipairs(filledTradeArray) do
							_newValue_1[_k] = _arg0_2(_v, _k - 1, filledTradeArray)
						end
						-- ▲ ReadonlyArray.map ▲
						local _arg0_3 = function(item)
							return item.quantity > 0
						end
						-- ▼ ReadonlyArray.filter ▼
						local _newValue_2 = {}
						local _length_5 = 0
						for _k, _v in ipairs(_newValue_1) do
							if _arg0_3(_v, _k - 1, _newValue_1) == true then
								_length_5 += 1
								_newValue_2[_length_5] = _v
							end
						end
						-- ▲ ReadonlyArray.filter ▲
						local updatedTrade = _newValue_2
						-- check if the item already exists in the player's inventory
						local _arg0_4 = function(inventoryItem)
							return inventoryItem.name == item.name
						end
						-- ▼ ReadonlyArray.findIndex ▼
						local _result = -1
						for _i, _v in ipairs(filledInventoryArray) do
							if _arg0_4(_v, _i - 1, filledInventoryArray) == true then
								_result = _i - 1
								break
							end
						end
						-- ▲ ReadonlyArray.findIndex ▲
						local existingItemIndex = _result
						local updatedInventory
						if existingItemIndex ~= -1 then
							-- item exists, update the quantity
							local _arg0_5 = function(inventoryItem, index)
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
							local _newValue_3 = table.create(#filledInventoryArray)
							for _k, _v in ipairs(filledInventoryArray) do
								_newValue_3[_k] = _arg0_5(_v, _k - 1, filledInventoryArray)
							end
							-- ▲ ReadonlyArray.map ▲
							updatedInventory = _newValue_3
						else
							-- item does not exist, add it to the inventory
							-- fuklter
							local _array_3 = {}
							local _length_6 = #_array_3
							local _filledInventoryArrayLength = #filledInventoryArray
							table.move(filledInventoryArray, 1, _filledInventoryArrayLength, _length_6 + 1, _array_3)
							_length_6 += _filledInventoryArrayLength
							_array_3[_length_6 + 1] = singleItem
							updatedInventory = _array_3
						end
						-- Filter out empty trade items
						print("[DEBUG VENDOR] updatedInventory", updatedInventory)
						-- Remove Empty Inventory Items
						local _updatedInventory = updatedInventory
						local _arg0_5 = function(item)
							return item.name ~= ""
						end
						-- ▼ ReadonlyArray.filter ▼
						local _newValue_3 = {}
						local _length_6 = 0
						for _k, _v in ipairs(_updatedInventory) do
							if _arg0_5(_v, _k - 1, _updatedInventory) == true then
								_length_6 += 1
								_newValue_3[_length_6] = _v
							end
						end
						-- ▲ ReadonlyArray.filter ▲
						updatedInventory = _newValue_3
						setData(updatedInventory)
						settradeData(updatedTrade)
						if itemValues[singleItem.name] ~= nil then
							setTradeValue(function(prevValue)
								return prevValue - itemValues[singleItem.name]
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
	local _newValue_1 = table.create(#filledTradeArray)
	for _k, _v in ipairs(filledTradeArray) do
		_newValue_1[_k] = _arg0_1(_v, _k - 1, filledTradeArray)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_2 = {
		Size = UDim2.fromScale(0.77, 0.5),
		Position = UDim2.fromScale(0, 0.035),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
		Visible = selectedTab == "vendor1",
	}
	local _children_2 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromScale(0.15, 0.09),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	local _length_5 = #_children_2
	for _k, _v in ipairs(_newValue_1) do
		_children_2[_length_5 + _k] = _v
	end
	_children[_length_3 + 2] = Roact.createElement("ScrollingFrame", _attributes_2, _children_2)
	local _arg0_2 = function(item, index)
		local _value = item.name
		return if _value ~= "" and _value then (Roact.createFragment({
			[item.name] = Roact.createElement(InventoryTradeItem, {
				name = item.name,
				quantity = item.quantity,
				LayoutOrder = index,
				onClick = function()
					if item.quantity > 0 then
						-- create a copy of item but with quantity 1 for the trade
						local _object = {}
						for _k, _v in pairs(item) do
							_object[_k] = _v
						end
						_object.quantity = 1
						local singleItem = _object
						-- reduce the quantity of this item in the trade inventory by 1
						local _arg0_3 = function(tradeItem)
							local _result
							if tradeItem.name == item.name then
								local _object_1 = {}
								for _k, _v in pairs(tradeItem) do
									_object_1[_k] = _v
								end
								_object_1.quantity = tradeItem.quantity - 1
								_result = _object_1
							else
								_result = tradeItem
							end
							return _result
						end
						-- ▼ ReadonlyArray.map ▼
						local _newValue_2 = table.create(#filledTradeArray2)
						for _k, _v in ipairs(filledTradeArray2) do
							_newValue_2[_k] = _arg0_3(_v, _k - 1, filledTradeArray2)
						end
						-- ▲ ReadonlyArray.map ▲
						local _arg0_4 = function(item)
							return item.quantity > 0
						end
						-- ▼ ReadonlyArray.filter ▼
						local _newValue_3 = {}
						local _length_6 = 0
						for _k, _v in ipairs(_newValue_2) do
							if _arg0_4(_v, _k - 1, _newValue_2) == true then
								_length_6 += 1
								_newValue_3[_length_6] = _v
							end
						end
						-- ▲ ReadonlyArray.filter ▲
						local updatedTrade = _newValue_3
						-- check if the item already exists in the player's inventory
						local _arg0_5 = function(inventoryItem)
							return inventoryItem.name == item.name
						end
						-- ▼ ReadonlyArray.findIndex ▼
						local _result = -1
						for _i, _v in ipairs(filledInventoryArray) do
							if _arg0_5(_v, _i - 1, filledInventoryArray) == true then
								_result = _i - 1
								break
							end
						end
						-- ▲ ReadonlyArray.findIndex ▲
						local existingItemIndex = _result
						local updatedInventory
						if existingItemIndex ~= -1 then
							-- item exists, update the quantity
							local _arg0_6 = function(inventoryItem, index)
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
							local _newValue_4 = table.create(#filledInventoryArray)
							for _k, _v in ipairs(filledInventoryArray) do
								_newValue_4[_k] = _arg0_6(_v, _k - 1, filledInventoryArray)
							end
							-- ▲ ReadonlyArray.map ▲
							updatedInventory = _newValue_4
						else
							-- item does not exist, add it to the inventory
							-- fuklter
							local _array_3 = {}
							local _length_7 = #_array_3
							local _filledInventoryArrayLength = #filledInventoryArray
							table.move(filledInventoryArray, 1, _filledInventoryArrayLength, _length_7 + 1, _array_3)
							_length_7 += _filledInventoryArrayLength
							_array_3[_length_7 + 1] = singleItem
							updatedInventory = _array_3
						end
						-- Filter out empty trade items
						-- updatedInventory = filledInventoryArray.filter((item) => item.name !== "");
						print("[DEBUG VENDOR] updatedInventory", updatedInventory)
						-- Remove Empty Inventory Items
						local _updatedInventory = updatedInventory
						local _arg0_6 = function(item)
							return item.name ~= ""
						end
						-- ▼ ReadonlyArray.filter ▼
						local _newValue_4 = {}
						local _length_7 = 0
						for _k, _v in ipairs(_updatedInventory) do
							if _arg0_6(_v, _k - 1, _updatedInventory) == true then
								_length_7 += 1
								_newValue_4[_length_7] = _v
							end
						end
						-- ▲ ReadonlyArray.filter ▲
						updatedInventory = _newValue_4
						setData(updatedInventory)
						settradeData2(updatedTrade)
						if itemValues[singleItem.name] ~= nil then
							setTradeValue(function(prevValue)
								return prevValue - itemValues[singleItem.name]
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
	local _newValue_2 = table.create(#filledTradeArray2)
	for _k, _v in ipairs(filledTradeArray2) do
		_newValue_2[_k] = _arg0_2(_v, _k - 1, filledTradeArray2)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_3 = {
		Size = UDim2.fromScale(0.77, 0.5),
		Position = UDim2.fromScale(0, 0.035),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
		Visible = selectedTab == "vendor2",
	}
	local _children_3 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromScale(0.15, 0.09),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	local _length_6 = #_children_3
	for _k, _v in ipairs(_newValue_2) do
		_children_3[_length_6 + _k] = _v
	end
	_children[_length_3 + 3] = Roact.createElement("ScrollingFrame", _attributes_3, _children_3)
	return Roact.createFragment({
		TradePage = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Trade)
return {
	default = default,
}
