import { PostProcessingManager } from "shared/PostProcessingManager";
import { EventManager } from "../EventManager";
import { GameEventType } from "../eventTypes";
import {
	BlackoutState,
	DefaultState,
	JumpscareState,
	JumpscareZoomState,
	ZoomState,
} from "shared/PostProcessingManager/postProcessingStates";

interface EventPostProcessingData {
	state: string;
}

export class EventPostProcessing {
	private postProcessingManager: PostProcessingManager;

	constructor(eventManager: EventManager) {
		this.postProcessingManager = PostProcessingManager.getInstance();

		// Create the post-processing templates
		this.postProcessingManager.createTemplate("blackout", new BlackoutState(), new Map([["Brightness", 0]]));
		this.postProcessingManager.createTemplate("jumpscare", new JumpscareState(), new Map([["Brightness", 1]]));
		this.postProcessingManager.createTemplate("default", new DefaultState(), new Map([]));
		this.postProcessingManager.createTemplate("jumpscarezoom", new JumpscareZoomState(), new Map([]));
		this.postProcessingManager.createTemplate("zoom", new ZoomState(), new Map([]));

		eventManager.registerListener(GameEventType.PostProcessing, (eventData: EventPostProcessingData) =>
			this.handlePostProcessingEvent(eventData),
		);
	}

	private handlePostProcessingEvent(eventData: EventPostProcessingData) {
		const state = eventData.state as string;
		// Update the post-processing state using the PostProcessingManager
		this.postProcessingManager.updateState(state, "smooth"); // Use "instant" for instant transition or "smooth" for smooth transition
	}
}
