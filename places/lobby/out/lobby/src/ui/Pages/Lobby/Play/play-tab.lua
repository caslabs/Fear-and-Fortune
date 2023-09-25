-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local Workspace = _services.Workspace
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local _signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals")
local QueueState = _signals.QueueState
local Signals = _signals.Signals
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local InventoryItem = TS.import(script, script.Parent, "inventory-component").default
local EmptyInventoryItem = TS.import(script, script.Parent, "empty-inventory-component").default
local CraftItem = TS.import(script, script.Parent.Parent.Parent.Parent, "components", "Items", "CraftItem").default
local Section = TS.import(script, script.Parent, "section").default
local VerticalFeature = TS.import(script, script.Parent, "verticalfeature").default
local Footer = TS.import(script, script.Parent, "footer").default
local JoinMatchEvent = Remotes.Client:Get("JoinMatch")
local LeaveMatchEvent = Remotes.Client:Get("LeaveMatch")
local UpdatePlayerCountEvent = Remotes.Client:Get("UpdatePlayerCount")
local UpdateQueueMembersEvent = Remotes.Client:Get("UpdateQueueMembers")
local PartyUpdateEvent = Remotes.Client:Get("PartyUpdate")
local GetHumanoidDescriptionFromUserIdEvent = Remotes.Client:Get("GetHumanoidDescriptionFromUserId")
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
local UpdateInventoryEvent = Remotes.Client:Get("UpdateInventory")
local emptyInventoryItem = {
	name = "",
	quantity = 0,
	desc = "",
}
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
-- For members of the party
local EnterQueueEvent = Remotes.Client:Get("EnterQueue")
local ExitQueueEvent = Remotes.Client:Get("ExitQueue")
local RequestQueueEvent = Remotes.Client:Get("RequestQueue")
EnterQueueEvent:Connect(function()
	SoundSystemController:playSound(SoundKeys.UI_QUEUE_ENTER, 2)
	Signals.queueStateChangedSignal:Fire(QueueState.Searching)
	JoinMatchEvent:SendToServer()
end)
ExitQueueEvent:Connect(function()
	SoundSystemController:playSound(SoundKeys.UI_QUEUE_EXIT, 2)
	Signals.queueStateChangedSignal:Fire(QueueState.Idle)
	LeaveMatchEvent:SendToServer()
end)
local function CloneMe(char)
	-- a function that clones a player
	char.Archivable = true
	local clone = char:Clone()
	char.Archivable = false
	print("Character cloned")
	return clone
end
local GetPlayerEvent = Remotes.Client:Get("GetPlayer")
GetPlayerEvent:SendToServer()
local Lobby = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local playState, setPlayState = useState("play")
	local selectedTab, setSelectedTab = useState("play")
	local playerCount, setPlayerCount = useState(0)
	local QueueMembers, setQueueMembers = useState({})
	local backpackData, setBackpackData = useState({})
	local playerClasses, setPlayerClasses = useState({})
	local isHost, setIsHost = useState(true)
	local partyMembers, setPartyMembers = useState({})
	local partySize, setPartySize = useState(1)
	local selectedCraftItem, setSelectedCraftItem = useState(props.data[1])
	local activeCraftItem, setActiveCraftItem = useState(props.data[1].name)
	local camera = Instance.new("Camera")
	camera.FieldOfView = 13.055
	local CameraRef = Roact.createRef()
	local ViewportRef = Roact.createRef()
	local luffy = Workspace:WaitForChild("Luffy")
	local char = luffy:Clone()
	camera.FieldOfView = 13.055
	useEffect(function()
		local viewport = ViewportRef:getValue()
		char.Parent = viewport
		camera.Parent = viewport
		viewport.CurrentCamera = camera
		char.Name = "curChar"
		local char_humanoid = char:WaitForChild("Humanoid")
		print("char_humanoid", char_humanoid)
		-- Get the positions
		local cameraPos = camera.CFrame.Position
		local charPos = char.PrimaryPart.Position
		-- Create new CFrame for the character, facing the camera
		local characterCFrame = CFrame.new(charPos, cameraPos)
		local _arg0 = CFrame.Angles(0, math.pi, 0)
		char.PrimaryPart.CFrame = characterCFrame * _arg0
	end)
	useEffect(function()
		local connection = UpdatePlayerCountEvent:Connect(function(queuedPlayerCount)
			setPlayerCount(queuedPlayerCount)
		end)
		return function()
			return connection:Disconnect()
		end
	end, {})
	local _array = {}
	local _length = #_array
	table.move(backpackData, 1, #backpackData, _length + 1, _array)
	local filledBackpackArray = _array
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
	local _array_1 = {}
	local _length_1 = #_array_1
	table.move(backpackData, 1, #backpackData, _length_1 + 1, _array_1)
	local filledBackpack2Array = _array_1
	do
		local i = #backpackData
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < 5) then
				break
			end
			table.insert(filledBackpack2Array, emptyInventoryItem)
		end
	end
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
	table.sort(filledBackpackArray, sortInventory)
	filledBackpackArray = filledBackpackArray
	table.sort(filledBackpack2Array, sortInventory)
	filledBackpack2Array = filledBackpack2Array
	local playStateRef = Roact.createRef()
	local gridImageComponentRef = Roact.createRef()
	local _attributes = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = props.visible == "play",
	}
	local _children = {
		TabButtons = Roact.createElement("Frame", {
			Size = UDim2.new(0.2, 0, 0.3, 0),
			Position = UDim2.fromScale(0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(0, 0, 0),
		}, {
			PlayTabButton = Roact.createElement("TextButton", {
				Text = "Expedition",
				TextSize = 13,
				Font = "GothamBold",
				Size = UDim2.fromScale(1, 0.35),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				[Roact.Event.MouseButton1Click] = function()
					return setSelectedTab("play")
				end,
				BackgroundColor3 = if selectedTab == "play" then Color3.fromRGB(128, 128, 128) else Color3.fromRGB(45, 45, 45),
			}),
			HuntTabButton = Roact.createElement("TextButton", {
				Text = "Hunt",
				Font = "GothamBold",
				TextSize = 13,
				Size = UDim2.fromScale(1, 0.35),
				Position = UDim2.fromScale(1.1, 0),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				[Roact.Event.MouseButton1Click] = function()
					return setSelectedTab("hunt")
				end,
				BackgroundColor3 = if selectedTab == "hunt" then Color3.fromRGB(128, 128, 128) else Color3.fromRGB(45, 45, 45),
			}),
			PatchNotes = Roact.createElement("TextButton", {
				Text = "Patch Notes",
				Font = "GothamBold",
				TextSize = 13,
				Size = UDim2.fromScale(1, 0.35),
				Position = UDim2.fromScale(2.2, 0),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				[Roact.Event.MouseButton1Click] = function()
					return setSelectedTab("patchNotes")
				end,
				BackgroundColor3 = if selectedTab == "patchNotes" then Color3.fromRGB(128, 128, 128) else Color3.fromRGB(45, 45, 45),
			}),
		}),
	}
	local _length_2 = #_children
	local _attributes_1 = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0.12),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = selectedTab == "play",
	}
	local _children_1 = {
		Roact.createElement("TextLabel", {
			Text = "Expedition No.1924",
			Size = UDim2.fromScale(0.9, 0.05),
			Position = UDim2.fromScale(0, 0.05),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			Font = "SpecialElite",
			TextScaled = true,
			FontSize = Enum.FontSize.Size24,
			TextColor3 = Color3.fromRGB(150, 150, 150),
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = false,
		}),
	}
	local _length_3 = #_children_1
	local _filledBackpackArray = filledBackpackArray
	local _arg0 = function(item, index)
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
	local _newValue = table.create(#_filledBackpackArray)
	for _k, _v in ipairs(_filledBackpackArray) do
		_newValue[_k] = _arg0(_v, _k - 1, _filledBackpackArray)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_2 = {
		Size = UDim2.fromScale(0.45, 0.64),
		Position = UDim2.fromScale(1, 0.05),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
		AnchorPoint = Vector2.new(1, 0),
	}
	local _children_2 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromScale(0.2, 0.1),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	local _length_4 = #_children_2
	for _k, _v in ipairs(_newValue) do
		_children_2[_length_4 + _k] = _v
	end
	_children_1[_length_3 + 1] = Roact.createElement("ScrollingFrame", _attributes_2, _children_2)
	_children_1.BodyImage = Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(211, 245, 230),
		Position = UDim2.fromScale(-0.02, 0.05),
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.fromScale(0.5, 0.5),
		BorderSizePixel = 0,
	}, {
		Roact.createElement("ViewportFrame", {
			Size = UDim2.new(0.9, 0, 0.9, 0),
			Position = UDim2.new(0, 15, 0, 13),
			BackgroundColor3 = Color3.fromRGB(255, 255, 204),
			BorderColor3 = Color3.fromRGB(170, 150, 127),
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			CurrentCamera = CameraRef,
			[Roact.Ref] = ViewportRef,
		}, {
			OverlayVintage = Roact.createElement("Frame", {
				BackgroundTransparency = 0.7,
				BackgroundColor3 = Color3.fromRGB(158, 135, 59),
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.fromScale(1, 1),
				BorderSizePixel = 0,
			}),
		}),
	})
	local _filledBackpack2Array = filledBackpack2Array
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
	local _newValue_1 = table.create(#_filledBackpack2Array)
	for _k, _v in ipairs(_filledBackpack2Array) do
		_newValue_1[_k] = _arg0_1(_v, _k - 1, _filledBackpack2Array)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_3 = {
		Size = UDim2.fromScale(0.5, 0.1),
		Position = UDim2.fromScale(0.52, 0.68),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
		AnchorPoint = Vector2.new(1, 1),
	}
	local _children_3 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(6, 6),
			CellSize = UDim2.fromScale(0.15, 0.05),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	local _length_5 = #_children_3
	for _k, _v in ipairs(_newValue_1) do
		_children_3[_length_5 + _k] = _v
	end
	_children_1[_length_3 + 2] = Roact.createElement("ScrollingFrame", _attributes_3, _children_3)
	_children_1[_length_3 + 3] = Roact.createElement("TextButton", {
		Text = if isHost then playState else "HOST ONLY",
		Size = UDim2.fromScale(0.3, 0.1),
		BackgroundColor3 = Color3.fromRGB(75, 75, 75),
		Position = UDim2.fromScale(0.5, 0.8),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = Color3.fromRGB(200, 200, 200),
		[Roact.Ref] = playStateRef,
		[Roact.Event.MouseButton1Click] = function()
			if not isHost then
				return nil
			end
			if playState == "play" then
				-- If the player is in a party, let everyone in party also enter the queue
				if partySize > 1 then
					local allPartyMembers = {}
					for _, partyMember in ipairs(partyMembers) do
						if partyMember.userId == nil then
							return nil
						end
						if partyMember.userId ~= tostring(Players.LocalPlayer.UserId) and partyMember.role == "member" then
							local memberId = tonumber(partyMember.userId)
							if memberId ~= nil then
								table.insert(allPartyMembers, memberId)
							end
						end
						RequestQueueEvent:SendToServer(allPartyMembers, "ENTER_QUEUE")
					end
				end
				setPlayState("awaiting expedition")
				SoundSystemController:playSound(SoundKeys.UI_QUEUE_ENTER, 2)
				Signals.queueStateChangedSignal:Fire(QueueState.Searching)
				JoinMatchEvent:SendToServer()
			elseif playState == "cancel expedition?" then
				if partySize > 1 then
					local allPartyMembers = {}
					for _, partyMember in ipairs(partyMembers) do
						if partyMember.userId == nil then
							return nil
						end
						if partyMember.userId ~= tostring(Players.LocalPlayer.UserId) and partyMember.role == "member" then
							local memberId = tonumber(partyMember.userId)
							if memberId ~= nil then
								table.insert(allPartyMembers, memberId)
							end
						end
						RequestQueueEvent:SendToServer(allPartyMembers, "EXIT_QUEUE")
					end
				end
				SoundSystemController:playSound(SoundKeys.UI_QUEUE_EXIT, 2)
				setPlayState("play")
				Signals.queueStateChangedSignal:Fire(QueueState.Idle)
				LeaveMatchEvent:SendToServer()
			end
		end,
		[Roact.Event.MouseEnter] = function()
			if not isHost then
				return nil
			end
			if playState == "awaiting expedition" then
				setPlayState("cancel expedition?")
			end
		end,
		[Roact.Event.MouseLeave] = function()
			if not isHost then
				return nil
			end
			if playState == "cancel expedition?" then
				setPlayState("awaiting expedition")
			elseif playState == "play" then
				setPlayState("play")
			end
		end,
	})
	_children.Play = Roact.createElement("Frame", _attributes_1, _children_1)
	local _attributes_4 = {
		Size = UDim2.fromScale(1, 0.9),
		Position = UDim2.fromScale(0, 0.12),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = selectedTab == "hunt",
	}
	local _children_4 = {}
	local _length_6 = #_children_4
	local _data = props.data
	local _arg0_2 = function(info, index)
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
	local _newValue_2 = table.create(#_data)
	for _k, _v in ipairs(_data) do
		_newValue_2[_k] = _arg0_2(_v, _k - 1, _data)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_5 = {
		Size = UDim2.fromScale(0.27, 1),
		Position = UDim2.fromScale(0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 3,
		AutomaticCanvasSize = "Y",
	}
	local _children_5 = {
		Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromScale(0, 0.03),
			CellSize = UDim2.fromScale(1, 0.2),
		}),
	}
	local _length_7 = #_children_5
	for _k, _v in ipairs(_newValue_2) do
		_children_5[_length_7 + _k] = _v
	end
	_children_4[_length_6 + 1] = Roact.createElement("ScrollingFrame", _attributes_5, _children_5)
	local _child = selectedCraftItem and (Roact.createElement("Frame", {
		Size = UDim2.fromScale(0.7, 1),
		Position = UDim2.fromScale(0.3, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
	}, {
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
		Roact.createElement("TextButton", {
			Text = "HUNT",
			Size = UDim2.fromScale(1, 0.2),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(200, 200, 200),
			BackgroundColor3 = Color3.fromRGB(75, 75, 75),
		}),
	}))
	if _child then
		_children_4[_length_6 + 2] = _child
	end
	_children.Hunt = Roact.createElement("Frame", _attributes_4, _children_4)
	_children.patchNotes = Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 0.9),
		Position = UDim2.fromScale(0, 0.12),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = selectedTab == "patchNotes",
	}, {
		ScrollingFrame = Roact.createElement("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScrollBarThickness = 6,
			AutomaticCanvasSize = "Y",
			CanvasSize = UDim2.fromScale(0, 7),
		}, {
			Roact.createElement("UIListLayout", {
				SortOrder = "LayoutOrder",
				HorizontalAlignment = "Center",
				FillDirection = "Vertical",
			}),
			Roact.createElement(Section, {
				title = "Fear and Fortune",
				description = "🎉 Alpha Launch 🎉",
				LayoutOrder = 0,
			}, {
				Roact.createElement(VerticalFeature, {
					title = "Version 1.0.0",
					LayoutOrder = 3,
					fontsize = 25,
					yalign = "Bottom",
				}),
				Roact.createElement(VerticalFeature, {
					title = "Procedure Generated Maps",
					LayoutOrder = 4,
				}),
				["5.5"] = Roact.createElement("ImageLabel", {
					Size = UDim2.fromScale(0.8, 0.5),
					BackgroundTransparency = 1,
					Image = "rbxassetid://11407592028",
					LayoutOrder = 5,
				}),
				Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.8, 0.3),
					Text = "We want players to explore the ice cold wastelands of Fear and Fortune. Every game session will curate a different experience.",
					Font = Enum.Font.GothamBold,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 15,
					LayoutOrder = 6,
					RichText = true,
					TextWrapped = true,
				}),
				Roact.createElement(VerticalFeature, {
					title = "Hunting System",
					LayoutOrder = 7,
				}),
				["6.5"] = Roact.createElement("ImageLabel", {
					Size = UDim2.fromScale(0.8, 0.5),
					BackgroundTransparency = 1,
					Image = "rbxassetid://11407871999",
					LayoutOrder = 8,
				}),
				Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.8, 0.3),
					Text = "Explore the world and hunt down the most dangerous creatures. Collect their parts and craft the most powerful weapons and armor.",
					Font = Enum.Font.GothamBold,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 15,
					LayoutOrder = 9,
					RichText = true,
					TextWrapped = true,
				}),
				Roact.createElement(VerticalFeature, {
					title = "Profession Mechanic",
					LayoutOrder = 16,
				}),
				["9.5"] = Roact.createElement("ImageLabel", {
					Size = UDim2.fromScale(0.8, 0.5),
					BackgroundTransparency = 1,
					Image = "rbxassetid://11407773585",
					LayoutOrder = 17,
				}),
				Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.8, 0.3),
					Text = "Choose a profession and specialize in it. Each profession has its own unique abilities and playstyle.",
					Font = Enum.Font.GothamBold,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 15,
					LayoutOrder = 18,
					RichText = true,
					TextWrapped = true,
				}),
				Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.8, 0.3),
					Text = "Twitter Code: ALPHA",
					Font = Enum.Font.GothamBold,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 21,
					LayoutOrder = 19,
					RichText = true,
					TextWrapped = true,
				}),
				dd = Roact.createElement(Footer, {
					title = "made with ❤️ by qtree",
					LayoutOrder = 19,
				}),
			}),
		}),
	})
	return Roact.createFragment({
		Play = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Lobby)
return {
	default = default,
}
