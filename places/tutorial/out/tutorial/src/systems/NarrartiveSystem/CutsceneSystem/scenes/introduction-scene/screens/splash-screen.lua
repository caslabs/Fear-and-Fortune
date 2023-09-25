-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local RoactSpring = TS.import(script, TS.getModule(script, "@rbxts", "roact-spring").src)
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local WarningScreen = function(props, hooks)
	local logoStyle = RoactSpring.useSpring(hooks, {
		from = {
			transparency = 0,
		},
		to = {
			transparency = 1,
		},
		delay = 5,
		config = {
			mass = 1,
			tension = 280,
			friction = 60,
		},
	})
	local warningStyle = RoactSpring.useSpring(hooks, {
		from = {
			transparency = 0,
		},
		to = {
			transparency = 1,
		},
		delay = 10,
		config = {
			mass = 1,
			tension = 280,
			friction = 60,
		},
	})
	hooks.useEffect(function()
		-- Plays the snow storm ambience
		SoundSystemController:playSound(SoundKeys.SFX_SNOW_AMBIENCE)
	end, {})
	return Roact.createFragment({
		IntroScene = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			LayoutOrder = 99999,
		}, {
			Logo = Roact.createElement("ImageLabel", {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = logoStyle.transparency,
				Image = "rbxassetid://13425295067",
				ImageTransparency = logoStyle.transparency,
				ZIndex = 11,
			}),
			WarningFrame = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = warningStyle.transparency,
				ZIndex = 10,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			}, {
				WarningText = Roact.createElement("TextLabel", {
					Size = UDim2.fromScale(1, 1),
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.fromScale(0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = warningStyle.transparency,
					Text = "Traverse this world with eyes wide open, for it teems with erratic shadows that blink in and out of existence, abrupt horrors that leap from the stillness, and an omnipresent gloom woven intricately to unsettle the heart and soul. ",
					TextColor3 = Color3.new(1, 1, 1),
					FontSize = Enum.FontSize.Size10,
					TextWrapped = true,
					TextTransparency = warningStyle.transparency,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					ZIndex = 11,
				}),
			}),
		}),
	})
end
return Hooks.new(Roact)(WarningScreen)
