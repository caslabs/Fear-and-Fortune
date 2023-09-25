import { Controller, OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import { Players, ReplicatedStorage, TeleportService } from "@rbxts/services";
import { Workspace } from "@rbxts/services";
import Make from "@rbxts/make";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import { EventManager } from "shared/EventBus/EventManager";
import { GameEventType } from "shared/EventBus/eventTypes";

interface Attributes {}

@Controller({})
export class AIController extends BaseComponent<Attributes> implements OnStart {
	private eventManager: EventManager;

	constructor() {
		super();
		this.eventManager = EventManager.getInstance();
	}
	onStart() {
		const stopJumpScareZoomEvent = Remotes.Client.Get("StopJumpScareZoom");
		const playJumpScareZoomEvent = Remotes.Client.Get("PlayJumpScareZoom");

		playJumpScareZoomEvent.Connect(() => {
			this.eventManager.dispatchEvent(GameEventType.PostProcessing, {
				state: "zoom", // Use the new jumpscare
			});
		});

		stopJumpScareZoomEvent.Connect(() => {
			//TODO: Doesn't work
			this.eventManager.dispatchEvent(GameEventType.PostProcessing, {
				state: "default",
			});

			const player = Players.LocalPlayer;
			const camera = Workspace.CurrentCamera;
			if (player && camera) {
				// Zoom in slightly
				camera.FieldOfView = 70; // Adjust this value to control the zoom level
			}
		});
	}
}
