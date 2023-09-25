import { Controller, OnStart } from "@flamework/core";
import CameraMechanic from "mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller";
import { HUDController } from "mechanics/PlayerMechanics/UIMechanic/controller/hud-controller";
import { Players, StarterGui, UserInputService, HttpService, ContentProvider } from "@rbxts/services";
import { Signals } from "shared/signals";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import Remotes from "shared/remotes";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";
import { MusicData, MusicKeys } from "systems/AudioSystem/MusicSystem/manager/MusicData";
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");
import { Workspace, Lighting, ReplicatedStorage, StarterPack } from "@rbxts/services";

type Task = (done: () => void) => void;

declare class PlayerModule {
	GetControls(): Controls;
}

declare class Controls {
	Disable(): void;
}

export enum QueueState {
	Idle,
	Searching,
	ServerFound,
	EmbarkFailed,
}

@Controller({
	loadOrder: 99999, // Try to make this run last
})
export class EventFlowController implements OnStart {
	tasks: Task[];
	private queueState: QueueState;

	// Viva la asynchronous control flow or task-based programming!
	constructor(private readonly hudController: HUDController, private readonly cameraMechanic: CameraMechanic) {
		this.tasks = [
			(done) => this.showLobbyScreen(done),
			(done) => this.transitionToGame(done),
			(done) => this.teleportToGame(done),
			// Cutscenes, Level Start, End Game, etc.
		];
		this.queueState = QueueState.Idle;
	}

	onStart(): void {
		print("Event System Controller started");
		this.runNextTask();

		const ExecuteMatchEvent = Remotes.Client.Get("ExecuteMatch");
		ExecuteMatchEvent.Connect(() => {
			Signals.startGameSignal.Fire();
		});
	}

	private runNextTask(): void {
		if (this.tasks.size() > 0) {
			const nextTask = this.tasks.shift();
			if (nextTask) {
				nextTask(() => this.runNextTask());
			}
		} else {
			print("All tasks completed");
		}
	}

	private showTitleScreen(done: () => void): void {
		const disablePlayerControls = Remotes.Client.Get("disablePlayerControls");
		disablePlayerControls.SendToServer(Players.LocalPlayer);

		Signals.switchToTitleHUD.Fire();
		print("Fired switchToTitleHUD Signal");

		//Delete the pre loading screen
		if (PlayerGui.WaitForChild("LOADING_SCREEN")) {
			print("Found Loading Screen");
			wait(1);
			PlayerGui.WaitForChild("LOADING_SCREEN").Destroy();
		} else {
			print("Deleted");
		}
		PlayerGui.WaitForChild("LOADING_SCREEN")!.Destroy();
		print("[EVENT] Awaiting for the player to singal title...");

		// Wait for the signal to be fired
		Signals.finishedTitleScreen.Wait();
		SoundSystemController.playSound(SoundKeys.SFX_THUNDER);
		SoundSystemController.stopSound(SoundKeys.SFX_SNOW_AMBIENCE);

		// Perform action after signal has been fired
		done();
	}

	/*
	Depending on the scale of the game, having a loading screen is bad UX design.
	Unless its part of the "vision" of the game, i would skip this flow and let the player
	instantly join the game whilst Roblox does real-time loading
	*/
	private async showAssetLoadScreen(done: () => void): Promise<void> {
		print("[EVENT] Beginning asset loading...");

		try {
			// Load assets
			await this.loadAssets();

			print("[EVENT] Asset loading completed.");
			done(); // Signal completion of this task
		} catch (error) {
			print(`[ERROR] Asset loading failed: ${error}`);
			// You might want to handle this error more gracefully. Perhaps retry, or inform the player.
		}
	}

	private async showLobbyScreen(done: () => void): Promise<void> {
		//DEV: Begin the await this.loadAssets();
		//await this.loadAssets();
		StarterGui.SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);

		//Delete the pre loading screen
		if (PlayerGui.WaitForChild("LOADING_SCREEN")) {
			print("Found Loading Screen");
			wait(1);
		} else {
			print("Deleted");
		}
		//PlayerGui.WaitForChild("LOADING_SCREEN")!.Destroy();
		print("[EVENT] Awaiting for the player to singal title...");

		// Show the Lobby Screen
		Signals.switchToLobbyHUD.Fire();
		MusicSystemController.playMusic(MusicKeys.LOBBY_MUSIC, true);
		const loadProfileEvent = Remotes.Client.Get("LoadProfile");
		loadProfileEvent.SendToServer();
		done();
	}

	private async transitionToGame(done: () => void): Promise<void> {
		print("Awaiting queueStateChangedSignal...");

		// Here we use Connect to attach an event listener
		const connection = Signals.queueStateChangedSignal.Connect((newQueueState: QueueState) => {
			this.queueState = newQueueState;
		});

		// Wait for the startGameSignal to be fired
		//TODO: This is the flow that starts the game
		Signals.startGameSignal.Wait();
		print("Start game signal received");

		// Set the queueState to ServerFound and disconnect the signal
		this.setQueueState(QueueState.ServerFound);

		// Initialize countdownTime to 5
		let countdownTime = 5;

		// Emit startCountdownSignal with countdownTime
		Signals.startCountdownSignal.Fire(countdownTime);

		// Decrement countdownTime every second
		while (countdownTime > 0) {
			wait(1);
			countdownTime -= 1;

			if (countdownTime > 0) {
				// If there's still time left, emit the signal with the updated countdownTime
				Signals.startCountdownSignal.Fire(countdownTime);
				SoundSystemController.playSound(SoundKeys.UI_COUNTDOWN, 2);
			} else {
				// If countdownTime reaches 0, emit endCountdownSignal
				Signals.endCountdownSignal.Fire();
				SoundSystemController.playSound(SoundKeys.UI_BACKPACK, 2);
			}
		}

		connection.Disconnect();
		print("Transitioning to game");
		done();
	}

	private async teleportToGame(done: () => void): Promise<void> {
		const TeleportMatchEvent = Remotes.Client.Get("TeleportMatch");
		TeleportMatchEvent.SendToServer();
		print("Teleporting to game");
		done();
	}

	setQueueState(newQueueState: QueueState) {
		this.queueState = newQueueState;
		Signals.queueStateChangedSignal.Fire(newQueueState);
	}

	private async loadAssets(): Promise<void> {
		const allObjects: Instance[][] = [
			Workspace.GetDescendants(),
			Lighting.GetDescendants(),
			ReplicatedStorage.GetDescendants(),
			StarterGui.GetDescendants(),
			Players.GetDescendants(),
			StarterPack.GetDescendants(),
		];

		// Check if the character exists before fetching its descendants
		const localPlayerCharacter = Players.LocalPlayer.Character;
		if (localPlayerCharacter) {
			allObjects.push(localPlayerCharacter.GetDescendants());
		}

		const allLoadables: Instance[] = [];
		for (const objects of allObjects) {
			for (const loadable of this.filterLoadables(objects)) {
				allLoadables.push(loadable);
			}
		}
		let loadedCount = 0;
		const totalAssets = allLoadables.size();

		const promises: Promise<void>[] = [];
		for (const loadable of allLoadables) {
			const promise = new Promise<void>((resolve, reject) => {
				try {
					ContentProvider.PreloadAsync([loadable]);
					loadedCount++;
					//print(`[LOADING] Loading asset: ${loadable.Name}`);
					print(`[LOADING] loading progress: ${loadedCount} / ${totalAssets}`);
					resolve();
				} catch (error) {
					reject(`Failed to load asset: ${loadable}. Error: ${error}`);
				}
			});
			promises.push(promise);
		}

		await Promise.all(promises);
	}

	private filterLoadables(objects: Instance[]): Instance[] {
		const loadables: Instance[] = [];
		for (const obj of objects) {
			if (obj.IsA("Model") || obj.IsA("Texture") || obj.IsA("Sound") /* ... other relevant classes ... */) {
				loadables.push(obj);
			}
		}
		return loadables;
	}
}
