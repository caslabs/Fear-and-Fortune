-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Close = TS.import(script, script.Parent.Parent, "Pages", "Panels", "PanelLobby", "Close").default
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local TeleportService = _services.TeleportService
local Panel = TS.import(script, script.Parent.Parent, "Pages", "Panels", "PanelLobby", "Panel").Panel
local Pages = TS.import(script, script.Parent.Parent, "routers", "Lobby", "Context-LobbyHUD").Pages
local TutorialHUD = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local textboxRef = Roact.createRef()
	local players, setPlayers = useState(function()
		return Players:GetPlayers()
	end)
	local partyName, setPartyName = useState("Tutorial CODE")
	useEffect(function()
		local onPlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
			setPlayers(function(prevPlayers)
				local _array = {}
				local _length = #_array
				local _prevPlayersLength = #prevPlayers
				table.move(prevPlayers, 1, _prevPlayersLength, _length + 1, _array)
				_length += _prevPlayersLength
				_array[_length + 1] = player
				return _array
			end)
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
	return Roact.createElement(Panel, {
		index = Pages.tutorial,
		visible = props.visible,
	}, {
		Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
		}),
		Roact.createElement("Frame", {
			Size = UDim2.new(0.5, 0, 0.5, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = Color3.fromRGB(26, 26, 26),
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
		}, {
			Title = Roact.createElement("TextLabel", {
				Text = "Are you sure you want to exit lobby and enter tutorial?",
				FontSize = Enum.FontSize.Size14,
				Size = UDim2.new(1, 0, 0.7, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextWrapped = true,
			}),
			EnterButton = Roact.createElement("TextButton", {
				Text = "Enter Tutorial",
				FontSize = Enum.FontSize.Size14,
				Size = UDim2.new(1, 0, 0.3, 0),
				Position = UDim2.new(0, 0, 0.7, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				ZIndex = 5,
				BackgroundTransparency = 0.5,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				[Roact.Event.MouseButton1Click] = function()
					-- Open Tutorial Panel 13961980582
					-- Teleport to Tutorial Game
					local player = Players.LocalPlayer
					local placeId = 13961980582
					TeleportService:Teleport(placeId, player)
				end,
			}, {
				Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
				Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 6),
					PaddingBottom = UDim.new(0, 6),
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
				}),
			}),
			Roact.createElement(Close),
		}),
	})
end
local default = Hooks.new(Roact)(TutorialHUD)
return {
	default = default,
}
