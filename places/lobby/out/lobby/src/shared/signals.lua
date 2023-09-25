-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
local QueueState
do
	local _inverse = {}
	QueueState = setmetatable({}, {
		__index = _inverse,
	})
	QueueState.Idle = 0
	_inverse[0] = "Idle"
	QueueState.Searching = 1
	_inverse[1] = "Searching"
	QueueState.ServerFound = 2
	_inverse[2] = "ServerFound"
	QueueState.EmbarkFailed = 3
	_inverse[3] = "EmbarkFailed"
end
-- Handle client signals here
-- This is primarily for Roact Component and Flamework Controller communication
local Signals = {
	switchToLobbyHUD = Signal.new(),
	switchToTitleHUD = Signal.new(),
	hideMouse = Signal.new(),
	showMouse = Signal.new(),
	mouseColor = Signal.new(),
	finishedTitleScreen = Signal.new(),
	finishedLobbyScreen = Signal.new(),
	playMusic = Signal.new(),
	stopMusic = Signal.new(),
	currentProfession = Signal.new(),
	queueStateChangedSignal = Signal.new(),
	startCountdownSignal = Signal.new(),
	endCountdownSignal = Signal.new(),
	embarkFailedSignal = Signal.new(),
	startGameSignal = Signal.new(),
	OnCreditScreenExit = Signal.new(),
	playerFirstJoinSignal = Signal.new(),
	playerLastSurvivorSignal = Signal.new(),
	playerSoloWinnerSignal = Signal.new(),
	playerFirstGameSignal = Signal.new(),
}
return {
	QueueState = QueueState,
	Signals = Signals,
}
