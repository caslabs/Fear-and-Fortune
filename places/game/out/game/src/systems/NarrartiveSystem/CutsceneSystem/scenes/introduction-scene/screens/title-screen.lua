-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local UserInputService = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local _Context = TS.import(script, script.Parent.Parent.Parent.Parent, "ui", "Context")
local Context = _Context.Context
local Pages = _Context.Pages
local Panel = TS.import(script, script.Parent.Parent.Parent.Parent, "ui", "Panels", "Panel").Panel
local WarningScreen = TS.import(script, script.Parent, "splash-screen")
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local MusicSystemController = TS.import(script, script.Parent.Parent.Parent.Parent, "SystemsController", "MusicSystem", "music-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local MusicKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "MusicSystem", "MusicData").MusicKeys
-- Post Event Screen
-- TODO: Make a META file for info of the game
local TitleScreen = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	-- The ratio of the screen's height occupied by each bar
	local barHeightRatio = 0.1
	print("Initiated Title Screen")
	local isLoading, setIsLoading = useState("LOADING")
	useEffect(function()
		local isRunning = true
		local loadingCounter = 0
		local updateLoading = TS.async(function()
			while isRunning do
				loadingCounter = (loadingCounter + 1) % 4
				local dots = ""
				do
					local i = 0
					local _shouldIncrement = false
					while true do
						if _shouldIncrement then
							i += 1
						else
							_shouldIncrement = true
						end
						if not (i < loadingCounter) then
							break
						end
						dots ..= "."
					end
				end
				local loadingText = "LOADING" .. dots
				setIsLoading(loadingText)
				TS.await(TS.Promise.delay(0.5))
			end
		end)
		local handleEffect = TS.async(function()
			-- Start animation
			updateLoading()
			-- Start Timer
			-- 10 seconds for warning screen
			TS.await(TS.Promise.delay(10))
			MusicSystemController:playMusic(MusicKeys.INTRODUCTION_MUSIC)
			-- 14 seconds for title screen
			TS.await(TS.Promise.delay(17))
			isRunning = false
			setIsLoading("Press any button to play")
			local connection
			connection = UserInputService.InputBegan:Connect(function()
				-- Disconnect the event before switching to the play HUD
				connection:Disconnect()
				SoundSystemController:playSound(SoundKeys.UI_CLOSE)
				MusicSystemController:stopMusic(MusicKeys.INTRODUCTION_MUSIC)
				Signals.finishedTitleScreen:Fire()
			end)
		end)
		handleEffect()
	end, {})
	return Roact.createElement(Context.Consumer, {
		render = function(value)
			return Roact.createElement(Panel, {
				index = Pages.titleScreen,
				visible = props.visible,
			}, {
				Roact.createElement(WarningScreen),
				Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, barHeightRatio, 0),
					Position = UDim2.new(0, 0, 0, 0),
					BackgroundColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
				}),
				Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, barHeightRatio, 0),
					Position = UDim2.new(0, 0, 1 - barHeightRatio, 0),
					BackgroundColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
				}, {
					Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextColor3 = Color3.new(255, 255, 255),
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.new(0.5, 0, 0, 0),
						Text = isLoading,
						Font = Enum.Font.Merriweather,
						FontSize = Enum.FontSize.Size14,
						Size = UDim2.new(0, 0, 1, 0),
					}),
					Roact.createElement("TextLabel", {
						Text = "The Yeti of Mount Everest",
						Size = UDim2.new(0.3, 0, 13, 0),
						Position = UDim2.new(0, 30, 2.5, 0),
						BackgroundTransparency = 1,
						TextColor3 = Color3.new(1, 1, 1),
						FontSize = Enum.FontSize.Size42,
						AnchorPoint = Vector2.new(0, 1),
						TextWrapped = true,
						TextScaled = true,
						Font = Enum.Font.GothamBold,
					}),
				}),
			})
		end,
	})
end
local default = Hooks.new(Roact)(TitleScreen)
return {
	default = default,
}
