export enum GameEventType {
	RandomDialogue,
	JumpScare,
	PlayerEnteredArea,
	Cutscene,
	FX,
	PostProcessing,
	Notification,
	// ... other event types
	AwardBadge,

	//High Game Flow Events
	PlayerJoined, // a new player has joined the game
	PlayerLeft, // a player has left the game
	StartGame, // game starts and players are spawned into the world
	GameInProgress, // the main game phase where hunting happens
	EndGame, // game ends (either by winning, losing, or timeout) - Show end game stats
	WinGame, // win condition has been met
	LoseGame, // lose condition has been met
	ReturnToLobby,
}
