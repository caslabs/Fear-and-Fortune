import { EventManager } from "shared/EventBus/EventManager";
import { GameEventType } from "shared/EventBus/eventTypes";
import { Workspace, TweenService } from "@rbxts/services";
import { Game, SoundManager } from "../sound-manager";
import cutsceneHud from "ui/huds/cutscene-hud";
import { HUDController } from "mechanics/PlayerMechanics/UIMechanic/controller/hud-controller";
import { Signals } from "shared/signals";
interface CutsceneEventData {
	cutsceneId: string;
}
//TODO: pre-render cutscene events
// In a story-driven game, this
//flow might also include variousin - game movies that serve to advance the player’s understanding of the storyas it unfolds.

interface CutsceneData {
	positions: Array<CFrame>;
	duration: number;
}

const startRotation = new CFrame(new Vector3(0, 0, 0), new Vector3(-1, 0, 0)).mul(
	CFrame.Angles(math.rad(-58.472), math.rad(1.853), math.rad(-32.761)),
);

const endRotation = new CFrame(new Vector3(0, 0, 0), new Vector3(0, 1, 0)).mul(
	CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)),
);

const startPosition = new CFrame(new Vector3(0, 0, 0)).mul(CFrame.Angles(0, 0, 0));

const endPosition = new CFrame(new Vector3(0, 3, 0)).mul(CFrame.Angles(0, 0, 0));

// Define your cutscenes
const cutscenes: Map<string, CutsceneData> = new Map([
	[
		"A1Objective2",
		{
			positions: [
				//This will move the camera to the following positions over the course of 3 seconds
				new CFrame(new Vector3(0, 5, -10)),
				new CFrame(new Vector3(10, 5, 0)),
				new CFrame(new Vector3(0, 5, 10)),
			],
			duration: 3,
		},
	],
]);

export class CutsceneManager {
	private static instance: CutsceneManager;
	private eventManager: EventManager;
	private currentCutscene?: CutsceneData;
	private cutsceneTween?: Tween;
	private soundManager: SoundManager;

	private constructor() {
		// Initialize any necessary resources
		this.eventManager = EventManager.getInstance();
		this.subscribe(this.eventManager);
		this.soundManager = SoundManager.getInstance();
	}

	public static getInstance(): CutsceneManager {
		if (!CutsceneManager.instance) {
			CutsceneManager.instance = new CutsceneManager();
		}
		return CutsceneManager.instance;
	}

	private subscribe(eventManager: EventManager): void {
		eventManager.registerListener(GameEventType.Cutscene, (eventData: CutsceneEventData) =>
			this.handleCutsceneEvent(eventData),
		);
	}

	private handleCutsceneEvent(eventData: CutsceneEventData): void {
		// Handle the cutscene event data
		const cutsceneId = eventData.cutsceneId;
		if (this.loadCutscene(cutsceneId)) {
			this.playCutscene();
		}
	}

	//TODO: ask chatgpt abouut this
	// Also, if each object should ping it everytime to check or nah?
	public loadCutscene(cutsceneId: string): boolean {
		const cutscene = cutscenes.get(cutsceneId);
		if (!cutscene) {
			warn(`Cutscene with ID "${cutsceneId}" not found.`);
			this.currentCutscene = undefined;
			return false;
		}
		this.currentCutscene = cutscene;
		//TODO: Make ID dynamic
		//this.soundManager.LoadSound({ fileName: Game[cutsceneId], soundName: "DIALOGUE", volume: 2 });
		//this.soundManager.PlaySound("DIALOGUE");
		return true;
	}

	public playCutscene(): void {
		//Signals.switchToCutsceneHUD.Fire();
		print("Played cutscene");
		if (!this.currentCutscene) {
			warn("No cutscene has been loaded.");
			return;
		}

		const camera = Workspace.CurrentCamera;
		if (!camera) {
			warn("No camera found in the workspace.");
			return;
		}

		let index = 0;
		const playNextPosition = () => {
			if (index >= this.currentCutscene!.positions.size()) {
				this.stopCutscene();
				return;
			}

			const newPosition = this.currentCutscene!.positions[index];
			this.cutsceneTween = TweenService.Create(camera, new TweenInfo(this.currentCutscene!.duration), {
				CFrame: newPosition,
			});
			this.cutsceneTween.Completed.Connect(playNextPosition);
			this.cutsceneTween.Play();
			index++;
		};

		playNextPosition();

		//this.stopCutscene();
	}

	public playStrongCutscene(): void {
		print("Played cutscene");
		if (!this.currentCutscene) {
			warn("No cutscene has been loaded.");
			return;
		}

		const camera = Workspace.CurrentCamera;
		if (!camera) {
			warn("No camera found in the workspace.");
			return;
		}

		const startPosition = this.currentCutscene.positions[0];
		const endPosition = this.currentCutscene.positions[this.currentCutscene.positions.size() - 1];

		camera.CFrame = startPosition;

		for (let i = 1; i < this.currentCutscene.positions.size() - 1; i++) {
			camera.CFrame = this.currentCutscene.positions[i];
		}

		this.cutsceneTween = TweenService.Create(camera, new TweenInfo(this.currentCutscene.duration), {
			CFrame: endPosition,
		});

		this.cutsceneTween.Play();
		this.cutsceneTween.Completed.Wait();
	}

	public stopCutscene(): void {
		//Signals.switchToPlayHUD.Fire();
		// Stop the cutscene
	}
}
