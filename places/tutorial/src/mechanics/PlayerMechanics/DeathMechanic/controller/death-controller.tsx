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

	onStart(): void {
		print("DeathMechanic Controller started");

		PlayerDeathEvent.Connect((player, message, hint) => {
			// player.name
			print("PlayerDeathEvent", player, message, hint);
			this.showDeathScreen(message, hint);
		});
	}

	showDeathScreen(message: string, hint: string): void {
		//TODO: Death Notification
		wait(2);
		Signals.hideMouse.Fire();

		//TODO: go over static and public methods
		MusicSystemController.playMusic(MusicKeys.DEATH_MUSIC);
		const handle: Roact.Tree = Roact.mount(
			<screengui Key={"DeathNotification"} IgnoreGuiInset={true} ResetOnSpawn={false}>
				<DeathScreen description={message} />
			</screengui>,
			PlayerGui,
		);

		wait(35);

		const player = Players.LocalPlayer;
		player.Kick("join again to retry");
	}
}
