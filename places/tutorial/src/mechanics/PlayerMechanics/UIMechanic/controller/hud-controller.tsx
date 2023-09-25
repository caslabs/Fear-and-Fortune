import Roact from "@rbxts/roact";
import { Players, StarterGui, Workspace } from "@rbxts/services";
import { Controller, OnStart } from "@flamework/core";
import { RouterPlayHUD } from "ui/routers/Router-PlayHUD";
import { RouterSpectateHUD } from "ui/routers/Router-SpectateHUD";
import { RouterCutsceneHUD } from "ui/routers/Router-CutsceneHUD";
import CameraMechanic from "mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller";
import { RouterLobbyHUD } from "ui/routers/Router-LobbyHUD";
import { Signals } from "shared/signals";
import CharacterMechanic from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import Notification from "../manager/notification";
import { MouseController } from "./mouse-controller";
import { RouterMerchantHUD } from "ui/routers/Router-MerchantHUD";
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

@Controller({
	loadOrder: 2, // Try to make this run last
})
export class HUDController implements OnStart {
	private handle: Roact.Tree | undefined;
	private isMountedDynamicMosue: boolean;

	constructor(
		private readonly cameraMechanic: CameraMechanic,
		private readonly characterController: CharacterMechanic,
		private readonly mouseController: MouseController,
	) {
		this.isMountedDynamicMosue = false;
	}

	onStart(): void {
		print("HUDController started");

		Signals.switchToPlayHUD.Connect(() => {
			print("switching to Play HUD under HUDController");
			this.switchToPlayHUD();
		});

		Signals.switchToCutsceneHUD.Connect(() => {
			print("switching to Cutscene HUD under HUDController");
			this.switchToCutsceneHUD();
		});

		Signals.switchToLobbyHUD.Connect(() => {
			this.cameraMechanic.enableTitleCamera();
			this.handle = this.mountComponent(<RouterLobbyHUD />);
		});

		Signals.switchToShopHUD.Connect(() => {
			this.cameraMechanic.enableShopCamera();
			this.switchToMerchantHUD();
		});
	}

	public mountComponent(component: Roact.Element): Roact.Tree {
		return Roact.mount(
			<screengui Key={"HUD"} IgnoreGuiInset={true} ResetOnSpawn={false}>
				{component}
			</screengui>,
			PlayerGui,
		);
	}

	public switchToTitleHUD(): void {
		this.handle = this.mountComponent(<RouterLobbyHUD />);
	}

	public switchToPlayHUD(): void {
		if (!this.isMountedDynamicMosue) {
			this.mouseController.initiateDynamicCustomCursor();
			this.isMountedDynamicMosue = true;
		}

		// Initalize it for the first time
		this.cameraMechanic.enableFirstPerson();
		this.cameraMechanic.enableHeadBobbing();

		// Then initalize for every character death - this is due
		// to the behavior of our initating playHUD.
		this.characterController.onCharacterAdded.Connect(() => {
			this.cameraMechanic.enableFirstPerson();
			this.cameraMechanic.enableHeadBobbing();
			print("Initialize camera effect upon death");
		});

		/*

		since, this is the first, we don't need to check if theres any handles
		if (this.handle) {
			Roact.unmount(this.handle);
			this.handle = this.mountComponent(<RouterPlayHUD profession="Medic" />);
		}
		*/
		this.handle = this.mountComponent(<RouterPlayHUD profession="Medic" />);

		print("Switched to Play HUD Enabled");
	}

	public switchToSpectateHUD(): void {
		this.cameraMechanic.enableSpectateCamera();
		print("switching to Spectate HUD");
		if (this.handle) {
			Roact.unmount(this.handle);
			this.handle = this.mountComponent(<RouterSpectateHUD />);
		}
	}

	public switchToCutsceneHUD(): void {
		print("switching to Cutscene HUD");
		if (this.handle) {
			Roact.unmount(this.handle);
			this.handle = this.mountComponent(<RouterCutsceneHUD />);
		}
	}

	public switchToMerchantHUD(): void {
		print("switching to Merchant HUD");
		if (this.handle) {
			Roact.unmount(this.handle);
			this.handle = this.mountComponent(<RouterMerchantHUD />);
		}
	}
}
