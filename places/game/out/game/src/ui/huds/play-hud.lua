-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Pages = TS.import(script, script.Parent.Parent, "Context").Pages
local Panel = TS.import(script, script.Parent.Parent, "Panels", "Panel").Panel
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local SprintBar = TS.import(script, script.Parent.Parent, "components", "sprint-bar").default
local HungerBar = TS.import(script, script.Parent.Parent, "components", "Survival", "hunger-bar").default
local ThirstBar = TS.import(script, script.Parent.Parent, "components", "Survival", "thirst-bar").default
local Morale = TS.import(script, script.Parent.Parent, "components", "Survival", "morale").default
local ExposureBar = TS.import(script, script.Parent.Parent, "components", "Survival", "exposure-bar").default
local UpdateSanityEvent = Remotes.Client:Get("UpdateSanityEvent")
local UpdateElevationEvent = Remotes.Client:Get("UpdateElevationEvent")
-- TODO: Experimental Gas Mask Breahting
local gasMaskBreathing = Instance.new("Sound")
gasMaskBreathing.SoundId = "rbxassetid://13868760171"
gasMaskBreathing.Volume = 0.5
gasMaskBreathing.Looped = true
gasMaskBreathing.Parent = game:GetService("SoundService")
print("Initializing PLAYHUD")
local PlayHUD = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local sanity, setSanity = useState(100)
	local stamina, setStamina = useState(100)
	local hunger, setHunger = useState(100)
	local thirst, setThirst = useState(100)
	local exposure, setExposure = useState(100)
	local morale, setMorale = useState(0)
	local elevation, setElevation = useState(0)
	local isWearingMask, setIsWearingMask = useState(false)
	-- Bind G to toggle mask
	--[[
		ContextActionService.BindAction(
		"toggleMask",
		(_, s) => {
		if (s === Enum.UserInputState.Begin) {
		if (isWearingMask) {
		setIsWearingMask(false);
		gasMaskBreathing.Stop();
		} else {
		setIsWearingMask(true);
		SoundSystemController.playSound(SoundKeys.SFX_DEPLOY_MASK);
		gasMaskBreathing.Play();
		}
		}
		},
		true,
		Enum.KeyCode.G,
		);
	]]
	useEffect(function()
		local connection2 = Signals.playerElevationChanged:Connect(function(player, newElevation)
			if player == Players.LocalPlayer then
				-- Meters ?
				local elevationInMeters = newElevation * 0.508
				local roundedElevationInMeters = math.round(elevationInMeters) / 10
				setElevation(roundedElevationInMeters)
			end
		end)
		local connection = Signals.StaminaUpdate:Connect(function(player, newStamina)
			if player == Players.LocalPlayer then
				setStamina(newStamina)
			end
		end)
		-- Hunger
		local hungerConnection = Signals.HungerUpdate:Connect(function(player, newHunger)
			if player == Players.LocalPlayer then
				setHunger(newHunger)
			end
		end)
		-- Thirst
		local thirstConnection = Signals.ThirstUpdate:Connect(function(player, newThirst)
			if player == Players.LocalPlayer then
				setThirst(newThirst)
			end
		end)
		-- Morale
		local moraleConnection = Signals.MoraleUpdate:Connect(function(player, newMorale)
			if player == Players.LocalPlayer then
				setMorale(newMorale)
			end
		end)
		-- Exposure
		local exposureConnection = Signals.ExposureUpdate:Connect(function(player, newExposure)
			if player == Players.LocalPlayer then
				setExposure(newExposure)
			end
		end)
		return function()
			connection:Disconnect()
			connection2:Disconnect()
			hungerConnection:Disconnect()
			thirstConnection:Disconnect()
			moraleConnection:Disconnect()
			exposureConnection:Disconnect()
		end
	end, {})
	UpdateSanityEvent:Connect(function(player, sanity)
		if player == Players.LocalPlayer then
			setSanity(sanity)
		end
	end)
	return Roact.createElement(Panel, {
		index = Pages.play,
		visible = props.visible,
	}, {
		Roact.createElement("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Image = "rbxassetid://6127325184",
			BackgroundTransparency = 1,
			Visible = isWearingMask,
			ZIndex = -10,
		}),
		Roact.createElement(SprintBar, {
			staminaD = stamina,
		}),
		Roact.createElement(HungerBar, {
			hunger = hunger,
		}),
		Roact.createElement(ThirstBar, {
			thirst = thirst,
		}),
		Roact.createElement(ExposureBar, {
			exposure = exposure,
		}),
		Roact.createElement(Morale, {
			morale = morale,
		}),
	})
end
local default = Hooks.new(Roact)(PlayHUD)
return {
	default = default,
}
