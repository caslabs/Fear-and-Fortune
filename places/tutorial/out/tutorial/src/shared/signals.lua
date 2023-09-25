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
	playerElevationChanged = Signal.new(),
	hideMouse = Signal.new(),
	showMouse = Signal.new(),
	mouseColor = Signal.new(),
	finishedTitleScreen = Signal.new(),
	finishedIntroduction = Signal.new(),
	finishedWakingUp = Signal.new(),
	switchToPreviousPlayer = Signal.new(),
	switchToNextPlayer = Signal.new(),
	playMusic = Signal.new(),
	stopMusic = Signal.new(),
	enableJumpScareEvent = Signal.new(),
}
return {
	Signals = Signals,
}
