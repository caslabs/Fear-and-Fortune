-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Close = TS.import(script, script.Parent.Parent, "Pages", "Panels", "PanelLobby", "Close").default
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Panel = TS.import(script, script.Parent.Parent, "Pages", "Panels", "PanelLobby", "Panel").Panel
local Pages = TS.import(script, script.Parent.Parent, "routers", "Lobby", "Context-LobbyHUD").Pages
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local CheckIfReedemEvent = Remotes.Client:Get("CheckIfReedem")
local ReedemTwitterCode = Remotes.Client:Get("ReedemTwitterCode")
local TwitterHUD = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local textboxRef = Roact.createRef()
	local players, setPlayers = useState(function()
		return Players:GetPlayers()
	end)
	local partyName, setPartyName = useState("TWITTER CODE")
	local buttonText, setButtonText = useState("Redeem")
	local isRedeeming, setIsRedeeming = useState(false)
	local currency, setCurrency = useState(0)
	local textBoxValue, setTextBoxValue = useState("")
	local UpdateCurrencyTwitterEvent = Remotes.Client:Get("UpdateCurrencyTwitter")
	useEffect(function()
		local updateCurrency = UpdateCurrencyTwitterEvent:Connect(function(player, currency)
			setCurrency(currency)
			print("Currency updated", currency)
		end)
		print("Update currency on Twitter Page")
		return function()
			return updateCurrency:Disconnect()
		end
	end, {})
	useEffect(function()
		local textboxInstance = textboxRef:getValue()
		print(textboxRef)
		print((textboxRef:getValue()))
		if textboxInstance then
			textboxInstance.FocusLost:Connect(function()
				print("Focus Lost", textboxInstance.Text)
				if textboxInstance.Text == "" then
					textboxInstance.Text = "ENTER CODE HERE"
				end
			end)
			textboxInstance:GetPropertyChangedSignal("Text"):Connect(function()
				setTextBoxValue(textboxInstance.Text)
			end)
		end
		if isRedeeming then
			local _exp = CheckIfReedemEvent:CallServerAsync()
			local _arg0 = TS.async(function(alreadyRedeemed)
				if TS.await(alreadyRedeemed) then
					setButtonText("Already Redeemed!")
					-- wait for 2 seconds, then reset button
					local _exp_1 = TS.Promise.delay(2)
					local _arg0_1 = function()
						setButtonText("Redeem")
						setIsRedeeming(false)
					end
					_exp_1:andThen(_arg0_1)
				else
					setButtonText("Redeeming...")
					-- eslint-disable-next-line roblox-ts/lua-truthiness
					if textBoxValue ~= "" and textBoxValue then
						local _exp_1 = ReedemTwitterCode:CallServerAsync(textBoxValue)
						local _arg0_1 = function(response)
							print(response)
							setButtonText(response)
							local _exp_2 = TS.Promise.delay(2)
							local _arg0_2 = function()
								setButtonText("Redeem")
								setIsRedeeming(false)
							end
							_exp_2:andThen(_arg0_2)
						end
						_exp_1:andThen(_arg0_1)
					else
						print("No textbox value")
						print(textBoxValue)
					end
				end
			end)
			_exp:andThen(_arg0)
		end
		-- Cleanup function
		return function() end
	end, { isRedeeming })
	return Roact.createElement(Panel, {
		index = Pages.twitter,
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
		Roact.createElement("Frame", {
			Size = UDim2.new(0.5, 0, 0.5, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = Color3.fromRGB(26, 26, 26),
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
		}, {
			Title = Roact.createElement("TextLabel", {
				Text = "Twitter Code",
				FontSize = Enum.FontSize.Size14,
				Size = UDim2.new(1, 0, 0.7, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextWrapped = true,
			}),
			Roact.createElement("TextBox", {
				Text = partyName,
				Size = UDim2.fromScale(0.2, 0.12),
				Position = UDim2.fromScale(0.3, 0.4),
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
				Text = buttonText,
				Size = UDim2.fromScale(0.15, 0.12),
				Position = UDim2.fromScale(0.5, 0.4),
				TextSize = 15,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Font = Enum.Font.SourceSansBold,
				BackgroundColor3 = Color3.fromRGB(128, 128, 128),
				[Roact.Event.MouseButton1Click] = function()
					if textBoxValue == "" then
						print("No textbox value")
						print(textBoxValue)
						return nil
					end
					setIsRedeeming(true)
				end,
			}),
			Roact.createElement(Close),
		}),
	})
end
local default = Hooks.new(Roact)(TwitterHUD)
return {
	default = default,
}
