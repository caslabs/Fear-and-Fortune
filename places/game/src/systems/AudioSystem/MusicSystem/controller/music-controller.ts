import { Controller, OnInit, OnStart } from "@flamework/core";
import { MusicData, MusicKeys } from "../manager/MusicData";
import { Signals } from "shared/signals";

@Controller({})
export default class MusicSystemController implements OnStart, OnInit {
	private static musicInstances: Map<MusicKeys, Sound> = new Map();

	public onInit(): void {
		for (const [musicKey, musicId] of MusicData) {
			const sound = new Instance("Sound");
			sound.SoundId = "rbxassetid://" + musicId;
			sound.Parent = game.GetService("SoundService");
			sound.Volume = 1;
			MusicSystemController.musicInstances.set(musicKey, sound);
		}
		print("MusicSystemController initialized");
	}

	public onStart(): void {
		print("MusicSystemController started");
	}

	public static playMusic(id: MusicKeys) {
		print("[INFO] playSound", id);
		const sound = MusicSystemController.musicInstances.get(id);
		if (sound) {
			sound.Play();
			print("Playing Music");
		}
	}

	public static stopMusic(id: MusicKeys) {
		print("[INFO] playSound", id);
		const sound = MusicSystemController.musicInstances.get(id);
		if (sound) {
			sound.Stop();
		}
	}
}
