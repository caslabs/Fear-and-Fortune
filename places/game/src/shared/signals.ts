import Signal from "@rbxts/signal";

// Handle client signals here
// This is primarily for Roact Component and Flamework Controller communication
export const Signals = {
	switchToPlayHUD: new Signal(),
	switchToCutsceneHUD: new Signal(),
	switchToLobbyHUD: new Signal(),
	switchToShopHUD: new Signal(),
	switchToPlayHUDMID: new Signal(),

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

	//Game Flow
	ExitPortalTouched: new Signal(),
	PlayerDied: new Signal(),
	OnExitScreenClosed: new Signal(),

	//Crafting System
	OpenCraft: new Signal(),

	//Music System
	playMusic: new Signal(),
	stopMusic: new Signal(),

	//Stamina System
	jumpingStateChanged: new Signal<(isJumping: boolean) => void>(),
	StaminaUpdate: new Signal<(player: Player, stamina: number) => void>(),
	onStartStamina: new Signal<(isSprinting: boolean) => void>(),

	//Survival System
	HungerUpdate: new Signal<(player: Player, hunger: number) => void>(),
	ThirstUpdate: new Signal<(player: Player, thirst: number) => void>(),
	ExposureUpdate: new Signal<(player: Player, exposure: number) => void>(),
	showDrinkBar: new Signal<(duration: boolean) => void>(),
	updateDrinkBar: new Signal<(newDuration: number) => void>(),

	//Moral System
	MoraleUpdate: new Signal<(player: Player, morale: number) => void>(),

	// AI System
	enableJumpScareEvent: new Signal(),

	//Inventory System
	DropTool: new Signal<(item: string) => void>(),
	AddItem: new Signal<(player: Player, item: string) => void>(),

	//Return Model and Prompt
	DropItem: new Signal<(item: string, position: Vector3) => { model: Model; prompt: ProximityPrompt }>(),

	// Badges
	playerFirstJoinSignal: new Signal<(player: Player) => void>(),
	playerLastSurvivorSignal: new Signal<(player: Player) => void>(),
	playerSoloWinnerSignal: new Signal<(player: Player) => void>(),
	playerFirstGameSignal: new Signal<(player: Player) => void>(),
};
