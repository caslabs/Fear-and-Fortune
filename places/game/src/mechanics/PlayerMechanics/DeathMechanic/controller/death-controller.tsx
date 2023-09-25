import { Controller, OnInit, OnStart } from "@flamework/core";
import { Players } from "@rbxts/services";
import Roact from "@rbxts/roact";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";
import { MusicKeys } from "systems/AudioSystem/MusicSystem/manager/MusicData";
import DeathScreen from "systems/NarrartiveSystem/CutsceneSystem/scenes/introduction-scene/screens/death-screen";
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

const PlayerDeathEvent = Remotes.Client.Get("PlayerDeathEvent");
@Controller()
export default class DeathMechanic implements OnStart, OnInit {
	constructor(public readonly musicController: MusicSystemController) {}

	onInit(): void {}

	private deathScreenShown = false;
	private handle: Roact.Tree | undefined;

	onStart(): void {
		print("DeathMechanic Controller started");

		PlayerDeathEvent.Connect((player, message, hint) => {
			print("PlayerDeathEvent", player, message, hint);

			if (!this.deathScreenShown) {
				this.showDeathScreen(message, hint);
			}
		});
	}

	showDeathScreen(message: string, hint: string): void {
		wait(2);
		Signals.hideMouse.Fire();

		MusicSystemController.playMusic(MusicKeys.DEATH_MUSIC);

		//Show only once
		if (!this.deathScreenShown) {
			this.handle = Roact.mount(
				<screengui Key={"DeathNotification"} IgnoreGuiInset={true} ResetOnSpawn={false}>
					<DeathScreen description={message} hint={hint} />
				</screengui>,
				PlayerGui,
			);

			this.deathScreenShown = true;
		}

		wait(7);

		if (this.handle) {
			Roact.unmount(this.handle);
			this.handle = undefined;
		}

		Signals.PlayerDied.Fire();
		Signals.showMouse.Fire();

		this.deathScreenShown = false;
	}
}
