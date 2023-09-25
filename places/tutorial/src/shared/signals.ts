import Signal from "@rbxts/signal";

// Handle client signals here
// This is primarily for Roact Component and Flamework Controller communication
export const Signals = {
	switchToPlayHUD: new Signal(),
	switchToCutsceneHUD: new Signal(),
	switchToLobbyHUD: new Signal(),
	switchToShopHUD: new Signal(),

	playerElevationChanged: new Signal<(player: Player, elevation: number) => void>(),

	//Mouse Hiding for narrative systems
	hideMouse: new Signal(),
	showMouse: new Signal(),
	mouseColor: new Signal<(color: Color3) => void>(),

	//Game Flow
	finishedTitleScreen: new Signal(),
	finishedIntroduction: new Signal(),
	finishedWakingUp: new Signal(),

	//Spectating
	switchToPreviousPlayer: new Signal(),
	switchToNextPlayer: new Signal(),

	//Music System
	playMusic: new Signal(),
	stopMusic: new Signal(),

	// AI System
	enableJumpScareEvent: new Signal(),
};
