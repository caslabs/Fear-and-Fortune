-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
-- A map of the pages to have consistency
local Pages = {
	none = 0,
	title = 1,
}
-- The context used for page swapping
local Context = Roact.createContext({
	viewIndex = 0,
	setPage = function(index) end,
})
return {
	Pages = Pages,
	Context = Context,
}
