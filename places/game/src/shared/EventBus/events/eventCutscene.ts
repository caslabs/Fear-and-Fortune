import { CutsceneManager } from "shared/CutsceneManager";
import { EventManager } from "../EventManager";
import { GameEventType } from "../eventTypes";

interface EventCutsceneData {
	cutsceneId: string;
}

export class EventCutsceneManager {
	private cutsceneManager: CutsceneManager;

	constructor(eventManager: EventManager) {
		this.cutsceneManager = CutsceneManager.getInstance();
		eventManager.registerListener(GameEventType.Cutscene, (eventData: any) => this.handleCutscene(eventData));
	}

	handleCutscene(eventData: EventCutsceneData) {
		const cutsceneId = eventData.cutsceneId as string;
		this.cutsceneManager.loadCutscene(cutsceneId);
		//this.cutsceneManager.playCutscene();
		this.cutsceneManager.playCutscene();
	}
}
