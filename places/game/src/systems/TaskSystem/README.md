The task systems is a list of tasks that can dynamically added or removed within the game systems.

Data-Driven Design: You're right; the system leans towards data-driven design due to the externalization of quests. The quests can be defined, modified, and expanded upon outside the core game logic, usually from a database or an external configuration file. This makes it easier to expand or modify the content without having to change the game's core codebase.

Directed Acyclic Graph (DAG): The structure by which quests have prerequisites (and those prerequisites can have their own prerequisites) inherently forms a DAG. This is useful for modeling quest progression, as it ensures there are no cycles (e.g., quest A requires quest B, which requires quest A) and provides a clear, directed progression.

Observer Pattern: By having an event system that reacts to the completion of certain quests (like triggering cutscenes or spawning bosses), you're implementing the Observer pattern. The QuestSystem acts as an observable, and the event handlers (like playCutscene or spawnBoss) act as observers. When a quest is completed, the system "notifies" the relevant observers to react accordingly.

Registry/Database Pattern: The EventDatabase can be seen as implementing a variation of the Registry pattern. You have centralized access to events associated with quests. The database provides a unified point where these associations can be registered and triggered.

Command Pattern: If you look closely, the functions associated with quests (like spawnBoss, playCutscene, etc.) are encapsulated actions that can be executed. Associating these functions with quests essentially queues them up to be executed at the appropriate time, which is reminiscent of the Command pattern.



# DAG Quest Designs

The flexibility of the DAG structure allows it to represent a variety of quest progressions. Here are some examples tailored to different types of games:

1. Simple Linear Story
This is a straightforward, linear progression where each quest must be completed in order to unlock the next.

typescript
Copy code
export const LINEAR_STORY: QuestData = {
	quests: [
		{
			id: "meetHero",
			name: "Meet the Hero",
			prerequisites: [],
		},
		{
			id: "findMap",
			name: "Find the Map",
			prerequisites: ["meetHero"],
		},
		{
			id: "findTreasure",
			name: "Find the Treasure",
			prerequisites: ["findMap"],
		},
	],
};
2. Branching Story
In this example, the player has choices that lead to different paths in the story.

typescript
Copy code
export const BRANCHING_STORY: QuestData = {
	quests: [
		{
			id: "meetStranger",
			name: "Meet the Mysterious Stranger",
			prerequisites: [],
		},
		{
			id: "helpStranger",
			name: "Help the Stranger",
			prerequisites: ["meetStranger"],
		},
		{
			id: "betrayStranger",
			name: "Betray the Stranger",
			prerequisites: ["meetStranger"],
		},
		{
			id: "getReward",
			name: "Receive a Reward",
			prerequisites: ["helpStranger"],
		},
		{
			id: "fightStranger",
			name: "Fight the Stranger",
			prerequisites: ["betrayStranger"],
		},
	],
};
In the above, meeting the stranger leads to a choice: help or betray them. Each choice has subsequent quests.

3. RPG Story with Parallel Quests
This example depicts a scenario where the player can take on multiple quests in an RPG setting. Some quests are independent of each other, while others have prerequisites.

typescript
Copy code
export const RPG_STORY: QuestData = {
	quests: [
		{
			id: "meetGuild",
			name: "Join the Adventurer's Guild",
			prerequisites: [],
		},
		{
			id: "slayDragon",
			name: "Slay the Dragon",
			prerequisites: ["meetGuild"],
		},
		{
			id: "rescueVillagers",
			name: "Rescue the Villagers",
			prerequisites: ["meetGuild"],
		},
		{
			id: "findArtifact",
			name: "Find the Lost Artifact",
			prerequisites: [],
		},
		{
			id: "defeatWarlord",
			name: "Defeat the Warlord",
			prerequisites: ["slayDragon", "rescueVillagers"],
		},
	],
};
Here, after joining the guild, the player can choose to slay a dragon, rescue villagers, or find a lost artifact, with some quests interdependent.

These examples demonstrate the versatility of your quest system. By simply adjusting the prerequisites, you can craft unique narratives and progressions suitable for various game genres.
