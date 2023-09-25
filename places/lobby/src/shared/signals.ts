import Signal from "@rbxts/signal";

export enum QueueState {
	Idle,
	Searching,
	ServerFound,
	EmbarkFailed,
}

// Handle client signals here
// This is primarily for Roact Component and Flamework Controller communication
export const Signals = {
	switchToLobbyHUD: new Signal(),
	switchToTitleHUD: new Signal(),

	//Mouse Hiding for narrative systems
	hideMouse: new Signal(),
	showMouse: new Signal(),
	mouseColor: new Signal<(color: Color3) => void>(),

	//Game Flow
	finishedTitleScreen: new Signal(),
	finishedLobbyScreen: new Signal(),

	//Music System
	playMusic: new Signal(),
	stopMusic: new Signal(),

	//Lobby System
	currentProfession: new Signal(),

	//Match Making System
	queueStateChangedSignal: new Signal<(newQueueState: QueueState) => void>(),
	startCountdownSignal: new Signal<(time: number) => void>(),
	endCountdownSignal: new Signal<() => void>(),
	embarkFailedSignal: new Signal<() => void>(),
	startGameSignal: new Signal(),

	//Credit Screen
	OnCreditScreenExit: new Signal(),

	//Badges
	playerFirstJoinSignal: new Signal<(player: Player) => void>(),
	playerLastSurvivorSignal: new Signal<(player: Player) => void>(),
	playerSoloWinnerSignal: new Signal<(player: Player) => void>(),
	playerFirstGameSignal: new Signal<(player: Player) => void>(),
};
