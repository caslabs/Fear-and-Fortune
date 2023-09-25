-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local UserInputService = _services.UserInputService
local RunService = _services.RunService
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local MusicSystemController = TS.import(script, script.Parent.Parent.Parent, "SystemsController", "MusicSystem", "music-controller").default
local MusicKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "MusicSystem", "MusicData").MusicKeys
local CreditScreen = function(props, hooks)
	local credits = { { "Programmers", { "@qwertyman10" } }, { "Beta Testers", { "@Umderstood", "- Game is fun", "@ItsSmolKin", "@wugglebuggle", "@stewie", "@Tigerflossss", "@ogmurasaki", "@koriii", "@RisaiahYT" } }, { "Voice Actors", { "@akaLVX" } }, { "Game Designers", { "@qwertyman10" } }, { "Lead Artists", { "@qwertyman10" } }, { "Music Composer", { "@qwertyman10" } }, { "Sound Designers", { "@qwertyman10" } }, { "Story and Screenplay", { "@qwertyman10" } }, { "Quality Assurance", { "@qwertyman10" } }, { "Technical Director", { "@qwertyman10" } }, { "Animation Director", { "@qwertyman10" } }, { "Art Director", { "@qwertyman10" } }, { "Project Manager", { "@qwertyman10" } }, { "Level Designers", { "@qwertyman10" } }, { "Community Manager", { "@qwertyman10" } }, { "Marketing Director", { "@qwertyman10" } }, { "Customer Support", { "@qwertyman10" } }, { "UX Designer", { "@qwertyman10" } }, { "UI Designer", { "@qwertyman10" } }, { "Gameplay Programmer", { "@qwertyman10" } }, { "Localization", { "@qwertyman10" } }, { "Legal", { "@qwertyman10" } }, { "Public Relations", { "@qwertyman10" } }, { "Twitter Code:", { "THANKYOU" } } }
	local offset, setOffset = hooks.useState(-0.1)
	local creditMusicState, setCreditMusicState = hooks.useState(false)
	local creditsText = "Fear and Fortune\n \n \n The Yeti of Mount Everest \n .gg/qtree"
	local delay = 0.5
	hooks.useEffect(function()
		local inputChangedConnection = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Signals.OnCreditScreenExit:Fire()
				MusicSystemController:stopMusic(MusicKeys.CREDIT_MUSIC)
				MusicSystemController:playMusic(MusicKeys.LOBBY_MUSIC)
			end
		end)
		return function()
			inputChangedConnection:Disconnect()
		end
	end, {})
	hooks.useEffect(function()
		if creditMusicState then
			return nil
		end
		-- Stop Lobby Music
		MusicSystemController:pauseMusic(MusicKeys.LOBBY_MUSIC)
		-- Play the credits music
		MusicSystemController:playMusic(MusicKeys.CREDIT_MUSIC)
		setCreditMusicState(true)
	end)
	hooks.useEffect(function()
		local active = true
		local connection = RunService.RenderStepped:Connect(function()
			if active then
				setOffset(function(prevOffset)
					return prevOffset - 0.001
				end)
			end
		end)
		return function()
			active = false
			if connection then
				connection:Disconnect()
			end
		end
	end, {})
	local creditElements = {}
	local _arg0 = Roact.createFragment({
		CreditsText = Roact.createElement("TextLabel", {
			Size = UDim2.fromScale(1, 0.1),
			Text = creditsText,
			TextScaled = false,
			TextSize = 30,
			Font = Enum.Font.SourceSansBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
		}),
	})
	table.insert(creditElements, _arg0)
	local position = 0
	local delayIncrement = 0.1
	for _, _binding in ipairs(credits) do
		local role = _binding[1]
		local contributors = _binding[2]
		local _arg0_1 = Roact.createFragment({
			[role] = Roact.createElement("TextLabel", {
				Size = UDim2.fromScale(1, 0.01),
				Text = role,
				TextScaled = false,
				TextSize = 24,
				Font = Enum.Font.SourceSansBold,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, position),
				TextYAlignment = "Bottom",
			}),
		})
		table.insert(creditElements, _arg0_1)
		position += delayIncrement
		for _1, name in ipairs(contributors) do
			local _arg0_2 = Roact.createFragment({
				[role .. ("_" .. name)] = Roact.createElement("TextLabel", {
					Size = UDim2.fromScale(1, 0.005),
					Text = name,
					TextScaled = false,
					TextSize = 18,
					Font = Enum.Font.SourceSans,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, position),
					TextYAlignment = "Top",
				}),
			})
			table.insert(creditElements, _arg0_2)
			position += delayIncrement
		end
		position += delayIncrement
	end
	local _children = {
		Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Text = "Click to exit",
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			ZIndex = 5,
			Size = UDim2.fromScale(0.1, 0.1),
		}),
	}
	local _length = #_children
	local _attributes = {
		Size = UDim2.fromScale(1, 10),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, offset, 0),
		ClipsDescendants = true,
	}
	local _children_1 = {
		Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0),
		}),
	}
	local _length_1 = #_children_1
	for _k, _v in ipairs(creditElements) do
		_children_1[_length_1 + _k] = _v
	end
	_children.CreditScreenFrame = Roact.createElement("Frame", _attributes, _children_1)
	return Roact.createElement("ScreenGui", {}, _children)
end
return Hooks.new(Roact)(CreditScreen)
