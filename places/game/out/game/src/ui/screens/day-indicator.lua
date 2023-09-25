-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local RoactSpring = TS.import(script, TS.getModule(script, "@rbxts", "roact-spring").src)
local DayIndicator = function(props, hooks)
	local isClosing, setClosing = hooks.useState(false)
	local isOpening, setOpening = hooks.useState(true)
	local styles = RoactSpring.useSpring(hooks, {
		to = {
			transparency = if isClosing then 1 elseif isOpening then 1 else 0,
		},
		config = {
			mass = 1,
			tension = 280,
			friction = 60,
		},
	})
	hooks.useEffect(function()
		local isMounted = true
		spawn(function()
			wait(1)
			if isMounted then
				setOpening(false)
			end
		end)
		return function()
			isMounted = false
		end
	end, {})
	hooks.useEffect(function()
		local isMounted = true
		if not isOpening then
			spawn(function()
				wait(100)
				if isMounted then
					setClosing(true)
				end
			end)
		end
		return function()
			isMounted = false
		end
	end, { isOpening })
	return Roact.createFragment({
		DayIndicatorPopup = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0, 0, 0),
			LayoutOrder = 999,
		}, {
			DayIndicatorText = Roact.createElement("TextLabel", {
				TextSize = 25,
				BackgroundTransparency = 1,
				TextTransparency = styles.transparency,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 0, 30),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Text = props.title,
				TextColor3 = Color3.new(1, 1, 1),
				TextXAlignment = "Center",
				TextYAlignment = "Center",
				TextWrapped = true,
				TextScaled = true,
				Font = Enum.Font.Merriweather,
				ZIndex = 9999999,
			}),
		}),
	})
end
return Hooks.new(Roact)(DayIndicator)
