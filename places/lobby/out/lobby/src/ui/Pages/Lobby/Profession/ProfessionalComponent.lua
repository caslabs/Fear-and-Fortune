-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
-- // Generic item component that gets reused in all of the pages
local ProfessionComponent = function(props, _param)
	local useState = _param.useState
	local promptVisible, setPromptVisible = useState(false)
	local _attributes = {
		Text = "",
		BackgroundColor3 = if props.active then Color3.fromRGB(235, 79, 18) else Color3.fromRGB(107, 105, 105),
	}
	local _condition = props.layoutOrder
	if _condition == nil then
		_condition = 1
	end
	_attributes.LayoutOrder = _condition
	_attributes[Roact.Event.MouseEnter] = function()
		return setPromptVisible(true)
	end
	_attributes[Roact.Event.MouseButton1Click] = function()
		-- TODO: Make a System - also 7 second audio with stop between clicks
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://" .. tostring(props.audio)
		sound.Parent = game:GetService("SoundService")
		sound.Volume = 0.5
		sound:Play()
		props.onClick()
	end
	_attributes[Roact.Event.MouseLeave] = function()
		return setPromptVisible(false)
	end
	local _children = {
		Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
		}),
		Title = Roact.createElement("TextLabel", {
			Text = props.title,
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundTransparency = 0.9,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 24,
			AutomaticSize = "Y",
			TextWrapped = true,
		}),
	}
	local _length = #_children
	local _attributes_1 = {
		Size = UDim2.new(1, 0, 1, -74),
	}
	local _condition_1 = props.desc
	if _condition_1 == nil then
		_condition_1 = ""
	end
	_attributes_1.Text = _condition_1
	_attributes_1.Position = UDim2.fromScale(0, 0.5)
	_attributes_1.AnchorPoint = Vector2.new(0, 0.5)
	_attributes_1.BorderSizePixel = 0
	_attributes_1.BackgroundTransparency = 1
	_attributes_1.TextColor3 = Color3.fromRGB(255, 255, 255)
	_attributes_1.TextSize = 18
	_attributes_1.TextWrapped = true
	_attributes_1.Visible = promptVisible
	_attributes_1.AutomaticSize = "Y"
	_children.Desc = Roact.createElement("TextLabel", _attributes_1)
	return Roact.createFragment({
		Item = Roact.createElement("TextButton", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(ProfessionComponent)
return {
	default = default,
}
