import { Controller, OnInit, OnStart } from "@flamework/core";
import { SoundData, SoundKeys } from "../manager/SoundData";
import Remotes from "shared/remotes";

//TODO: Based on Level Segment Biome
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

		const playLocalSoundEvent = Remotes.Client.Get("PlayLocalSound");
		const stopLocalSoundEvent = Remotes.Client.Get("StopLocalSound");

		playLocalSoundEvent.Connect((soundId, volume) => {
			SoundSystemController.playSoundVolume(soundId, volume);
		});

		stopLocalSoundEvent.Connect((soundId) => {
			SoundSystemController.stopSound(soundId);
		});
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

	static async WaitUntil(id: SoundKeys, volume: number): Promise<void> {
		print("[INFO] WaitUntil", id);
		const sound = SoundSystemController.soundInstances.get(id);
		if (sound) {
			sound.Volume = volume;
			sound.Play();
			await new Promise((resolve) => sound.Ended.Connect(resolve));
		}
	}
}
