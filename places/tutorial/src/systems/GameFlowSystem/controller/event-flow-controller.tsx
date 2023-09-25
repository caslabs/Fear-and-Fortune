import { Controller, OnStart } from "@flamework/core";
import CameraMechanic from "mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller";
import { HUDController } from "mechanics/PlayerMechanics/UIMechanic/controller/hud-controller";
import { RouterLobbyHUD } from "ui/routers/Router-LobbyHUD";
import Roact from "@rbxts/roact";
import { Players, StarterGui, UserInputService } from "@rbxts/services";
import { Signals } from "shared/signals";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import Notification from "mechanics/PlayerMechanics/UIMechanic/manager/notification";
import IntroScreen from "systems/NarrartiveSystem/CutsceneSystem/scenes/introduction-scene/screens/intro-screen";
import { landmarks } from "systems/NarrartiveSystem/WorldBuildingSystem/WorldData/landmarks";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import WakeUpScene from "mechanics/PlayerMechanics/UIMechanic/manager/WakeUpScene";
import DialogueBox from "systems/NarrartiveSystem/DialogueSystem/manager/dialogue-box";
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

type Task = (done: () => void) => void;
//TODO: Experimental Gas Mask Breahting
const gasMaskBreathing = new Instance("Sound");
gasMaskBreathing.SoundId = "rbxassetid://13868760171";
gasMaskBreathing.Volume = 0.5;
gasMaskBreathing.Looped = true;
gasMaskBreathing.Parent = game.GetService("SoundService");
/*
an event system or event bus
that enables communication and coordination
of higher-flow game logic
*/
@Controller({
	loadOrder: 99999, // Try to make this run last
})
export class EventFlowController implements OnStart {
	tasks: Task[];

	// Viva la asynchronous control flow or task-based programming!
	constructor(private readonly hudController: HUDController, private readonly cameraMechanic: CameraMechanic) {
		// Title -> Intro -> Play -> End
		this.tasks = [
			(done) => this.playIntroduction(done),
			(done) => this.startGame(done),
			// More tasks...
			// Cutscenes, Level Start, End Game, etc.
		];
	}

	onStart(): void {
		print("Event System Controller started");
		this.runNextTask();
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
		//Hide default UIs like PlayerList
		StarterGui.SetCoreGuiEnabled(Enum.CoreGuiType.All, false);

		Signals.switchToLobbyHUD.Fire();
		//Check
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
		SoundSystemController.stopSound(SoundKeys.SFX_SNOW_AMBIENCE);

		// Perform action after signal has been fired
		done();
	}

	private playIntroduction(done: () => void): void {
		//Check
		if (PlayerGui.WaitForChild("LOADING_SCREEN")) {
			print("Found Loading Screen");
			wait(1);
			PlayerGui.WaitForChild("LOADING_SCREEN").Destroy();
		} else {
			print("Deleted");
		}
		PlayerGui.WaitForChild("LOADING_SCREEN")!.Destroy();

		// Play the introduction cutscene
		// When the cutscene is over, call done()
		print("[EVENT] Playing Introduction");
		print("[EVENT] Awaiting for the player to finish introduction...");
		Signals.hideMouse.Fire();
		//Experimental

		//gasMaskBreathing.Play();

		//SoundSystemController.playSound(SoundKeys.SFX_GAS_MASK_BREATHING);
		print("Gas Mask Enabling ");
		//TODO: temp notification popup
		SoundSystemController.playSound(SoundKeys.DIALOGUE_1, 10);
		const handle: Roact.Tree = Roact.mount(
			<screengui Key={"IntroductionScene"} IgnoreGuiInset={true} ResetOnSpawn={false}>
				<IntroScreen description="Journal Entry - June 1st, 1912" />
			</screengui>,
			PlayerGui,
		);

		Signals.finishedIntroduction.Wait();
		Roact.unmount(handle);
		done();
	}

	private startGame(done: () => void): void {
		Signals.hideMouse.Fire();
		Signals.switchToPlayHUD.Fire();
		Signals.hideMouse.Fire();
		//Waking Up

		SoundSystemController.playAmbienceSound(SoundKeys.SFX_SNOW_AMBIENCE_MASK);
		const wakeUp: Roact.Tree = Roact.mount(
			<screengui Key={"WakingUpScene"} IgnoreGuiInset={true} ResetOnSpawn={false}>
				<WakeUpScene />
			</screengui>,
			PlayerGui,
		);

		//TODO: Signal!
		//SoundSystemController.playSound(SoundKeys.SFX_INTRO_WALKIETALKIE);
		Signals.finishedWakingUp.Wait();
		Roact.unmount(wakeUp);

		// Switch to the PlayHUD
		print("[EVENT] Playing Play Session");
		print("[EVENT] Starting Game");
		// When the game is ready, call done()
		gasMaskBreathing.Stop();
		//SoundSystemController.playSound(SoundKeys.SFX_AIR_GASP_LONG, 5);
		Signals.showMouse.Fire(); // Fire the signal to show the mouse

		//gasMaskBreathing.Volume = 0.2;
		//gasMaskBreathing.Play();

		SoundSystemController.playSound(SoundKeys.SFX_AIR_GASP, 10);
		wait(1);
		SoundSystemController.playSound(SoundKeys.DIALOGUE_2, 7);

		print("Signaling to landmark");
		//Landmark Notification
		const handle: Roact.Tree = Roact.mount(
			<screengui Key={"LandMarkNotification"} IgnoreGuiInset={true} ResetOnSpawn={false} DisplayOrder={-999}>
				<Notification title={landmarks.VILLAGE} />
			</screengui>,
			PlayerGui,
		);

		wait(5);
		Roact.unmount(handle);
		//SoundSystemController.stopSound(SoundKeys.SFX_INTRO_WALKIETALKIE);

		//TODO: Fade out only after the dialogue audio is finished
		const dialogue_2: Roact.Tree = Roact.mount(
			<screengui Key={"DialogueBoxScreen"} IgnoreGuiInset={true} ResetOnSpawn={false}>
				<DialogueBox
					title={""}
					description={
						"You: The labyrinth of this cursed mountains and eerie caves loomed before us, stench in blood and accursed things. I once thought such visions to be mere phantoms… of fevered dreams."
					}
					image={""}
				/>
			</screengui>,
			PlayerGui,
		);
		done();
	}
}
