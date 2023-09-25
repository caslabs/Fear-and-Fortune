import { DialogueManager } from "shared/DialogueManager/DialogueManager";
import { EventManager } from "../EventManager";
import { GameEventType } from "../eventTypes";
import { dialogues } from "shared/DialogueManager/logs";

interface RandomDialogueEventData {
	dialogueId: string;
}

export class RandomDialogueManager {
	private dialogueManager: DialogueManager;

	constructor(eventManager: EventManager) {
		this.dialogueManager = new DialogueManager(dialogues);
		eventManager.registerListener(GameEventType.RandomDialogue, (eventData: any) =>
			this.handleRandomDialogue(eventData),
		);
	}

	handleRandomDialogue(eventData: RandomDialogueEventData) {
		// ... play the random dialogue
		this.dialogueManager.startDialogue(eventData.dialogueId);
	}
}
