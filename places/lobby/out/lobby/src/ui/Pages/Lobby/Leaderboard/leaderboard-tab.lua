-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local MarketplaceService = _services.MarketplaceService
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local getDonationDataFunc = Remotes.Client:Get("GetDonationData")
local getExpeditionDataFunc = Remotes.Client:Get("GetExpeditionData")
-- TODO: is there a better way? Had to use Global as setData was not updating the data variable
local Leaderboard = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local selectedTab, setSelectedTab = useState("Top Donated")
	local entries, setEntries = useState(10)
	local leaderboardData, setLeaderboardData = useState({})
	local expeditionData, setExpeditionData = useState({})
	local refresh, setRefresh = useState(false)
	local refreshState, setRefreshState = useState("Refresh")
	local isCoolDown, setIsCoolDown = useState(false)
	useEffect(function()
		if refresh then
			setRefreshState("Refreshing...")
			if selectedTab == "Top Donated" then
				local _exp = getDonationDataFunc:CallServerAsync()
				local _arg0 = TS.async(function(data)
					print("Data:", data)
					setLeaderboardData(TS.await(data))
					setRefreshState("Refreshed!")
					local _exp_1 = TS.Promise.delay(1.5)
					local _arg0_1 = function()
						setRefreshState("Refresh")
						setRefresh(false)
						setIsCoolDown(false)
					end
					_exp_1:andThen(_arg0_1)
				end)
				_exp:andThen(_arg0)
			elseif selectedTab == "Most Expeditions" then
				local _exp = getExpeditionDataFunc:CallServerAsync()
				local _arg0 = TS.async(function(data)
					print("Data:", data)
					setExpeditionData(TS.await(data))
					setRefreshState("Refreshed!")
					local _exp_1 = TS.Promise.delay(1.5)
					local _arg0_1 = function()
						setRefreshState("Refresh")
						setRefresh(false)
						setIsCoolDown(false)
					end
					_exp_1:andThen(_arg0_1)
				end)
				_exp:andThen(_arg0)
			end
		end
	end, { refresh })
	useEffect(function()
		if selectedTab == "Top Donated" then
			local _exp = getDonationDataFunc:CallServerAsync()
			local _arg0 = TS.async(function(data)
				print("Data:", data)
				setLeaderboardData(TS.await(data))
			end)
			_exp:andThen(_arg0)
		elseif selectedTab == "Most Expeditions" then
			local _exp = getExpeditionDataFunc:CallServerAsync()
			local _arg0 = TS.async(function(data)
				print("Data:", data)
				setExpeditionData(TS.await(data))
			end)
			_exp:andThen(_arg0)
		end
	end, { selectedTab })
	local _attributes = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = props.visible == "leaderboard",
	}
	local _children = {
		TabButtons = Roact.createElement("Frame", {
			Size = UDim2.new(0.2, 0, 0.3, 0),
			Position = UDim2.fromScale(0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(0, 0, 0),
		}, {
			LeaderboardTabButton1 = Roact.createElement("TextButton", {
				Text = "Donators",
				TextSize = 13,
				Font = "GothamBold",
				Size = UDim2.fromScale(1, 0.35),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				[Roact.Event.MouseButton1Click] = function()
					return setSelectedTab("Top Donated")
				end,
				BackgroundColor3 = if selectedTab == "Top Donated" then Color3.fromRGB(128, 128, 128) else Color3.fromRGB(45, 45, 45),
			}),
			LeaderboardTabButton2 = Roact.createElement("TextButton", {
				Text = "Expeditions",
				Font = "GothamBold",
				TextSize = 13,
				Size = UDim2.fromScale(1, 0.35),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Position = UDim2.fromScale(0, 0.4),
				[Roact.Event.MouseButton1Click] = function()
					return setSelectedTab("Most Expeditions")
				end,
				BackgroundColor3 = if selectedTab == "Most Expeditions" then Color3.fromRGB(128, 128, 128) else Color3.fromRGB(45, 45, 45),
			}),
		}),
	}
	local _length = #_children
	local _arg0 = function(entry, index)
		return Roact.createFragment({
			[tostring(index)] = Roact.createElement("TextLabel", {
				Text = entry.name .. (" - " .. tostring(entry.donation)),
				Size = UDim2.fromScale(0.5, 0.05),
				BackgroundTransparency = 0.7,
				Position = UDim2.fromScale(0.5, 0.12 + index * 0.05),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				TextColor3 = Color3.fromRGB(222, 222, 222),
				Font = Enum.Font.GothamBold,
			}),
		})
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#leaderboardData)
	for _k, _v in ipairs(leaderboardData) do
		_newValue[_k] = _arg0(_v, _k - 1, leaderboardData)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_1 = {
		Size = UDim2.fromScale(0.77, 1),
		Position = UDim2.fromScale(0.2, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
		Visible = selectedTab == "Top Donated",
		CanvasSize = UDim2.fromScale(0, 1),
	}
	local _children_1 = {
		Roact.createElement("TextLabel", {
			Text = "Top Donators",
			Size = UDim2.fromScale(0.4, 0.09),
			Position = UDim2.fromScale(0.5, 0.03),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.GothamBold,
			TextSize = 30,
		}),
	}
	local _length_1 = #_children_1
	for _k, _v in ipairs(_newValue) do
		_children_1[_length_1 + _k] = _v
	end
	_children[_length + 1] = Roact.createElement("ScrollingFrame", _attributes_1, _children_1)
	local _arg0_1 = function(entry, index)
		return Roact.createFragment({
			[tostring(index)] = Roact.createElement("TextLabel", {
				Text = entry.name .. (" - " .. tostring(entry.expedition)),
				Size = UDim2.fromScale(0.5, 0.05),
				BackgroundTransparency = 0.7,
				Position = UDim2.fromScale(0.5, 0.12 + index * 0.05),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				TextColor3 = Color3.fromRGB(222, 222, 222),
				Font = Enum.Font.GothamBold,
			}),
		})
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue_1 = table.create(#expeditionData)
	for _k, _v in ipairs(expeditionData) do
		_newValue_1[_k] = _arg0_1(_v, _k - 1, expeditionData)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes_2 = {
		Size = UDim2.fromScale(0.77, 1),
		Position = UDim2.fromScale(0.2, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 6,
		Visible = selectedTab == "Most Expeditions",
		CanvasSize = UDim2.fromScale(0, 1),
	}
	local _children_2 = {
		Roact.createElement("TextLabel", {
			Text = "Most Expeditions",
			Size = UDim2.fromScale(0.4, 0.09),
			Position = UDim2.fromScale(0.5, 0.03),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.GothamBold,
			TextSize = 30,
		}),
	}
	local _length_2 = #_children_2
	for _k, _v in ipairs(_newValue_1) do
		_children_2[_length_2 + _k] = _v
	end
	_children[_length + 2] = Roact.createElement("ScrollingFrame", _attributes_2, _children_2)
	_children.DonateButton = Roact.createElement("TextButton", {
		Text = "Donate  100",
		Visible = selectedTab == "Top Donated",
		Size = UDim2.fromScale(0.2, 0.1),
		Position = UDim2.fromScale(0.6, 0.9),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 0.1,
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		TextColor3 = Color3.fromRGB(222, 222, 222),
		Font = Enum.Font.GothamBold,
		[Roact.Event.MouseButton1Click] = function()
			MarketplaceService:PromptProductPurchase(Players.LocalPlayer, 1585639493)
			-- TODO: Upon success, call the server to update the leaderboard
			-- setRefresh(!refresh);
		end,
	})
	_children.RefreshButton = Roact.createElement("TextButton", {
		Text = refreshState,
		Size = UDim2.fromScale(0.1, 0.05),
		Position = UDim2.fromScale(0.9, 0.05),
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		TextColor3 = Color3.fromRGB(222, 222, 222),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		[Roact.Event.MouseButton1Click] = function()
			if not isCoolDown then
				setIsCoolDown(true)
				setRefresh(not refresh)
				local _exp = TS.Promise.delay(1.5)
				local _arg0_2 = function()
					setIsCoolDown(false)
				end
				_exp:andThen(_arg0_2)
			end
		end,
	})
	return Roact.createFragment({
		LeaderboardPage = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Leaderboard)
return {
	default = default,
}
