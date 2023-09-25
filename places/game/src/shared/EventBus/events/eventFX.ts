import { EventManager } from "../EventManager";
import { GameEventType } from "../eventTypes";
import { FXManager } from "shared/FXManager";

interface EventFxData {
	fxId: string;
}

export class EventFx {
	private FXManager: FXManager;

	constructor(eventManager: EventManager) {
		this.FXManager = FXManager.getInstance();
		eventManager.registerListener(GameEventType.FX, (eventData: EventFxData) => this.handleFXEvent(eventData));
	}

	private handleFXEvent(eventData: EventFxData) {
		const fxId = eventData.fxId as string;
		// Play the specified FX using the FXManager
		this.FXManager.playFX({ templateId: fxId });
	}
}
