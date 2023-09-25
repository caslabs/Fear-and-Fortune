import { Game, SoundManager } from "shared/sound-manager";
import { EventManager } from "../EventManager";
import { GameEventType } from "../eventTypes";

interface EventJumpScareData {
	jumpscareID: string;
}

export class EventJumpScareManager {
	soundManager: SoundManager;
	constructor(eventManager: EventManager) {
		this.soundManager = SoundManager.getInstance();
		eventManager.registerListener(GameEventType.JumpScare, (eventData: any) => this.handleJumpScare(eventData));
	}

	handleJumpScare(eventData: EventJumpScareData) {
		// ... play the random dialogue
		// Audio cues: Use sudden, loud, and unexpected sounds to startle the player. You can create tension by using eerie or unsettling background music and then suddenly playing a loud sound effect when the jumpscare occurs.
		//Visual cues: Use sudden changes in the game environment, such as flashing images or sudden appearances of a scary character or object.You can also use lighting effects and shadows to create an unsettling atmosphere.
		//Misdirection: Trick the player by leading them to expect a jumpscare in one area, only to surprise them with a jumpscare from another direction or at an unexpected time.
		//TODO: Add jumpscare ID to the event data
		// Vary the intensity: Not every jumpscare needs to be at the same intensity level. Vary the intensity of your jumpscares, using both subtle and intense scares to keep the player engaged and on edge.
		// Player-triggered jumpscares: Tie jumpscares to player actions, such as picking up an item, opening a door, or entering a specific area. This can help create a sense of agency and make the jumpscare feel more personal and impactful.

		//TODO: Peraphs this would be more suited
		/*
				const jumpscareID = eventData.jumpscareID as string;
		// Load the jump scare sound as a stinger
		this.musicManager.loadTrack(MusicState.JUMPSCARE, Game.JUMPSCARE);
		// Play the jump scare stinger
		this.musicManager.playStinger(MusicState.JUMPSCARE);
		*/
		const jumpscareID = eventData.jumpscareID as string;
		this.soundManager.LoadSound({ fileName: Game.JUMPSCARE, soundName: "JUMPSCARE", volume: 2 });
		this.soundManager.PlaySound("JUMPSCARE");
	}
}
