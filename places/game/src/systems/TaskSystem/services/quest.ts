export type QuestId = string;

export class Quest {
	id: QuestId;
	name: string;
	description: string;
	prerequisites: QuestId[] = [];
	completed = false;

	constructor(id: QuestId, name: string, description: string) {
		this.id = id;
		this.name = name;
		this.description = description;
	}
}

export type QuestData = {
	quests: {
		id: QuestId;
		name: string;
		prerequisites: QuestId[];
	}[];
};

export const QUEST_DATABASE: QuestData = {
	quests: [
		{
			id: "ignite",
			name: "Ignite 5 candles",
			prerequisites: [],
		},
		{
			id: "openDoor",
			name: "Open Captain's Door",
			prerequisites: ["ignite"],
		},
		{
			id: "takeBook",
			name: "Take Book",
			prerequisites: ["openDoor"],
		},
		{
			id: "takeGun",
			name: "Take Gun",
			prerequisites: ["openDoor"],
		},
		{
			id: "takeSword",
			name: "Take Sword",
			prerequisites: ["openDoor"],
		},
		{
			id: "fightBoss",
			name: "Fight Boss",
			prerequisites: ["takeBook", "takeGun", "takeSword"],
		},
	],
};
