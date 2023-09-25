//TODO: Since both shop UI and shop in game are indepedent, they should communicate and not open if oen of them are open

//Two Way Communication with Shop UI for both UI (Base) and Game (Merchant) Interaction

//TODO: does not work sometimes...tab are different when doing it repetitively
let isCurrentlyOpen = false;
let currentTab = "Play";
let pageVisible = "play";

export function getPageVisible() {
	return pageVisible;
}

export function setPageVisibleGlob(name: string) {
	pageVisible = name;
}

export function getCurrentTab() {
	return currentTab;
}

export function setCurrentTab(name: string) {
	currentTab = name;
}
export function setIsCurrentlyOpen(state: boolean) {
	isCurrentlyOpen = state;
}

export function getIsCurrentlyOpen() {
	return isCurrentlyOpen;
}
