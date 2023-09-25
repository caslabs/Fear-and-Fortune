-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local TweenService = TS.import(script, TS.getModule(script, "@rbxts", "services")).TweenService
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local WakeUpScene = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local topBar, setTopBar = useState(nil)
	local bottomBar, setBottomBar = useState(nil)
	local animationSpeed = 0.1
	local initialDelay = 2.5
	local animateBar
	useEffect(function()
		local _exp = TS.Promise.delay(initialDelay)
		local _arg0 = function()
			if topBar and bottomBar then
				local topTween = animateBar(topBar, UDim2.new(0, 0, -0.5, 0))
				local bottomTween = animateBar(bottomBar, UDim2.new(0, 0, 1.5, 0))
				local _exp_1 = TS.Promise.delay(animationSpeed)
				local _arg0_1 = function()
					print("Waking up is done")
					Signals.finishedWakingUp:Fire()
				end
				_exp_1:andThen(_arg0_1)
				-- Return a cleanup function that will be called when the component is unmounted
				return function()
					if topTween then
						topTween:Cancel()
					end
					if bottomTween then
						bottomTween:Cancel()
					end
				end
			end
		end
		_exp:andThen(_arg0)
	end, { topBar, bottomBar })
	animateBar = function(bar, targetPosition)
		local tweenInfo = TweenInfo.new(animationSpeed)
		local goal = {
			Position = targetPosition,
		}
		local tween = TweenService:Create(bar, tweenInfo, goal)
		tween:Play()
		return tween
	end
	return Roact.createFragment({
		WakeUpSceneFrame = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
		}, {
			TopBar = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0.5, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = Color3.new(0, 0, 0),
				[Roact.Ref] = setTopBar,
			}),
			BottomBar = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0.5, 0),
				Position = UDim2.new(0, 0, 0.5, 0),
				BackgroundColor3 = Color3.new(0, 0, 0),
				[Roact.Ref] = setBottomBar,
				BorderMode = Enum.BorderMode.Outline,
				BorderSizePixel = 0,
			}),
		}),
	})
end
return Hooks.new(Roact)(WakeUpScene)
