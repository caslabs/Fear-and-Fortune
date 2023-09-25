interface SoundCue {
	name: string;
	falloff: number;
	priority: number;
	switch_name: string;
	sources: {
		switch: string;
		sources: string[];
	}[];
}

export const UI = {
	buttonClick: "songID",
	notification: "294316715",
	close: "6895079853",
};
export const Lobby = {
	ambienbce: "songID",
};
export const Game: { [key: string]: string } = {
	tuturoo: "2806491346", // steins;gate reference lol
	background_music1: "9048378383",
	open_chest: "6176999962",
	item_pickup: "6176999962", //TODO: Change this to a different sound
	blood_shrine: "221057812",
	chance_shrine: "6883650972",
	sus_shrine: "7361207035",
	A1Objective2: "13368966497",
	QUEST_COMPLETE: "5621616510",
	JUMPSCARE: "7076365030",
	intro: "13615772080",
	gate_open: "7509847163",
};

export const Dialogue: { [key: string]: string } = {
	D2: "13659163893", // I Got the Gate Working!
	S1: "13660016606", // ...Heeds my words, adventurer. Now cometh the time of reckoning of the gods.
};

export const SoundQueus = {
	name: "footstep",
	falloff: 25,
	priority: "low",
	switch_name: "foot_surface",
	sources: [
		{
			switch: "sand",
			sources: ["fs_sand1.wav", "fs_sand2.wav", "fs_sand3.wav"],
		},
		{
			switch: "grass",
			sources: [],
		},
	],
};

/*

SoundManager can be used to handle immediate and specific sound effects, such as UI sounds or character interactions.
*/
export class SoundManager {
	private static instance: SoundManager;
	private sounds: Map<string, Sound> = new Map();
	private soundQueue: Sound[] = [];

	private constructor() {}

	public static getInstance(): SoundManager {
		if (!SoundManager.instance) {
			SoundManager.instance = new SoundManager();
		}
		return SoundManager.instance;
	}

	public async LoadSound({
		fileName,
		soundName,
		volume,
		looped,
	}: {
		fileName: string;
		soundName: string;
		volume?: number;
		looped?: boolean;
	}): Promise<void> {
		// Load the sound effect
		const sound = new Instance("Sound");
		sound.SoundId = "rbxassetid://" + fileName;
		sound.Parent = game.GetService("SoundService");
		sound.Volume = 1;
		if (!sound) {
			warn("Failed to load sound effect: " + fileName);
			//throw new Error(`Failed to load sound effect: ${fileName}`);
		}

		//TODO: Does this work?
		// Set the sound effect properties
		if (volume !== undefined || typeIs(volume, "number")) {
			sound.Volume = volume;
		}
		if (looped !== undefined || typeIs(looped, "boolean")) {
			sound.Looped = looped;
		}

		// Add the sound effect to the map
		this.sounds.set(soundName, sound);
	}

	public async PlaySound(soundName: string): Promise<void> {
		// Check if the sound exists
		if (!this.sounds.has(soundName)) {
			warn("Sound effect not found: " + soundName);
			//throw new Error(`Sound effect not found: ${soundName}`);
		}

		// Play the sound effect
		const sound = this.sounds.get(soundName);
		if (sound) {
			print("Playing sound effect: " + soundName);
			sound.Play();
		}
	}

	public getSound(soundName: string): Sound | undefined {
		return this.sounds.get(soundName);
	}

	public async playSpatialSound(soundName: string, parent: Instance): Promise<void> {
		// Check if the sound exists
		const sound = this.sounds.get(soundName);
		if (sound) {
			print("Playing spatial sound effect: " + soundName);

			// Clone sound for playing, to prevent interrupting a sound already playing
			const soundToPlay = sound.Clone();
			soundToPlay.Parent = parent;
			soundToPlay.RollOffMode = Enum.RollOffMode.InverseTapered;
			soundToPlay.MaxDistance = 50; // Change this to suit your needs
			soundToPlay.Play();
		} else {
			warn("Sound effect not found: " + soundName);
		}
	}

	public async PlayNextSoundInQueue(): Promise<void> {
		// Check if there are any sounds in the queue
		if (this.soundQueue.size() === 0) {
			return;
		}

		// Play the next sound in the queue
		const nextSound = this.soundQueue.shift()!;
		if (nextSound) {
			nextSound.Volume = 1;
			await nextSound.Play();
		}

		// If there are more sounds in the queue, play the next one after a delay
		if (this.soundQueue.size() > 0) {
			wait(nextSound.TimeLength + 1);
			this.PlayNextSoundInQueue();
		}
	}

	public EnqueueSound(soundName: string): void {
		// Check if the sound exists
		if (!this.sounds.has(soundName)) {
			print("Sound effect not found: " + soundName);
			//throw new Error(`Sound effect not found: ${soundName}`);
		}

		// Add the sound to the queue
		this.soundQueue.push(this.sounds.get(soundName)!);
	}
}
