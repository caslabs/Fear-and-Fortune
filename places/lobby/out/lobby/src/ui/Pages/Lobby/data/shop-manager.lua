-- Compiled with roblox-ts v1.3.3
-- TODO: Since both shop UI and shop in game are indepedent, they should communicate and not open if oen of them are open
-- Two Way Communication with Shop UI for both UI (Base) and Game (Merchant) Interaction
-- TODO: does not work sometimes...tab are different when doing it repetitively
local isCurrentlyOpen = false
local currentTab = "Play"
local pageVisible = "play"
local function getPageVisible()
	return pageVisible
end
local function setPageVisibleGlob(name)
	pageVisible = name
end
local function getCurrentTab()
	return currentTab
end
local function setCurrentTab(name)
	currentTab = name
end
local function setIsCurrentlyOpen(state)
	isCurrentlyOpen = state
end
local function getIsCurrentlyOpen()
	return isCurrentlyOpen
end
return {
	getPageVisible = getPageVisible,
	setPageVisibleGlob = setPageVisibleGlob,
	getCurrentTab = getCurrentTab,
	setCurrentTab = setCurrentTab,
	setIsCurrentlyOpen = setIsCurrentlyOpen,
	getIsCurrentlyOpen = getIsCurrentlyOpen,
}
