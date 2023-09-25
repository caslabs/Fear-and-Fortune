-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Pages = TS.import(script, script.Parent.Parent.Parent, "ui", "Context").Pages
local Panel = TS.import(script, script.Parent.Parent.Parent, "ui", "Panels", "Panel").Panel
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local StaminaUpdate = TS.import(script, script.Parent.Parent.Parent, "MechanicsController", "PlayerMechanics", "SprintMechanic", "stamina-sprint-controller").StaminaUpdate
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local SprintBar = TS.import(script, script.Parent.Parent.Parent, "ui", "components", "sprint-bar").default
local ContextActionService = TS.import(script, TS.getModule(script, "@rbxts", "services")).ContextActionService
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local UpdateSanityEvent = Remotes.Client:Get("UpdateSanityEvent")
local UpdateElevationEvent = Remotes.Client:Get("UpdateElevationEvent")
-- TODO: Experimental Gas Mask Breahting
local gasMaskBreathing = Instance.new("Sound")
gasMaskBreathing.SoundId = "rbxassetid://13868760171"
gasMaskBreathing.Volume = 0.5
gasMaskBreathing.Looped = true
gasMaskBreathing.Parent = game:GetService("SoundService")
local SherpaHUD = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local sanity, setSanity = useState(100)
	local stamina, setStamina = useState(100)
	local elevation, setElevation = useState(0)
	local isWearingMask, setIsWearingMask = useState(true)
	-- Bind G to toggle mask
	ContextActionService:BindAction("toggleMask", function(_, s)
		if s == Enum.UserInputState.Begin then
			if isWearingMask then
				setIsWearingMask(false)
				gasMaskBreathing:Stop()
			else
				setIsWearingMask(true)
				SoundSystemController:playSound(SoundKeys.SFX_DEPLOY_MASK)
				gasMaskBreathing:Play()
			end
		end
	end, true, Enum.KeyCode.G)
	useEffect(function()
		local connection2 = Signals.playerElevationChanged:Connect(function(player, newElevation)
			if player == Players.LocalPlayer then
				-- Meters ?
				local elevationInMeters = newElevation * 0.508
				local roundedElevationInMeters = math.round(elevationInMeters) / 10
				setElevation(roundedElevationInMeters)
			end
		end)
		local connection = StaminaUpdate:Connect(function(player, newStamina)
			if player == Players.LocalPlayer then
				setStamina(newStamina)
			end
		end)
		return function()
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {})
	UpdateSanityEvent:Connect(function(player, sanity)
		if player == Players.LocalPlayer then
			setSanity(sanity)
		end
	end)
	-- TODO: Server-Sided Update
	--[[
		UpdateElevationEvent.Connect((player, newElevation) => {
		if (player === Players.LocalPlayer) {
		setElevation(newElevation);
		}
		});
		<imagelabel
		Size={new UDim2(1, 0, 1, 0)}
		Image={"rbxassetid://13736545097"}
		BackgroundTransparency={1}
		Visible={isWearingMask}
		/>
	]]
	return Roact.createElement(Panel, {
		index = Pages.play,
		visible = props.visible,
	}, {
		Roact.createElement("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Image = "rbxassetid://13888497075",
			BackgroundTransparency = 1,
			Visible = isWearingMask,
			ZIndex = -10,
		}),
		Roact.createElement(SprintBar, {
			staminaD = stamina,
		}),
		Roact.createElement("TextLabel", {
			Text = "Elevation: " .. tostring(elevation + 5354) .. "m",
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0.2, 0, 0.2, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			FontSize = Enum.FontSize.Size18,
			Font = Enum.Font.GothamBold,
			ZIndex = -5,
		}),
	})
end
local default = Hooks.new(Roact)(SherpaHUD)
return {
	default = default,
}
