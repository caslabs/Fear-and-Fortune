-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- types.ts
local segmentHandlers = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "LevelSystem", "segment-handlers")
local Handlers
do
	local _inverse = {}
	Handlers = setmetatable({}, {
		__index = _inverse,
	})
	Handlers.HandleCutscene = "handleCutscene"
	_inverse.handleCutscene = "HandleCutscene"
	Handlers.HandleLevelSegment1Enter = "handleLevelSegment1Enter"
	_inverse.handleLevelSegment1Enter = "HandleLevelSegment1Enter"
	Handlers.HandleFogEnter = "handleFogEnter"
	_inverse.handleFogEnter = "HandleFogEnter"
	Handlers.HandleFogExit = "handleFogExit"
	_inverse.handleFogExit = "HandleFogExit"
end
return {
	Handlers = Handlers,
}
