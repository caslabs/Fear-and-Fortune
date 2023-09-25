import { DialogueManager } from "shared/DialogueManager/DialogueManager";
import { EventManager } from "../EventManager";
import { GameEventType } from "../eventTypes";
import { dialogues } from "shared/DialogueManager/logs";
import { BadgeManager } from "shared/BadgeManager";

interface AwardBadgeEventData {
	players: number[];
	badgeId: number;
}

export class AwardBadgeHandler {
	private badgeManager: BadgeManager;

	constructor(eventManager: EventManager) {
		this.badgeManager = BadgeManager.getInstance();
		eventManager.registerListener(GameEventType.AwardBadge, (eventData: any) => this.handleAwardBadge(eventData));
	}

	//TODO: try this
	handleAwardBadge(eventData: AwardBadgeEventData) {
		this.badgeManager.awardBadgeToPlayers(eventData.players, eventData.badgeId);
	}
}
