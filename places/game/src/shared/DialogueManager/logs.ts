import { characters } from "./characters";
import { GameDialogue } from "./dialogue-model";

export const dialogues: GameDialogue[] = [
	{
		id: "D1",
		type: "CharacterToCharacter",
		character1: characters[0],
		character2: characters[1],
		lines: ["I need to get this gate working."],
	},

	{
		id: "D2",
		type: "CharacterToCharacter",
		character1: characters[0],
		character2: characters[1],
		lines: ["I got the gate working!"],
	},

	{
		id: "S1",
		type: "CharacterToCharacter",
		character1: characters[1],
		character2: characters[0],
		lines: ["...Heeds my words, adventurer. Now cometh the time of reckoning of the gods."],
	},
	// ... other dialogues
];
