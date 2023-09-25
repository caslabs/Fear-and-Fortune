-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Theme = TS.import(script, script.Parent.Parent, "theme").default
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local UserInputService = _services.UserInputService
local ContextHotbarMenu = TS.import(script, script.Parent, "context-hotbar-menu").default
-- HotBarInventoryItem.ts
local HotBarInventoryItem = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local highlighted, setHighlighted = useState(false)
	-- Inside the HotBarInventoryItem component
	local contextMenuVisible, setContextMenuVisible = useState(false)
	local contextMenuPosition, setContextMenuPosition = useState(UDim2.fromScale(0, 0))
	-- Add useEffect hook to listen for tab key press
	useEffect(function()
		local connection = UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Tab then
				setContextMenuVisible(false)
			end
		end)
		return function()
			return connection:Disconnect()
		end
	end, {})
	local _attributes = {
		Size = UDim2.fromScale(1, 1),
	}
	local _children = {}
	local _length = #_children
	local _condition = highlighted
	if _condition then
		local _attributes_1 = {}
		local _condition_1 = props.desc
		if _condition_1 == nil then
			_condition_1 = ""
		end
		_attributes_1.Text = _condition_1
		_attributes_1.BackgroundTransparency = 1
		_attributes_1.TextColor3 = Color3.fromRGB(255, 255, 255)
		_attributes_1.Font = Theme.FontNormal
		_attributes_1.TextSize = 18
		_attributes_1.AutomaticSize = "Y"
		_attributes_1.TextWrapped = true
		_condition = (Roact.createElement("TextLabel", _attributes_1))
	end
	local _attributes_1 = {
		Size = UDim2.fromScale(1, 1),
		Text = props.name,
		TextColor3 = Color3.fromRGB(222, 222, 222),
		BackgroundColor3 = if highlighted then props.color or Color3.fromRGB(26, 26, 26) else Color3.fromRGB(60, 60, 60),
		[Roact.Event.MouseEnter] = function()
			return setHighlighted(true)
		end,
		[Roact.Event.MouseLeave] = function()
			return setHighlighted(false)
		end,
		[Roact.Event.MouseButton2Click] = function(rbx)
			local mouse = Players.LocalPlayer:GetMouse()
			local guiObject = rbx
			local panelPosition = guiObject.AbsolutePosition
			local position = UDim2.new(0, mouse.X - panelPosition.X, 0, mouse.Y - panelPosition.Y)
			setContextMenuPosition(position)
			setContextMenuVisible(true)
		end,
		LayoutOrder = props.LayoutOrder,
		TextScaled = true,
	}
	local _children_1 = {
		Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
		}),
	}
	local _length_1 = #_children_1
	if _condition then
		_children_1[_length_1 + 1] = _condition
	end
	_length_1 = #_children_1
	_children_1[_length_1 + 1] = Roact.createElement(ContextHotbarMenu, {
		visible = contextMenuVisible,
		position = contextMenuPosition,
		onClose = function()
			return setContextMenuVisible(false)
		end,
		item = props.name,
	})
	_children[props.name] = Roact.createElement("TextButton", _attributes_1, _children_1)
	local _child = contextMenuVisible and (Roact.createElement("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		[Roact.Event.MouseButton1Click] = function()
			return setContextMenuVisible(false)
		end,
	}))
	if _child then
		_children[_length + 1] = _child
	end
	return Roact.createElement("Frame", _attributes, _children)
end
local default = Hooks.new(Roact)(HotBarInventoryItem)
return {
	default = default,
}
