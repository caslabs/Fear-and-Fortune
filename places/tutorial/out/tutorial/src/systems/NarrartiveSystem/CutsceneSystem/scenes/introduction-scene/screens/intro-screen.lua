-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local RoactSpring = TS.import(script, TS.getModule(script, "@rbxts", "roact-spring").src)
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local IntroScreen = function(props, hooks)
	local isMounted = true
	local text, setText = hooks.useState("")
	local fullText, setFullText = hooks.useState(props.description)
	local speed = 0.17
	local waitTime = speed * #fullText + 1
	local warningStyle = RoactSpring.useSpring(hooks, {
		from = {
			transparency = 0,
		},
		to = {
			transparency = 1,
		},
		delay = waitTime,
		config = {
			mass = 1,
			tension = 280,
			friction = 60,
		},
	})
	-- TODO: Polish text animation
	hooks.useEffect(function()
		local tempText = ""
		local textAnimCoroutine = coroutine.wrap(function()
			for char in string.gmatch(fullText, utf8.charpattern) do
				tempText ..= char
				if isMounted then
					setText(tempText)
				end
				SoundSystemController:playSound(SoundKeys.SFX_TYPEWRITER)
				task.wait(speed)
			end
		end)
		textAnimCoroutine()
		return function()
			isMounted = false
		end
	end, { fullText })
	hooks.useEffect(function()
		-- Temporary hack? Hides the mouse for the duration of the animation
		local startTime = tick()
		local connection
		-- Create a connection to the Stepped event
		connection = RunService.Stepped:Connect(function()
			if tick() - startTime >= waitTime then
				-- If waitTime seconds have passed
				Signals.finishedIntroduction:Fire()
				connection:Disconnect()
			end
		end)
		-- Clean up function to disconnect the Stepped event if the component unmounts before it fires
		return function()
			return connection:Disconnect()
		end
	end, {})
	return Roact.createFragment({
		IntroScene = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			LayoutOrder = 99999,
		}, {
			WarningFrame = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = warningStyle.transparency,
				ZIndex = 10,
			}, {
				WarningText = Roact.createElement("TextLabel", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = warningStyle.transparency,
					Text = text,
					TextColor3 = Color3.new(1, 1, 1),
					TextWrapped = true,
					FontSize = Enum.FontSize.Size12,
					TextTransparency = warningStyle.transparency,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					ZIndex = 11,
				}),
			}),
		}),
	})
end
return Hooks.new(Roact)(IntroScreen)
