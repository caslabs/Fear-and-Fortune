import { Controller, OnInit, OnStart } from "@flamework/core";
import { SoundData, SoundKeys } from "../manager/SoundData";

@Controller({})
export default class SoundSystemController implements OnStart, OnInit {
	private static soundInstances: Map<SoundKeys, Sound> = new Map();

	public onInit(): void {
		for (const [soundKey, soundId] of SoundData) {
			const sound = new Instance("Sound");
			sound.SoundId = "rbxassetid://" + soundId;
			sound.Parent = game.GetService("SoundService");
			sound.Volume = 1;
			SoundSystemController.soundInstances.set(soundKey, sound);
		}
		print("SoundSystemController initialized");
	}

	public onStart(): void {
		print("SoundSystemController started");
	}

	static playSound(id: SoundKeys, volume?: number): void {
		print("[INFO] playSound", id);
		const sound = SoundSystemController.soundInstances.get(id);
		if (sound) {
			sound.Play();
			if (volume !== undefined) {
				sound.Volume = volume;
			}
		}
	}

	static playAmbienceSound(id: SoundKeys, volume?: number): void {
		print("[INFO] playAmbienceSound", id);
		const sound = SoundSystemController.soundInstances.get(id);
		if (sound) {
			sound.Looped = true;
			sound.Play();
		}
	}

	static stopSound(id: SoundKeys): void {
		print("[INFO] stopSound", id);
		const sound = SoundSystemController.soundInstances.get(id);
		if (sound) {
			sound.Stop();
		}
	}

	static playSoundVolume(id: SoundKeys, volume: number) {
		print("[INFO] playSound", id);
		const sound = SoundSystemController.soundInstances.get(id);
		if (sound) {
			sound.Volume = volume;
			sound.Play();
		}
	}
}
