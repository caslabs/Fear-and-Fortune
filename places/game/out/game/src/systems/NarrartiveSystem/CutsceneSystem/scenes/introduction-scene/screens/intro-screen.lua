-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local IntroScreen = function(props, hooks)
	local isLoading, setIsLoading = hooks.useState("Awaiting Players")
	hooks.useEffect(function()
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
				local loadingText = "Awaiting Players" .. dots
				setIsLoading(loadingText)
				TS.await(TS.Promise.delay(0.5))
			end
		end)
		local handleEffect = TS.async(function()
			-- Start animation
			updateLoading()
		end)
		handleEffect()
	end, {})
	hooks.useEffect(function()
		-- Temporary hack? Hides the mouse for the duration of the animation
		local startTime = tick()
		local connection
		-- Create a connection to the Stepped event
		connection = RunService.Stepped:Connect(function()
			if tick() - startTime >= 7 then
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
			BackgroundTransparency = 0,
			LayoutOrder = 99999,
		}, {
			WarningFrame = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 0,
				ZIndex = 10,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			}, {
				WarningText = Roact.createElement("TextLabel", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 0,
					Text = isLoading,
					TextColor3 = Color3.new(1, 1, 1),
					TextWrapped = true,
					FontSize = Enum.FontSize.Size12,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					ZIndex = 11,
				}),
			}),
		}),
	})
end
return Hooks.new(Roact)(IntroScreen)
