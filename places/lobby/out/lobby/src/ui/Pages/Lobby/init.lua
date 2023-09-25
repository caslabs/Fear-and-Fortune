-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local RunService = _services.RunService
local Players = _services.Players
local Pages = TS.import(script, script.Parent.Parent, "routers", "Lobby", "Context-LobbyHUD").Pages
local _shop_manager = TS.import(script, script, "data", "shop-manager")
local setCurrentTab = _shop_manager.setCurrentTab
local getCurrentTab = _shop_manager.getCurrentTab
local getPageVisible = _shop_manager.getPageVisible
local setPageVisibleGlob = _shop_manager.setPageVisibleGlob
local ItemsList = TS.import(script, script, "data", "items-list").ItemsList
local CraftingList = TS.import(script, script, "data", "crafting-list").CraftingList
local Panel = TS.import(script, script.Parent, "Panels", "PanelLobby", "Panel").Panel
local Tab = TS.import(script, script.Parent, "Panels", "PanelLobby", "Tab").default
local Play = TS.import(script, script, "Play", "play-tab").default
local Party = TS.import(script, script, "Party", "party-tab").default
local Trade = TS.import(script, script, "Trade", "trade-tab").default
local Leaderboard = TS.import(script, script, "Leaderboard", "leaderboard-tab").default
local Inventory = TS.import(script, script, "Inventory", "inventory-tab").default
-- import Profession from "./profession-tab";
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local ProfessionList = TS.import(script, script, "data", "profession-list").ProfessionList
local Crafting = TS.import(script, script, "Craft", "crafting-tab").default
local Profession = TS.import(script, script, "Profession", "profession-tab").default
local inventoryList = TS.import(script, script, "data", "_inventoryData").inventoryList
local CreditsButton = TS.import(script, script, "CreditsButton").default
local inventoryListDesc = TS.import(script, script, "data", "_inventoryDataDesc").inventoryListDesc
local TwitterButton = TS.import(script, script, "TwitterButton").default
local InviteFriendsButton = TS.import(script, script, "InviteFriendsButton").default
local HuntingList = TS.import(script, script, "data", "hunting-list").HuntingList
local VersionButton = TS.import(script, script, "VersionButton").default
local TimerState
do
	TimerState = setmetatable({}, {
		__tostring = function()
			return "TimerState"
		end,
	})
	TimerState.__index = TimerState
	function TimerState.new(...)
		local self = setmetatable({}, TimerState)
		return self:constructor(...) or self
	end
	function TimerState:constructor()
		self.isActive = false
	end
end
local QueueState
do
	local _inverse = {}
	QueueState = setmetatable({}, {
		__index = _inverse,
	})
	QueueState.Idle = 0
	_inverse[0] = "Idle"
	QueueState.Searching = 1
	_inverse[1] = "Searching"
	QueueState.ServerFound = 2
	_inverse[2] = "ServerFound"
	QueueState.EmbarkFailed = 3
	_inverse[3] = "EmbarkFailed"
end
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
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local QueueStateChangeEvent = Remotes.Client:Get("QueueStateChange")
local GetInventoryEvent = Remotes.Client:Get("GetInventory")
local UpdateCurrencyEvent = Remotes.Client:Get("UpdateCurrency")
local PlayerProfessionUpdateEvent = Remotes.Client:Get("PlayerProfessionUpdate")
local LobbyPage = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local tabChosen, setTabChosen = useState(getCurrentTab())
	local pageVisible, setPageVisible = useState(getPageVisible())
	local queueState, setQueueState = useState(QueueState.Idle)
	local queueText, setQueueText = useState("")
	local queueTimer, setQueueTimer = useState(0)
	local countdownTime, setCountdownTime = useState(nil)
	local itemsList, setItemsList = useState({})
	local currency, setCurrency = useState(0)
	local profession, setProfession = useState("Mountaineer")
	useEffect(function()
		local connection = Signals.queueStateChangedSignal:Connect(setQueueState)
		return function()
			return connection:Disconnect()
		end
	end, {})
	useEffect(function()
		local connection = QueueStateChangeEvent:Connect(setQueueState)
		return function()
			return connection:Disconnect()
		end
	end, {})
	useEffect(function()
		local connection = UpdateCurrencyEvent:Connect(function(player, currency)
			setCurrency(currency)
		end)
		print("Update currency")
		return function()
			return connection:Disconnect()
		end
	end, {})
	useEffect(function()
		local connection = PlayerProfessionUpdateEvent:Connect(function(profession)
			setProfession(profession)
		end)
		print("Update profession")
		return function()
			return connection:Disconnect()
		end
	end, {})
	useEffect(function()
		local startConnection = Signals.startCountdownSignal:Connect(function(time)
			setCountdownTime(time)
		end)
		local endConnection = Signals.endCountdownSignal:Connect(function()
			setCountdownTime(nil)
		end)
		local embarkFailedConnection = Signals.embarkFailedSignal:Connect(function() end)
		return function()
			startConnection:Disconnect()
			endConnection:Disconnect()
			embarkFailedConnection:Disconnect()
		end
	end, {})
	useEffect(function()
		local minutes = (queueTimer - (queueTimer % 60)) / 60
		local seconds = queueTimer - minutes * 60
		local queueTimeString = string.format("%02d:%02d", minutes, seconds)
		repeat
			if queueState == (QueueState.Idle) then
				setQueueText("")
				break
			end
			if queueState == (QueueState.Searching) then
				setQueueText("[" .. (queueTimeString .. "] Searching for Players and Servers..."))
				print("Queue time string: " .. queueTimeString)
				break
			end
			if queueState == (QueueState.ServerFound) then
				if countdownTime ~= nil then
					-- Add this check
					setQueueText("[" .. (tostring(countdownTime) .. "] Server Found! Attempting to Embark..."))
					if countdownTime == 1 then
						setQueueText("Embarking...")
					end
				end
				break
			end
			if queueState == (QueueState.EmbarkFailed) then
				setQueueText("Embark failed! Retrying...")
				break
			end
		until true
	end, { queueState, queueTimer, countdownTime })
	useEffect(function()
		local connection
		if queueState == QueueState.Searching then
			local index = 0
			local lastTime = tick()
			connection = RunService.RenderStepped:Connect(function()
				if queueState ~= QueueState.Searching then
					local _result = connection
					if _result ~= nil then
						_result:Disconnect()
					end
					setQueueTimer(0)
					print("QueueState is not Searching anymore, disconnecting and resetting timer")
				else
					local currentTime = tick()
					if currentTime - lastTime >= 1 then
						setQueueTimer(index)
						print("Timer incremented, queueTimer is now " .. tostring(index))
						index += 1
						lastTime = currentTime
					end
				end
			end)
		else
			setQueueTimer(0)
			print("QueueState is not Searching, resetting timer")
		end
		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { queueState })
	useEffect(function()
		local player = Players.LocalPlayer
	end, {})
	return Roact.createFragment({
		LobbyPanel = Roact.createElement(Panel, {
			index = Pages.lobby,
			visible = props.visible,
		}, {
			Roact.createElement(InviteFriendsButton),
			Roact.createElement(TwitterButton),
			Roact.createElement(CreditsButton),
			Roact.createElement(VersionButton),
			Roact.createElement("Frame", {
				Size = UDim2.fromScale(0.1, 0.05),
				Position = UDim2.fromScale(0, 1),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
			}, {
				Roact.createElement("ImageLabel", {
					Image = "rbxassetid://12644643565",
					Size = UDim2.fromScale(0.3, 0.7),
					Position = UDim2.fromScale(0.15, 0.1),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Fit,
				}),
				Roact.createElement("TextLabel", {
					Text = tostring(currency),
					TextScaled = true,
					Font = "GrenzeGotisch",
					Size = UDim2.fromScale(0.5, 1),
					Position = UDim2.fromScale(0.5, -0.1),
					BackgroundTransparency = 1,
					TextColor3 = Color3.new(1, 1, 1),
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
			}),
			QueueText = Roact.createElement("TextLabel", {
				Text = queueText,
				ZIndex = 5,
				Size = UDim2.fromScale(0.25, 0.1),
				Position = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(1, 1, 1),
				AnchorPoint = Vector2.new(1, 1),
			}),
			Studio = Roact.createElement("TextLabel", {
				Text = "QTREE STUDIO",
				ZIndex = 5,
				Size = UDim2.fromScale(0.1, 0.1),
				Position = UDim2.fromScale(0, 1),
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(1, 1, 1),
				AnchorPoint = Vector2.new(0, 1),
			}),
			Lobby = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(26, 26, 26),
			}, {
				Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
				Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
				}),
				Tabs = Roact.createElement("Frame", {
					Size = UDim2.new(0.1, 0, 0.9, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0.05, 0),
				}, {
					Roact.createElement("UIListLayout", {
						FillDirection = "Vertical",
						Padding = UDim.new(0, 6),
					}),
					Roact.createElement(Tab, {
						text = "Leaderboard",
						page = "leaderboard",
						active = "Leaderboard" == tabChosen,
						onClick = function(page)
							setTabChosen("Leaderboard")
							setCurrentTab("Leaderboard")
							setPageVisible(page)
							setPageVisibleGlob(page)
						end,
					}),
					Roact.createElement(Tab, {
						text = "Play",
						page = "play",
						active = "Play" == tabChosen,
						onClick = function(page)
							setTabChosen("Play")
							setCurrentTab("Play")
							setPageVisible(page)
							setPageVisibleGlob(page)
						end,
					}),
					Roact.createElement(Tab, {
						text = "Party",
						page = "party",
						active = "Party" == tabChosen,
						onClick = function(page)
							setTabChosen("Party")
							setCurrentTab("Party")
							setPageVisible(page)
							setPageVisibleGlob(page)
						end,
					}),
					Roact.createElement(Tab, {
						text = "Profession\n[" .. profession .. "]",
						page = "profession",
						active = "Profession" == tabChosen,
						onClick = function(page)
							setTabChosen("Profession")
							setCurrentTab("Profession")
							setPageVisible(page)
							setPageVisibleGlob(page)
						end,
					}),
					Roact.createElement(Tab, {
						text = "Stash",
						page = "inventory",
						active = "Inventory" == tabChosen,
						onClick = function(page)
							setTabChosen("Inventory")
							setCurrentTab("Inventory")
							setPageVisible(page)
							setPageVisibleGlob(page)
						end,
					}),
					Roact.createElement(Tab, {
						text = "Crafting",
						page = "crafting",
						active = "Crafting" == tabChosen,
						onClick = function(page)
							setTabChosen("Crafting")
							setCurrentTab("Crafting")
							setPageVisible(page)
							setPageVisibleGlob(page)
						end,
					}),
					Roact.createElement(Tab, {
						text = "Trade",
						page = "trade",
						active = "Trade" == tabChosen,
						onClick = function(page)
							setTabChosen("Trade")
							setCurrentTab("Trade")
							setPageVisible(page)
							setPageVisibleGlob(page)
						end,
					}),
				}),
				Content = Roact.createElement("Frame", {
					Size = UDim2.new(0.75, 0, 1, 0),
					Position = UDim2.new(0.25, 0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
				}, {
					Roact.createElement(Leaderboard, {
						visible = pageVisible,
						playerName = "qwertyman10",
					}),
					Roact.createElement(Inventory, {
						visible = pageVisible,
						data = inventoryListDesc,
					}),
					Roact.createElement(Play, {
						visible = pageVisible,
						data = HuntingList,
					}),
					Roact.createElement(Party, {
						visible = pageVisible,
						data = ItemsList,
					}),
					Roact.createElement(Profession, {
						visible = pageVisible,
						data = ProfessionList,
					}),
					Roact.createElement(Crafting, {
						visible = pageVisible,
						data = CraftingList,
					}),
					Roact.createElement(Trade, {
						visible = pageVisible,
						data = inventoryList,
					}),
				}),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(LobbyPage)
return {
	TimerState = TimerState,
	QueueState = QueueState,
	default = default,
}
