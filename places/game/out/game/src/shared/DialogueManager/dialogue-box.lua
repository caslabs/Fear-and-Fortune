-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable @typescript-eslint/no-explicit-any
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local RoactSpring = TS.import(script, TS.getModule(script, "@rbxts", "roact-spring").src)
-- TODO connect to remote event listener: triggers function code onClick`
local DialogBox = function(props, hooks)
	local isClosing, setClosing = hooks.useState(false)
	local styles = RoactSpring.useSpring(hooks, {
		to = {
			transparency = if isClosing then 1 else 0,
		},
		config = {
			mass = 1,
			tension = 280,
			friction = 60,
		},
	})
	local isMounted = true
	hooks.useEffect(function()
		local closingTask = spawn(function()
			wait(4)
			if isMounted then
				setClosing(true)
			end
		end)
		return function()
			isMounted = false
		end
	end, {})
	local text, setText = hooks.useState("")
	local fullText, setFullText = hooks.useState(props.description)
	print("DialogBox initialized")
	-- TODO: Polish text animation
	hooks.useEffect(function()
		local tempText = ""
		local textAnimCoroutine = coroutine.wrap(function()
			for char in string.gmatch(fullText, utf8.charpattern) do
				tempText ..= char
				if isMounted then
					setText(tempText)
				end
				task.wait(0.02)
			end
		end)
		textAnimCoroutine()
		return function()
			isMounted = false
		end
	end, { fullText })
	return Roact.createFragment({
		ItemPopupText = Roact.createElement("Frame", {
			Size = UDim2.new(0.5, 0, 0.2, 0),
			Position = UDim2.new(0.25, 0, 0.6, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
		}, {
			Roact.createElement("UIListLayout", {
				SortOrder = "LayoutOrder",
				FillDirection = "Horizontal",
				HorizontalAlignment = "Left",
			}),
			Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 10),
			}),
			ItemPopupImage = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = props.image,
				Size = UDim2.fromScale(0.2, 1),
				LayoutOrder = -1,
				ImageTransparency = styles.transparency,
			}),
			Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
			}, {
				Roact.createElement("UIListLayout", {
					FillDirection = "Vertical",
					HorizontalAlignment = "Left",
				}),
				Roact.createElement("TextLabel", {
					TextSize = 25,
					BackgroundTransparency = 1,
					TextTransparency = styles.transparency,
					Size = UDim2.new(1, 0, 0.2, 0),
					Text = props.title,
					TextColor3 = Color3.new(1, 1, 1),
					TextXAlignment = "Left",
					TextYAlignment = "Bottom",
					TextWrapped = true,
					TextScaled = true,
				}),
				Roact.createElement("TextLabel", {
					TextSize = 15,
					BackgroundTransparency = 1,
					TextTransparency = styles.transparency,
					Size = UDim2.new(1, 0, 0.8, 0),
					TextColor3 = Color3.new(1, 1, 1),
					Text = text,
					TextXAlignment = "Left",
					TextYAlignment = "Top",
					TextWrapped = true,
					TextScaled = false,
				}),
			}),
		}),
	})
end
return Hooks.new(Roact)(DialogBox)
