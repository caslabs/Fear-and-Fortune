-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local UserInputService = _services.UserInputService
local Players = _services.Players
local HotbarSlot = TS.import(script, script.Parent.Parent, "components", "slot-component").default
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local GunScreen = TS.import(script, script.Parent, "gun-screen").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
--[[
	Hotbar is basically acts two function
	- Overlay the tool hotbar of particular tools [Still need to create a system for this]
	- Overlay the inventory system in hand
]]
local ToolPickupEvent = Remotes.Client:Get("ToolPickupEvent")
local ToolRemovedEvent = Remotes.Client:Get("ToolRemovedEvent")
local UpdateAmmoEvent = Remotes.Client:Get("UpdateAmmoEvent")
local DropItemFromInventoryEvent = Remotes.Client:Get("DropItemFromInventory")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Hotbar = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local emptySlot = {
		name = "",
		quantity = 0,
	}
	local initialData = { emptySlot, emptySlot, emptySlot, emptySlot, emptySlot }
	local data, setData = useState(initialData)
	local selectedSlot, setSelectedSlot = useState(0)
	local equippedTool, setEquippedTool = useState("")
	local handle, setHandle = useState(nil)
	local toolData, setToolData = useState(nil)
	local ammo, setAmmo = useState(0)
	local hasGun, setHasGun = useState(false)
	-- TODO: Research Gun System
	useEffect(function()
		local connection = UpdateAmmoEvent:Connect(function(newAmmoCount)
			setAmmo(newAmmoCount)
			print("Ammo updated", newAmmoCount)
			if hasGun then
				-- Check if an instance is already mounted and unmount it
				if handle then
					Roact.unmount(handle)
				end
				-- Then mount the new instance
				local newHandle = Roact.mount(Roact.createFragment({
					GunScreen = Roact.createElement("ScreenGui", {
						IgnoreGuiInset = true,
						ResetOnSpawn = false,
					}, {
						Roact.createElement(GunScreen, {
							ammo = newAmmoCount,
							maxAmmo = 8,
						}),
					}),
				}), PlayerGui)
				setHandle(newHandle)
			end
		end)
		return function()
			return connection:Disconnect()
		end
	end, { hasGun, handle })
	useEffect(function()
		local connection = ToolPickupEvent:Connect(function(player, tool, toolData)
			print("Tool picked up: " .. tostring(tool))
			setToolData(toolData)
			-- Check if the tool is already in the hotbar.
			local _arg0 = function(item)
				return item.name == tool.Name
			end
			-- ▼ ReadonlyArray.some ▼
			local _result = false
			for _k, _v in ipairs(data) do
				if _arg0(_v, _k - 1, data) then
					_result = true
					break
				end
			end
			-- ▲ ReadonlyArray.some ▲
			local toolInHotbar = _result
			if toolInHotbar then
				print("Tool " .. (tool.Name .. " is already in the hotbar."))
				return nil
			end
			-- Test
			if tool.Name == "HuntingRifle" then
				if toolData == nil then
					return nil
				end
				setHasGun(true)
			end
			-- If the tool is not in the hotbar, find the first empty slot and add it there.
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			local _arg0_1 = function(item)
				local _value = item.name
				return not (_value ~= "" and _value)
			end
			-- ▼ ReadonlyArray.findIndex ▼
			local _result_1 = -1
			for _i, _v in ipairs(data) do
				if _arg0_1(_v, _i - 1, data) == true then
					_result_1 = _i - 1
					break
				end
			end
			-- ▲ ReadonlyArray.findIndex ▲
			local index = _result_1
			if index ~= -1 then
				local _array = {}
				local _length = #_array
				table.move(data, 1, #data, _length + 1, _array)
				local newData = _array
				newData[index + 1] = {
					name = tool.Name,
					quantity = 1,
					tool = tool,
				}
				setData(newData)
				print("Tool added to hotbar")
				local _result_2 = tool
				if _result_2 ~= nil then
					_result_2 = _result_2.Name
				end
				print("Equipped tool: " .. _result_2)
				local _id = tool
				if _id ~= nil then
					_id = _id.Name
				end
				local id = _id
				print("Adding tool to equippedTool")
				setEquippedTool(id)
			end
		end)
		local removalConnection = ToolRemovedEvent:Connect(function(player, tool)
			local _arg0 = function(item)
				return item.name == tool.Name
			end
			-- ▼ ReadonlyArray.findIndex ▼
			local _result = -1
			for _i, _v in ipairs(data) do
				if _arg0(_v, _i - 1, data) == true then
					_result = _i - 1
					break
				end
			end
			-- ▲ ReadonlyArray.findIndex ▲
			local index = _result
			if index ~= -1 then
				local _array = {}
				local _length = #_array
				table.move(data, 1, #data, _length + 1, _array)
				local newData = _array
				newData[index + 1] = {
					name = "",
					quantity = 0,
				}
				setData(newData)
				setEquippedTool("")
				if handle and equippedTool == tool.Name then
					Roact.unmount(handle)
					setHandle(nil)
				elseif handle == nil then
					print("Handle is undefined, skipping unmount")
				else
					print("Tool is not equipped, skipping unmount")
				end
				if tool.Name == "HuntingRifle" then
					setHasGun(false)
				end
			end
		end)
		return function()
			connection:Disconnect()
			removalConnection:Disconnect()
		end
	end, { data, handle, equippedTool, ammo })
	-- apparently handle must be a dependency for useEffect to work, as handle is a state variable
	local handleUserInput
	useEffect(function()
		print("Equipped tool: " .. equippedTool)
		local connection = UserInputService.InputBegan:Connect(handleUserInput)
		return function()
			return connection:Disconnect()
		end
	end, { data, handle, equippedTool, ammo })
	useEffect(function()
		Signals.DropTool:Connect(function(toolName)
			print("Drop key pressed.")
			-- find the tool in the hotbar
			local _arg0 = function(item)
				return item.name == equippedTool
			end
			-- ▼ ReadonlyArray.findIndex ▼
			local _result = -1
			for _i, _v in ipairs(data) do
				if _arg0(_v, _i - 1, data) == true then
					_result = _i - 1
					break
				end
			end
			-- ▲ ReadonlyArray.findIndex ▲
			local index = _result
			-- if found, remove it from the hotbar
			if index ~= -1 then
				local _array = {}
				local _length = #_array
				table.move(data, 1, #data, _length + 1, _array)
				local newData = _array
				newData[index + 1] = {
					name = "",
					quantity = 0,
				}
				setData(newData)
				if equippedTool ~= "" then
					DropItemFromInventoryEvent:SendToServer(equippedTool)
				end
				-- Find the tool in the character
				local character = Players.LocalPlayer.Character
				local _result_1 = character
				if _result_1 ~= nil then
					_result_1 = _result_1:FindFirstChild(equippedTool)
				end
				local tool = _result_1
				-- if found, remove it from the character
				if tool then
					tool.Parent = nil
				end
				setEquippedTool("")
			end
		end)
	end, { data, equippedTool })
	handleUserInput = function(input)
		local selectedSlotIndex
		if type(input) == "number" then
			selectedSlotIndex = input - 1
		else
			if input.KeyCode == Enum.KeyCode.B then
				print("Drop key pressed.")
				--[[
					// find the tool in the hotbar
					const index = data.findIndex((item) => item.name === equippedTool);
					// if found, remove it from the hotbar
					if (index !== -1) {
					const newData = [...data];
					newData[index] = { name: "", quantity: 0 }; // replace the slot with an empty slot
					setData(newData);
					if (equippedTool !== "") {
					DropItemFromInventoryEvent.SendToServer(equippedTool);
					}
					//Find the tool in the character
					const character = Players.LocalPlayer.Character;
					const tool = character?.FindFirstChild(equippedTool) as Tool;
					// if found, remove it from the character
					if (tool) {
					tool.Parent = undefined;
					}
					setEquippedTool("");
					}
				]]
				return nil
			end
			selectedSlotIndex = input.KeyCode.Value - Enum.KeyCode.One.Value
		end
		print("Selected slot index: " .. tostring(selectedSlotIndex))
		if data[selectedSlotIndex + 1] then
			print("Data in selected slot: " .. data[selectedSlotIndex + 1].name)
			setSelectedSlot(selectedSlotIndex + 1)
			local tool = data[selectedSlotIndex + 1].tool
			local character = Players.LocalPlayer.Character
			if tool then
				local character = Players.LocalPlayer.Character
				local backpack = Players.LocalPlayer:FindFirstChild("Backpack")
				local _result = character
				if _result ~= nil then
					_result = _result:FindFirstChildOfClass("Humanoid")
				end
				local humanoid = _result
				print("Tool found in selected slot, " .. tool.Name .. ", " .. equippedTool)
				humanoid:UnequipTools()
				if humanoid then
					if equippedTool == tool.Name then
						-- Unequip
						print("Equipped tool is the same as the selected tool. Unequipping...")
						setEquippedTool("")
						if backpack then
							tool.Parent = backpack
							print("Tool parented to backpack")
						end
						if handle and equippedTool == tool.Name then
							Roact.unmount(handle)
							setHandle(nil)
						elseif handle == nil then
							print("Handle is undefined, skipping unmount")
						else
							print("Tool is not equipped, skipping unmount")
						end
					else
						-- Equip
						print("Equipped tool is different from the selected tool. Equipping " .. (tool.Name .. "..."))
						print("Equipped tool: " .. equippedTool)
						print("Selected tool: " .. tool.Name)
						setEquippedTool(tool.Name)
						if character then
							tool.Parent = character
						end
						if tool.Name == "HuntingRifle" then
							if toolData == nil then
								return nil
							end
							setHasGun(true)
						end
					end
				end
			else
				print("Tool not found in selected slot")
				return nil
			end
		end
	end
	local _arg0 = function(item, index)
		local _attributes = {
			slotNumber = index + 1,
		}
		local _value = item.name
		_attributes.item = if _value ~= "" and _value then item else nil
		_attributes.LayoutOrder = index
		_attributes.selected = index + 1 == selectedSlot and equippedTool == item.name
		_attributes.onUserInput = function()
			return handleUserInput(index + 1)
		end
		return Roact.createFragment({
			["Slot_" .. tostring((index + 1))] = Roact.createElement(HotbarSlot, _attributes),
		})
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#data)
	for _k, _v in ipairs(data) do
		_newValue[_k] = _arg0(_v, _k - 1, data)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes = {
		Size = UDim2.new(0.3, 0, 0.1, 0),
		Position = UDim2.fromScale(0.5, 0.94),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	}
	local _children = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromScale(0.15, 1),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),
	}
	local _length = #_children
	for _k, _v in ipairs(_newValue) do
		_children[_length + _k] = _v
	end
	return Roact.createFragment({
		Hotbar = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Hotbar)
return {
	default = default,
}
