-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
-- Handle client signals here
-- This is primarily for Roact Component and Flamework Controller communication
local Signals = {
	switchToPlayHUD = Signal.new(),
	switchToCutsceneHUD = Signal.new(),
	switchToLobbyHUD = Signal.new(),
	switchToShopHUD = Signal.new(),
	switchToPlayHUDMID = Signal.new(),
	playerElevationChanged = Signal.new(),
	hideMouse = Signal.new(),
	showMouse = Signal.new(),
	mouseColor = Signal.new(),
	finishedTitleScreen = Signal.new(),
	finishedIntroduction = Signal.new(),
	finishedWakingUp = Signal.new(),
	switchToPreviousPlayer = Signal.new(),
	switchToNextPlayer = Signal.new(),
	ExitPortalTouched = Signal.new(),
	PlayerDied = Signal.new(),
	OnExitScreenClosed = Signal.new(),
	OpenCraft = Signal.new(),
	playMusic = Signal.new(),
	stopMusic = Signal.new(),
	jumpingStateChanged = Signal.new(),
	StaminaUpdate = Signal.new(),
	onStartStamina = Signal.new(),
	HungerUpdate = Signal.new(),
	ThirstUpdate = Signal.new(),
	ExposureUpdate = Signal.new(),
	showDrinkBar = Signal.new(),
	updateDrinkBar = Signal.new(),
	MoraleUpdate = Signal.new(),
	enableJumpScareEvent = Signal.new(),
	DropTool = Signal.new(),
	AddItem = Signal.new(),
	DropItem = Signal.new(),
	playerFirstJoinSignal = Signal.new(),
	playerLastSurvivorSignal = Signal.new(),
	playerSoloWinnerSignal = Signal.new(),
	playerFirstGameSignal = Signal.new(),
}
return {
	Signals = Signals,
}
