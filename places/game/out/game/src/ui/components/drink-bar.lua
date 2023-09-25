-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local DrinkBar = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local isVisible, setIsVisible = useState(false)
	local duration, setDuration = useState(0)
	useEffect(function()
		-- listen to drink bar events
		local showDrinkBarConnection = Signals.showDrinkBar:Connect(function(isVisible)
			setIsVisible(isVisible)
		end)
		local updateDrinkBar = Signals.updateDrinkBar:Connect(function(duration)
			if duration == 100 then
				setDuration(0)
			else
				setDuration(duration)
			end
		end)
		return function()
			showDrinkBarConnection:Disconnect()
			updateDrinkBar:Disconnect()
		end
	end, {})
	return Roact.createElement("TextLabel", {
		Position = UDim2.new(0.5, 0, 0.85, 0),
		Size = UDim2.new(0.5, 0, 0.02, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		Text = "",
		Visible = isVisible,
	}, {
		Roact.createElement("TextLabel", {
			Text = "",
			Size = UDim2.new(duration / 100, 0, 1, 0),
			BackgroundTransparency = 0.8,
			Visible = true,
			BackgroundColor3 = Color3.new(0.8, 0.84, 0.8),
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0, 0),
		}),
	})
end
local default = Hooks.new(Roact)(DrinkBar)
return {
	default = default,
}
