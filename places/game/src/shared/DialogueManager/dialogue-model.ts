import { Character } from "./characters";

export interface Dialogue {
	id: string;
	lines: string[];
	character1?: Character;
}

export interface CharacterToCharacterDialogue extends Dialogue {
	type: "CharacterToCharacter";
	character1: Character;
	character2: Character;
}

export interface CharacterToPlayerDialogue extends Dialogue {
	type: "CharacterToPlayer";
	character: Character;
}

export interface CharacterToPlayersDialogue extends Dialogue {
	type: "CharacterToPlayers";
	character: Character;
	players: Character[];
}

export type GameDialogue = CharacterToCharacterDialogue | CharacterToPlayerDialogue | CharacterToPlayersDialogue;
