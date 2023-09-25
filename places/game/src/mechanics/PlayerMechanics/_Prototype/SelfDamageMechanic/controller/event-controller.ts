// client/controllers/EventController.ts
import { Controller, OnStart, OnInit } from "@flamework/core";
import { Players } from "@rbxts/services";
import { EventManager } from "shared/EventBus/EventManager";
import { GameEventType } from "shared/EventBus/eventTypes";
import { EventCutsceneManager } from "shared/EventBus/events/eventCutscene";
import { EventFx } from "shared/EventBus/events/eventFX";
import { EventJumpScareManager } from "shared/EventBus/events/eventJumpscare";
import { EventPostProcessing } from "shared/EventBus/events/eventPostProcessing";
import { RandomDialogueManager } from "shared/EventBus/events/eventDialogue";
import { FXManager } from "shared/FXManager";
import { EventNotification } from "shared/EventBus/events/eventNotification";

@Controller({})
export default class EventController implements OnStart, OnInit {
	private eventManager: EventManager;

	constructor() {
		this.eventManager = EventManager.getInstance();
		const randomDialogueManager = new RandomDialogueManager(this.eventManager);
		const eventJumpScareManager = new EventJumpScareManager(this.eventManager);
		const eventCutsceneManager = new EventCutsceneManager(this.eventManager);
		const fxManager = new EventFx(this.eventManager);
		const eventPostProcessing = new EventPostProcessing(this.eventManager);
		const eventNotification = new EventNotification(this.eventManager);
	}

	public onInit(): void {
		// Initialize any needed resources
	}

	public onStart(): void {
		//this.initializeInputListeners();
		print("EventController started");
	}

	private initializeInputListeners() {
		Players.LocalPlayer.GetMouse().KeyDown.Connect((key) => {
			if (key === "v" || key === "V") {
				// Example: Trigger a random dialogue event with a dialogueId
				this.eventManager.dispatchEvent(GameEventType.Notification, {
					title: "Example Title",
					description: "This is an example description.",
					image: "1543617734",
				});
			}
		});

		Players.LocalPlayer.GetMouse().KeyDown.Connect((key) => {
			if (key === "l" || key === "L") {
				// Example: Trigger a random dialogue event with a dialogueId
				this.eventManager.dispatchEvent(GameEventType.RandomDialogue, {
					dialogueId: "D1", // Replace this with the desired dialogue ID from your dialogue script
				});
			}
		});

		Players.LocalPlayer.GetMouse().KeyDown.Connect((key) => {
			if (key === "" || key === "") {
				// Example: Trigger a random dialogue event
				this.eventManager.dispatchEvent(GameEventType.JumpScare, {
					jumpscare: "", // Replace this with the desired jumpscare ID from your jumpscare script
				});
			}
		});

		Players.LocalPlayer.GetMouse().KeyDown.Connect((key) => {
			if (key === "f" || key === "F") {
				// Trigger a cutscene event with a cutsceneId
				print("Cutscene");
				this.eventManager.dispatchEvent(GameEventType.Cutscene, {
					cutsceneId: "A1Objective2", // Replace this with the desired cutscene ID from your cutscene script
				});
			}
		});

		Players.LocalPlayer.GetMouse().KeyDown.Connect((key) => {
			if (key === "j" || key === "J") {
				// Trigger a cutscene event with a cutsceneId
				this.eventManager.dispatchEvent(GameEventType.FX, {
					fxId: "glitch", // Replace this with the desired cutscene ID from your cutscene script
				});
			}
		});

		Players.LocalPlayer.GetMouse().KeyDown.Connect((key) => {
			if (key === "g" || key === "G") {
				// Trigger a post-processing event with the jumpscare state
				this.eventManager.dispatchEvent(GameEventType.PostProcessing, {
					state: "jumpscare", // Replace this with the desired post-processing state
				});
			}
		});

		// ... other input listeners for triggering events
	}

	// ... other client-specific methods and event listeners
}
