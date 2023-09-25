-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local ProfessionItem = TS.import(script, script.Parent.Parent.Parent.Parent, "components", "Items", "ProfessionItem").default
local PlayerClass
do
	local _inverse = {}
	PlayerClass = setmetatable({}, {
		__index = _inverse,
	})
	PlayerClass.Mountaineer = 0
	_inverse[0] = "Mountaineer"
	PlayerClass.Soldier = 1
	_inverse[1] = "Soldier"
	PlayerClass.Engineer = 2
	_inverse[2] = "Engineer"
	PlayerClass.Doctor = 3
	_inverse[3] = "Doctor"
	PlayerClass.Scholar = 4
	_inverse[4] = "Scholar"
	PlayerClass.Cameraman = 5
	_inverse[5] = "Cameraman"
end
local function PlayerClassToString(playerClass)
	repeat
		if playerClass == (PlayerClass.Mountaineer) then
			return "Mountaineer"
		end
		if playerClass == (PlayerClass.Soldier) then
			return "Soldier"
		end
		if playerClass == (PlayerClass.Engineer) then
			return "Engineer"
		end
		if playerClass == (PlayerClass.Doctor) then
			return "Doctor"
		end
		if playerClass == (PlayerClass.Scholar) then
			return "Scholar"
		end
		if playerClass == (PlayerClass.Cameraman) then
			return "Cameraman"
		end
	until true
end
local function StringToPlayerClass(playerClass)
	repeat
		if playerClass == "Mountaineer" then
			return PlayerClass.Mountaineer
		end
		if playerClass == "Soldier" then
			return PlayerClass.Soldier
		end
		if playerClass == "Engineer" then
			return PlayerClass.Engineer
		end
		if playerClass == "Doctor" then
			return PlayerClass.Doctor
		end
		if playerClass == "Scholar" then
			return PlayerClass.Scholar
		end
		if playerClass == "Cameraman" then
			return PlayerClass.Cameraman
		end
	until true
end
local RequestUpdateProfessionEvent = Remotes.Client:Get("RequestProfessionUpdate")
local RequestSendPartyMemberofClassEvent = Remotes.Client:Get("RequestPartyMemberofClassEvent")
local Profession = function(props, _param)
	local useState = _param.useState
	local selectedProfessionItem, setSelectedProfessionItem = useState(props.data[1])
	local _attributes = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = props.visible == "profession",
	}
	local _children = {}
	local _length = #_children
	local _attributes_1 = {
		Size = UDim2.fromScale(1, 0.4),
		Position = UDim2.fromScale(0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
	}
	local _children_1 = {}
	local _length_1 = #_children_1
	local _data = props.data
	local _arg0 = function(info, index)
		return Roact.createFragment({
			[info.name] = Roact.createElement(ProfessionItem, {
				title = info.name,
				desc = "",
				color = if info.isLocked then Color3.fromRGB(128, 128, 128) else info.color,
				layoutOrder = index,
				active = selectedProfessionItem == info,
				isLocked = info.isLocked,
				onClick = function()
					setSelectedProfessionItem(info)
					RequestUpdateProfessionEvent:SendToServer(info.name)
					--[[
						SendPartyMemberofClassEvent.SendToServer(info.name);
						//TODO: interesting, doesn't show if true but be interesting to use for other mechanics
						/*
						if (!info.isLocked) {
						setSelectedProfessionItem(info); // Set this item as active
						}
					]]
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
	local _attributes_2 = {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 3,
		AutomaticCanvasSize = "X",
	}
	local _children_2 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromScale(0.03, 0),
			CellSize = UDim2.fromScale(0.3, 0.5),
		}),
	}
	local _length_2 = #_children_2
	for _k, _v in ipairs(_newValue) do
		_children_2[_length_2 + _k] = _v
	end
	_children_1[_length_1 + 1] = Roact.createElement("ScrollingFrame", _attributes_2, _children_2)
	_children[_length + 1] = Roact.createElement("Frame", _attributes_1, _children_1)
	local _child = selectedProfessionItem and (Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 0.6),
		Position = UDim2.fromScale(0, 0.4),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
	}, {
		Roact.createElement("TextLabel", {
			Text = selectedProfessionItem.name,
			Size = UDim2.fromScale(1, 0.2),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(230, 230, 230),
			FontSize = Enum.FontSize.Size24,
		}),
		Roact.createElement("TextLabel", {
			Text = selectedProfessionItem.desc,
			Position = UDim2.fromScale(0, 0.2),
			Size = UDim2.fromScale(1, 0.6),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Font = Enum.Font.Gotham,
			FontSize = Enum.FontSize.Size14,
			RichText = true,
			TextWrapped = true,
			TextColor3 = Color3.fromRGB(230, 230, 230),
		}),
		Roact.createElement("TextButton", {
			Text = if selectedProfessionItem == props.data[1] then "CURRENT" elseif selectedProfessionItem.isLocked then "LOCKED" else "CHOOSE PROFESSION",
			Size = UDim2.fromScale(1, 0.2),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(200, 200, 200),
			BackgroundColor3 = if selectedProfessionItem == props.data[1] then Color3.fromRGB(75, 75, 75) elseif selectedProfessionItem.isLocked then Color3.fromRGB(128, 128, 128) else Color3.fromRGB(45, 45, 45),
		}),
	}))
	if _child then
		_children[_length + 2] = _child
	end
	return Roact.createFragment({
		Profession = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Profession)
return {
	default = default,
}
