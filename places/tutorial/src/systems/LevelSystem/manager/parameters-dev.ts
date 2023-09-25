// parameters.ts
import {
	handleLevelSegment1Enter,
	handleFogEnter,
	handleFogExit,
	handleAISpawn,
	handleCutsceneEnter,
	handleCutsceneExit,
	handleEeryMusicEnter,
	handleTutorialNode,
	handleBaseCampNode,
} from "./segment-handlers";

export const params = {
	TutorialNode: {
		sequential: [],
		concurrent: [handleTutorialNode],
	},

	BaseCampNode: {
		sequential: [],
		concurrent: [handleBaseCampNode, handleEeryMusicEnter],
	},
	LevelSegment1: {
		sequential: [handleLevelSegment1Enter],
		concurrent: [handleFogEnter, handleAISpawn, handleEeryMusicEnter],
	},
	LevelSegment2: {
		sequential: [],
		concurrent: [handleAISpawn],
	},

	LevelSegment3: {
		sequential: [],
		concurrent: [handleAISpawn, handleFogExit],
	},

	DEEP_CREVASS: {
		sequential: [],
		concurrent: [handleCutsceneEnter, handleCutsceneExit],
	},

	ABANDONED_CAMPSITE: {
		sequential: [],
		concurrent: [handleCutsceneEnter, handleCutsceneExit],
	},

	SHRINE_OF_SHADOWS: {
		sequential: [],
		concurrent: [handleCutsceneEnter, handleCutsceneExit],
	},

	ABADONED_RESEARCH_LAB: {
		sequential: [],
		concurrent: [handleCutsceneEnter, handleCutsceneExit],
	},

	FROZEN_CAVE: {
		sequential: [],
		concurrent: [handleCutsceneEnter, handleCutsceneExit],
	},

	DESOLATED_FOREST: {
		sequential: [],
		concurrent: [handleCutsceneEnter, handleCutsceneExit],
	},

	ABYSALL_CAVERN: {
		sequential: [],
		concurrent: [handleCutsceneEnter, handleCutsceneExit],
	},

	YETI_LAIR: {
		sequential: [],
		concurrent: [handleCutsceneEnter, handleCutsceneExit],
	},
};
