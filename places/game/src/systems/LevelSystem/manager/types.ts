// types.ts

import * as segmentHandlers from "./segment-handlers";

export enum Handlers {
	HandleCutscene = "handleCutscene",
	HandleLevelSegment1Enter = "handleLevelSegment1Enter",
	HandleFogEnter = "handleFogEnter",
	HandleFogExit = "handleFogExit",
}

type HandlerKey = Handlers;

type Handler = () => Promise<void>;
export type ParamsType = { [key: string]: { sequential: HandlerKey[]; concurrent: HandlerKey[] } };
