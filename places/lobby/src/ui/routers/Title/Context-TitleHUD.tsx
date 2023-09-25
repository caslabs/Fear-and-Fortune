import Roact from "@rbxts/roact";

// A map of the pages to have consistency
export const Pages = {
	none: 0,
	title: 1,
};

// The context used for page swapping
export const Context = Roact.createContext({
	viewIndex: 0,
	setPage: (index: number) => {},
});
