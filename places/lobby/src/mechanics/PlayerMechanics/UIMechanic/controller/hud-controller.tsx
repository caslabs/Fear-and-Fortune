import Roact from "@rbxts/roact";
import { Players, StarterGui, Workspace } from "@rbxts/services";
import { Controller, OnStart } from "@flamework/core";
import CameraMechanic from "mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller";
import { Signals } from "shared/signals";
import CharacterMechanic from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import { MouseController } from "./mouse-controller";
import { RouterLobbyHUD } from "ui/routers/Lobby/Router-LobbyHUD";
import { RouterTitleHUD } from "ui/routers/Title/Router-TitleHUD";
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

@Controller({
	loadOrder: 0,
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

		Signals.switchToLobbyHUD.Connect(() => {
			this.cameraMechanic.enableLobbyCamera();
			this.switchToLobbyHUD();
		});

		Signals.switchToTitleHUD.Connect(() => {
			this.cameraMechanic.enableTitleCamera();
			this.switchToTitleHUD();
			print("Signaled...");
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
		this.handle = this.mountComponent(<RouterTitleHUD />);
		print("switching to Title HUD under HUDController");
	}

	public switchToLobbyHUD(): void {
		if (!this.isMountedDynamicMosue) {
			this.mouseController.initiateDynamicCustomCursor();
			this.isMountedDynamicMosue = true;
		}

		this.handle = this.mountComponent(<RouterLobbyHUD />);
		/*
		if (this.handle) {
			Roact.unmount(this.handle);
			this.handle = this.mountComponent(<RouterLobbyHUD />);
		}
		*/
	}
}
