-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local StarterGui = _services.StarterGui
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local PlayerItem = TS.import(script, script.Parent, "playerItem").default
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
local PartyPlayer
do
	PartyPlayer = setmetatable({}, {
		__tostring = function()
			return "PartyPlayer"
		end,
	})
	PartyPlayer.__index = PartyPlayer
	function PartyPlayer.new(...)
		local self = setmetatable({}, PartyPlayer)
		return self:constructor(...) or self
	end
	function PartyPlayer:constructor(userId, role)
		self.userId = userId
		self.role = role
	end
end
local function getPlayerfromUserId(userId)
	local userIdNumber = tonumber(userId)
	if userIdNumber ~= nil then
		return Players:GetPlayerByUserId(userIdNumber) or nil
	else
		return nil
	end
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
local player = Players.LocalPlayer
local PartyUpdateEvent = Remotes.Client:Get("PartyUpdate")
local InvitePlayerToPartyEvent = Remotes.Client:Get("InvitePlayerToParty")
local OnPlayerInvitedToPartyEvent = Remotes.Client:Get("OnPlayerInvitedToParty")
local RespondToPartyInvitationEvent = Remotes.Client:Get("RespondToPartyInvitation")
local SendPartyMemberofClassEvent = Remotes.Client:Get("SendPartyMemberofClassEvent")
local PlayerProfessionUpdateEvent = Remotes.Client:Get("PlayerProfessionUpdate")
OnPlayerInvitedToPartyEvent:Connect(function(invitedPlayer, invitingPlayer)
	print("Received invitation from " .. invitingPlayer.Name)
	local responseFunc = Instance.new("BindableFunction")
	responseFunc.OnInvoke = function(choice)
		RespondToPartyInvitationEvent:SendToServer(invitedPlayer.UserId, invitingPlayer.UserId, choice == "Accept")
		print("Calling RespondToPartyInvitationEvent")
	end
	StarterGui:SetCore("SendNotification", {
		Title = "Party Invitation",
		Text = invitingPlayer.Name .. " has sent an invite!",
		Button1 = "Accept",
		Button2 = "Decline",
		Duration = 10,
		Callback = responseFunc,
	})
end)
local Party = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local invite, setInvite = useState("Invite")
	local partyMembers, setPartyMembers = useState({})
	local partySize, setPartySize = useState(1)
	local players, setPlayers = useState(function()
		local _exp = Players:GetPlayers()
		local _arg0 = function(p)
			return p ~= Players.LocalPlayer
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(_exp) do
			if _arg0(_v, _k - 1, _exp) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		return _newValue
	end)
	local playerProfession, setPlayerProfession = useState("Mountaineer")
	local playerProfessions, setPlayerProfessions = useState({})
	local partyName, setPartyName = useState("The Nameless Party")
	local textboxRef = Roact.createRef()
	local isHost, setIsHost = useState(true)
	useEffect(function()
		local onPlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
			if player ~= Players.LocalPlayer then
				setPlayers(function(prevPlayers)
					local _array = {}
					local _length = #_array
					local _prevPlayersLength = #prevPlayers
					table.move(prevPlayers, 1, _prevPlayersLength, _length + 1, _array)
					_length += _prevPlayersLength
					_array[_length + 1] = player
					return _array
				end)
			end
		end)
		local onPlayerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
			setPlayers(function(prevPlayers)
				local _arg0 = function(p)
					return p ~= player
				end
				-- ▼ ReadonlyArray.filter ▼
				local _newValue = {}
				local _length = 0
				for _k, _v in ipairs(prevPlayers) do
					if _arg0(_v, _k - 1, prevPlayers) == true then
						_length += 1
						_newValue[_length] = _v
					end
				end
				-- ▲ ReadonlyArray.filter ▲
				return _newValue
			end)
		end)
		-- Ensure that the TextBox instance is available
		local textboxInstance = textboxRef:getValue()
		if textboxInstance then
			textboxInstance.FocusLost:Connect(function()
				if textboxInstance.Text == "" then
					textboxInstance.Text = "The Nameless Party"
				end
			end)
		end
		-- Cleanup function
		return function()
			onPlayerAddedConnection:Disconnect()
			onPlayerRemovingConnection:Disconnect()
		end
	end, {})
	useEffect(function()
		local onPlayerProfessionUpdateEvent = PlayerProfessionUpdateEvent:Connect(function(profession)
			setPlayerProfession(profession)
		end)
		return function()
			onPlayerProfessionUpdateEvent:Disconnect()
		end
	end, {})
	useEffect(function()
		local onPartyUpdate = PartyUpdateEvent:Connect(function(hostId, memberIds)
			local hostPlayer = PartyPlayer.new(hostId, "host")
			local updatedPartyMembers = { hostPlayer }
			for _, id in ipairs(memberIds) do
				if tostring(id) ~= hostId then
					local memberPlayer = PartyPlayer.new(tostring(id), "member")
					table.insert(updatedPartyMembers, memberPlayer)
				end
			end
			print("updatedPartyMembers", updatedPartyMembers)
			setPartyMembers(updatedPartyMembers)
			setPartySize(#updatedPartyMembers)
		end)
		return function()
			onPartyUpdate:Disconnect()
		end
	end, {})
	useEffect(function()
		local onSendPartyMemberofClassEvent = SendPartyMemberofClassEvent:Connect(function(members, profession)
			setPlayerProfessions(function(oldProfessions)
				local newProfessions = {}
				for key, value in pairs(oldProfessions) do
					newProfessions[key] = value
				end
				-- Iterate over each member and set their profession
				local _arg0 = function(member)
					local _arg0_1 = tostring(member.UserId)
					newProfessions[_arg0_1] = profession
				end
				for _k, _v in ipairs(members) do
					_arg0(_v, _k - 1, members)
				end
				return newProfessions
			end)
		end)
		return function()
			onSendPartyMemberofClassEvent:Disconnect()
		end
	end, {})
	useEffect(function()
		local connection = PartyUpdateEvent:Connect(function(hostId, memberIds)
			local currentPlayerId = tostring(Players.LocalPlayer.UserId)
			if currentPlayerId == hostId then
				setIsHost(true)
			else
				setIsHost(false)
			end
		end)
		return function()
			return connection:Disconnect()
		end
	end, {})
	local _attributes = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = props.visible == "party",
	}
	local _children = {
		PartyContent = Roact.createElement("Frame", {
			Size = UDim2.new(0.7, 0, 1, 0),
			BackgroundTransparency = 1,
		}, {
			Roact.createElement("TextLabel", {
				Text = "Your Party: " .. partyName,
				Size = UDim2.fromScale(0.6, 0.1),
				TextSize = 15,
				Position = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.SourceSansBold,
				TextColor3 = Color3.fromRGB(200, 200, 200),
			}),
			Roact.createElement("TextBox", {
				Text = partyName,
				Size = UDim2.fromScale(0.2, 0.12),
				Position = UDim2.fromScale(0.6, 0),
				TextSize = 12,
				Font = Enum.Font.SourceSansBold,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				BackgroundTransparency = 0.5,
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				ClearTextOnFocus = true,
				[Roact.Ref] = textboxRef,
				TextWrapped = true,
			}),
			Roact.createElement("TextButton", {
				Text = "Set Name",
				Size = UDim2.fromScale(0.15, 0.12),
				Position = UDim2.fromScale(0.8, 0),
				TextSize = 15,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Font = Enum.Font.SourceSansBold,
				BackgroundColor3 = Color3.fromRGB(128, 128, 128),
				[Roact.Event.MouseButton1Click] = function()
					local _textBoxValue = textboxRef:getValue()
					if _textBoxValue ~= nil then
						_textBoxValue = _textBoxValue.Text
					end
					local textBoxValue = _textBoxValue
					if textBoxValue ~= nil and (textBoxValue ~= nil and textBoxValue ~= "") then
						setPartyName(textBoxValue)
						-- Add your code here to update the party name in your application state
					end
				end,
			}),
			Roact.createElement("TextLabel", {
				Text = tostring(partySize) .. "/7 members",
				Size = UDim2.fromScale(1, 0.1),
				Position = UDim2.fromScale(0, 0.12),
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(200, 200, 200),
			}),
			Roact.createElement("TextButton", {
				Text = "Invite a player to form a party",
				Size = UDim2.fromScale(1, 0.1),
				TextSize = 15,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Position = UDim2.fromScale(0, 0.9),
				Font = Enum.Font.SourceSansBold,
				BackgroundColor3 = Color3.fromRGB(128, 128, 128),
			}),
		}),
	}
	local _length = #_children
	local _arg0 = function(player)
		local _arg0_1 = function(partyMember)
			return partyMember.userId == tostring(player.UserId)
		end
		-- ▼ ReadonlyArray.some ▼
		local _result = false
		for _k, _v in ipairs(partyMembers) do
			if _arg0_1(_v, _k - 1, partyMembers) then
				_result = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		return not _result
	end
	-- ▼ ReadonlyArray.filter ▼
	local _newValue = {}
	local _length_1 = 0
	for _k, _v in ipairs(players) do
		if _arg0(_v, _k - 1, players) == true then
			_length_1 += 1
			_newValue[_length_1] = _v
		end
	end
	-- ▲ ReadonlyArray.filter ▲
	local _arg0_1 = function(player, index)
		return Roact.createElement(PlayerItem, {
			name = player.Name,
			player = player,
			isHost = isHost,
		})
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue_1 = table.create(#_newValue)
	for _k, _v in ipairs(_newValue) do
		_newValue_1[_k] = _arg0_1(_v, _k - 1, _newValue)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_1 = {
		Size = UDim2.new(0.3, 0, 0.9, 0),
		Position = UDim2.fromScale(0.7, 0),
		CanvasSize = UDim2.fromScale(0.3, #players * 0.1),
		BackgroundTransparency = 1,
	}
	local _children_1 = {
		Roact.createElement("UIListLayout", {
			FillDirection = "Vertical",
			SortOrder = "LayoutOrder",
			Padding = UDim.new(0, 10),
		}),
	}
	local _length_2 = #_children_1
	for _k, _v in ipairs(_newValue_1) do
		_children_1[_length_2 + _k] = _v
	end
	_children.PlayerList = Roact.createElement("ScrollingFrame", _attributes_1, _children_1)
	local _arg0_2 = function(partyMember)
		return getPlayerfromUserId(partyMember.userId) ~= nil
	end
	-- ▼ ReadonlyArray.filter ▼
	local _newValue_2 = {}
	local _length_3 = 0
	for _k, _v in ipairs(partyMembers) do
		if _arg0_2(_v, _k - 1, partyMembers) == true then
			_length_3 += 1
			_newValue_2[_length_3] = _v
		end
	end
	-- ▲ ReadonlyArray.filter ▲
	local _arg0_3 = function(partyMember, index)
		local _attributes_2 = {
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundTransparency = 1,
		}
		local _children_2 = {}
		local _length_4 = #_children_2
		local _attributes_3 = {}
		local _result = getPlayerfromUserId(partyMember.userId)
		if _result ~= nil then
			_result = _result.Name
		end
		_attributes_3.Text = tostring(_result) .. (if partyMember.userId == tostring(Players.LocalPlayer.UserId) then " (You)" else "") .. " " .. partyMember.role
		_attributes_3.Size = UDim2.fromScale(0.7, 1)
		_attributes_3.TextColor3 = Color3.fromRGB(200, 200, 200)
		_attributes_3.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		_children_2[_length_4 + 1] = Roact.createElement("TextLabel", _attributes_3)
		return Roact.createFragment({
			[partyMember.userId] = Roact.createElement("Frame", _attributes_2, _children_2),
		})
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue_3 = table.create(#_newValue_2)
	for _k, _v in ipairs(_newValue_2) do
		_newValue_3[_k] = _arg0_3(_v, _k - 1, _newValue_2)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_2 = {
		Size = UDim2.new(0.2, 0, 1, 0),
		Position = UDim2.fromScale(0, 0.1),
		CanvasSize = UDim2.fromScale(0.3, #partyMembers * 0.1),
		BackgroundTransparency = 1,
	}
	local _children_2 = {
		Roact.createElement("UIListLayout", {
			FillDirection = "Vertical",
			SortOrder = "LayoutOrder",
			Padding = UDim.new(0, 10),
		}),
	}
	local _length_4 = #_children_2
	for _k, _v in ipairs(_newValue_3) do
		_children_2[_length_4 + _k] = _v
	end
	_children.PartyList = Roact.createElement("ScrollingFrame", _attributes_2, _children_2)
	return Roact.createFragment({
		Party = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Party)
return {
	default = default,
}
