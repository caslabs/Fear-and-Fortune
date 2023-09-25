export enum MusicKeys {
	INTRODUCTION_MUSIC,
	DEATH_MUSIC,
	TIK_TOK,
	LOBBY_MUSIC,
	CREDIT_MUSIC,
	// Add as many as needed...
}

export const MusicData: Map<MusicKeys, string> = new Map([
	[MusicKeys.INTRODUCTION_MUSIC, "13868762411"],
	[MusicKeys.DEATH_MUSIC, "13874999247"],
	[MusicKeys.TIK_TOK, "13871000866"],
	[MusicKeys.LOBBY_MUSIC, "13897726069"],
	[MusicKeys.CREDIT_MUSIC, "14211418871"],
	// Add as many as needed...
]);
