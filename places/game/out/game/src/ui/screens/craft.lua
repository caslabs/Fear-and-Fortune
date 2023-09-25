-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local Pages = TS.import(script, script.Parent.Parent, "Context").Pages
local Close = TS.import(script, script.Parent.Parent, "Panels", "Close").default
local Panel = TS.import(script, script.Parent.Parent, "Panels", "Panel").Panel
local CraftItem = TS.import(script, script.Parent.Parent, "components", "CraftItem").default
local CheckCraftingIngredientsEvent = Remotes.Client:Get("CheckCraftingIngredients")
local Crafting = function(props, _param)
	local useState = _param.useState
	local selectedCraftItem, setSelectedCraftItem = useState(props.data[1])
	local activeCraftItem, setActiveCraftItem = useState(props.data[1].name)
	local _attributes = {
		index = Pages.craft,
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
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
	}
	local _children_1 = {}
	local _length_1 = #_children_1
	local _attributes_2 = {
		Size = UDim2.new(0.8, 0, 0.8, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	}
	local _children_2 = {}
	local _length_2 = #_children_2
	local _data = props.data
	local _arg0 = function(info, index)
		return Roact.createFragment({
			[info.name] = Roact.createElement(CraftItem, {
				title = info.name,
				desc = info.desc,
				color = info.color,
				layoutOrder = index,
				active = activeCraftItem == info.name,
				onClick = function()
					setSelectedCraftItem(info)
					setActiveCraftItem(info.name)
				end,
			}),
		})
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_data)
	for _k, _v in ipairs(_data) do
		_newValue[_k] = _arg0(_v, _k - 1, _data)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_3 = {
		Size = UDim2.fromScale(0.27, 1),
		Position = UDim2.fromScale(0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 3,
		AutomaticCanvasSize = "Y",
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	}
	local _children_3 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromScale(0, 0.03),
			CellSize = UDim2.fromScale(1, 0.2),
		}),
	}
	local _length_3 = #_children_3
	for _k, _v in ipairs(_newValue) do
		_children_3[_length_3 + _k] = _v
	end
	_children_2[_length_2 + 1] = Roact.createElement("ScrollingFrame", _attributes_3, _children_3)
	local _condition = selectedCraftItem
	if _condition then
		local _ingredients = selectedCraftItem.ingredients
		local _arg0_1 = function(ingredient, index)
			return Roact.createFragment({
				[ingredient.itemName] = Roact.createElement("TextLabel", {
					Text = tostring(ingredient.quantity) .. ("x " .. ingredient.itemName),
					Position = UDim2.fromScale(0, 0.55 + index * 0.05),
					Size = UDim2.fromScale(1, 0.02),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					Font = Enum.Font.Gotham,
					FontSize = Enum.FontSize.Size14,
					RichText = true,
					TextColor3 = Color3.fromRGB(230, 230, 230),
				}),
			})
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue_1 = table.create(#_ingredients)
		for _k, _v in ipairs(_ingredients) do
			_newValue_1[_k] = _arg0_1(_v, _k - 1, _ingredients)
		end
		-- ▲ ReadonlyArray.map ▲
		local _attributes_4 = {
			Size = UDim2.fromScale(0.7, 1),
			Position = UDim2.fromScale(0.3, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
		}
		local _children_4 = {
			Roact.createElement("TextLabel", {
				Text = selectedCraftItem.name,
				Size = UDim2.fromScale(1, 0.2),
				BackgroundTransparency = 1,
				Font = Enum.Font.Gotham,
				TextColor3 = Color3.fromRGB(230, 230, 230),
				FontSize = Enum.FontSize.Size24,
			}),
			Roact.createElement("TextLabel", {
				Text = selectedCraftItem.desc,
				Position = UDim2.fromScale(0, 0.2),
				Size = UDim2.fromScale(1, 0.25),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Font = Enum.Font.Gotham,
				FontSize = Enum.FontSize.Size14,
				RichText = true,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(230, 230, 230),
			}),
			Roact.createElement("TextLabel", {
				Text = "Ingredients:",
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.fromScale(1, 0.1),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Font = Enum.Font.Gotham,
				FontSize = Enum.FontSize.Size14,
				RichText = true,
				TextColor3 = Color3.fromRGB(230, 230, 230),
			}),
		}
		local _length_4 = #_children_4
		for _k, _v in ipairs(_newValue_1) do
			_children_4[_length_4 + _k] = _v
		end
		_length_4 = #_children_4
		_children_4[_length_4 + 1] = Roact.createElement("TextButton", {
			Text = "CRAFT",
			Size = UDim2.fromScale(1, 0.2),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(200, 200, 200),
			BackgroundColor3 = Color3.fromRGB(75, 75, 75),
			[Roact.Event.MouseButton1Click] = function()
				SoundSystemController:playSound(SoundKeys.SFX_CRAFT)
				-- If there's a selected craft item and it has at least one ingredient
				local player = Players.LocalPlayer
				print(selectedCraftItem.name)
				if selectedCraftItem then
					CheckCraftingIngredientsEvent:SendToServer(player, selectedCraftItem.name, selectedCraftItem.ingredients)
				end
				-- Send FAIL SFX Here
				SoundSystemController:playSound(SoundKeys.SFX_FAIL)
			end,
		})
		_condition = (Roact.createElement("Frame", _attributes_4, _children_4))
	end
	if _condition then
		_children_2[_length_2 + 2] = _condition
	end
	_length_2 = #_children_2
	_children_2[_length_2 + 1] = Roact.createElement(Close)
	_children_1.Crafting = Roact.createElement("Frame", _attributes_2, _children_2)
	_children[_length + 1] = Roact.createElement("Frame", _attributes_1, _children_1)
	return Roact.createFragment({
		Craft = Roact.createElement(Panel, _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Crafting)
return {
	default = default,
}
