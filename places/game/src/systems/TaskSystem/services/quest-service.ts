import { QUEST_DATABASE, Quest, QuestData, QuestId } from "./quest";
import { OnStart, Service } from "@flamework/core";

interface QuestObserver {
	onQuestCompleted(questId: QuestId): void;
}

/*
This Quest System operates under DAG system
works well for Linear, Open, and Pre-Req Quests

*/
@Service({})
export default class QuestSystemService implements OnStart {
	private quests: Map<QuestId, Quest> = new Map();
	private observers: QuestObserver[] = [];

	public onStart() {
		this.loadQuestsFromDatabase(QUEST_DATABASE);
		print("QuestSystem Service Started");
	}

	private loadQuestsFromDatabase(data: QuestData) {
		for (const questData of data.quests) {
			const quest = new Quest(questData.id, questData.name, "");
			quest.prerequisites = questData.prerequisites;
			this.quests.set(quest.id, quest);
		}
	}

	public addQuestObserver(observer: QuestObserver) {
		this.observers.push(observer);
	}

	public completeQuest(id: QuestId) {
		const quest = this.quests.get(id);
		if (!quest) {
			print("Quest not found.");
			return;
		}

		const prerequisitesCompleted = quest.prerequisites.every((prereqId) => this.quests.get(prereqId)?.completed);
		if (!prerequisitesCompleted) {
			print(`Cannot complete ${quest.name} yet. Prerequisites not met.`);
			return;
		}

		quest.completed = true;
		print(`${quest.name} completed!`);

		for (const observer of this.observers) {
			observer.onQuestCompleted(id);
		}
	}
}

enum GameEvent {
	SpawnBoss,
	OpenGate,
	PlayCutscene,
}

const EVENT_DATABASE: Map<QuestId, GameEvent[]> = new Map([
	["fightBoss", [GameEvent.SpawnBoss]],
	// ... other quest to event mappings
]);

class GameEventHandler implements QuestObserver {
	public onQuestCompleted(questId: QuestId): void {
		const eventsToTrigger = EVENT_DATABASE.get(questId);
		if (eventsToTrigger) {
			for (const gameEvent of eventsToTrigger) {
				switch (gameEvent) {
					case GameEvent.SpawnBoss:
						print("Spawning the boss...");
						// Call the function to spawn the boss
						break;
					// ... handle other game events
				}
			}
		}
	}
}
