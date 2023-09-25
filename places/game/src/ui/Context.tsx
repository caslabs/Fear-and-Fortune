import Roact from "@rbxts/roact";

// A map of the pages to have consistency
export const Pages = {
	none: 0,
	play: 1,
	cutscene: 2,
	spectate: 3,
	titleScreen: 4,
	merchant: 5,
	dialog: 6,
	inventory: 7,
	leaderboard: 8,
	postEvent: 9,
	craft: 10,
	setting: 11,
};

// The context used for page swapping
export const Context = Roact.createContext({
	viewIndex: 0,
	setPage: (index: number) => {},
});
