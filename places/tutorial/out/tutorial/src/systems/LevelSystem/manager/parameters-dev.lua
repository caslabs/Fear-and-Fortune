-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- parameters.ts
local _segment_handlers = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "LevelSystem", "segment-handlers")
local handleLevelSegment1Enter = _segment_handlers.handleLevelSegment1Enter
local handleFogEnter = _segment_handlers.handleFogEnter
local handleFogExit = _segment_handlers.handleFogExit
local handleAISpawn = _segment_handlers.handleAISpawn
local handleCutsceneEnter = _segment_handlers.handleCutsceneEnter
local handleCutsceneExit = _segment_handlers.handleCutsceneExit
local handleEeryMusicEnter = _segment_handlers.handleEeryMusicEnter
local handleTutorialNode = _segment_handlers.handleTutorialNode
local handleBaseCampNode = _segment_handlers.handleBaseCampNode
local params = {
	TutorialNode = {
		sequential = {},
		concurrent = { handleTutorialNode },
	},
	BaseCampNode = {
		sequential = {},
		concurrent = { handleBaseCampNode, handleEeryMusicEnter },
	},
	LevelSegment1 = {
		sequential = { handleLevelSegment1Enter },
		concurrent = { handleFogEnter, handleAISpawn, handleEeryMusicEnter },
	},
	LevelSegment2 = {
		sequential = {},
		concurrent = { handleAISpawn },
	},
	LevelSegment3 = {
		sequential = {},
		concurrent = { handleAISpawn, handleFogExit },
	},
	DEEP_CREVASS = {
		sequential = {},
		concurrent = { handleCutsceneEnter, handleCutsceneExit },
	},
	ABANDONED_CAMPSITE = {
		sequential = {},
		concurrent = { handleCutsceneEnter, handleCutsceneExit },
	},
	SHRINE_OF_SHADOWS = {
		sequential = {},
		concurrent = { handleCutsceneEnter, handleCutsceneExit },
	},
	ABADONED_RESEARCH_LAB = {
		sequential = {},
		concurrent = { handleCutsceneEnter, handleCutsceneExit },
	},
	FROZEN_CAVE = {
		sequential = {},
		concurrent = { handleCutsceneEnter, handleCutsceneExit },
	},
	DESOLATED_FOREST = {
		sequential = {},
		concurrent = { handleCutsceneEnter, handleCutsceneExit },
	},
	ABYSALL_CAVERN = {
		sequential = {},
		concurrent = { handleCutsceneEnter, handleCutsceneExit },
	},
	YETI_LAIR = {
		sequential = {},
		concurrent = { handleCutsceneEnter, handleCutsceneExit },
	},
}
return {
	params = params,
}
