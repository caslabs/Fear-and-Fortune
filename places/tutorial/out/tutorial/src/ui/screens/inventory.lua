-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Pages = TS.import(script, script.Parent.Parent, "Context").Pages
local Panel = TS.import(script, script.Parent.Parent, "Panels", "Panel").Panel
local InventoryItem = TS.import(script, script.Parent.Parent, "components", "inventory-component").default
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local UpdateInventoryEvent = Remotes.Client:Get("UpdateInventory")
print("Inventory loaded")
local Inventory = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local data, setData = useState({})
	useEffect(function()
		local connection = UpdateInventoryEvent:Connect(function(player, item, action)
			if player == Players.LocalPlayer then
				if action == "add" then
					setData(function(prevData)
						local _array = {}
						local _length = #_array
						local _prevDataLength = #prevData
						table.move(prevData, 1, _prevDataLength, _length + 1, _array)
						_length += _prevDataLength
						_array[_length + 1] = {
							name = item,
						}
						return _array
					end)
				elseif action == "remove" then
					setData(function(prevData)
						local _arg0 = function(data)
							return data.name ~= item
						end
						-- ▼ ReadonlyArray.filter ▼
						local _newValue = {}
						local _length = 0
						for _k, _v in ipairs(prevData) do
							if _arg0(_v, _k - 1, prevData) == true then
								_length += 1
								_newValue[_length] = _v
							end
						end
						-- ▲ ReadonlyArray.filter ▲
						return _newValue
					end)
				end
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
	local _children = {}
	local _length = #_children
	local _attributes_1 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
	}
	local _children_1 = {}
	local _length_1 = #_children_1
	local _attributes_2 = {
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
	}
	local _children_2 = {}
	local _length_2 = #_children_2
	local _arg0 = function(item)
		return Roact.createFragment({
			[item.name] = Roact.createElement(InventoryItem, {
				name = item.name,
			}),
		})
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#data)
	for _k, _v in ipairs(data) do
		_newValue[_k] = _arg0(_v, _k - 1, data)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_3 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0,
		CanvasSize = UDim2.new(2, 0, 2, 0),
		ScrollBarThickness = 6,
	}
	local _children_3 = {
		Roact.createElement("UIGridLayout", {
			CellSize = UDim2.new(0.2, 0, 0.2, 0),
			FillDirectionMaxCells = 4,
			StartCorner = "TopLeft",
		}),
	}
	local _length_3 = #_children_3
	for _k, _v in ipairs(_newValue) do
		_children_3[_length_3 + _k] = _v
	end
	_children_2[_length_2 + 1] = Roact.createElement("ScrollingFrame", _attributes_3, _children_3)
	_children_1[_length_1 + 1] = Roact.createElement("Frame", _attributes_2, _children_2)
	_children[_length + 1] = Roact.createElement("Frame", _attributes_1, _children_1)
	return Roact.createFragment({
		Inventory = Roact.createElement(Panel, _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Inventory)
return {
	default = default,
}
