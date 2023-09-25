import { OnStart, Service } from "@flamework/core";
import { Players, StarterPlayer, UserInputService, StarterGui } from "@rbxts/services";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";

@Service({
	loadOrder: 0,
})
export default class GameFlowController implements OnStart {
	public onStart() {
		const player = Players.LocalPlayer;
		const PlayerGui = player.WaitForChild("PlayerGui") as PlayerGui;

		PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeLeft;
		StarterGui.SetCore("ResetButtonCallback", false);
		StarterPlayer.EnableMouseLockOption = false;

		//TODO: Disable Reset Button
		//StarterGui.SetCore(Enum.CoreGuiType., false);

		//Badge: Joining for the first time
		Signals.playerFirstJoinSignal.Fire(player);
		print("GameFlowSystem Controller Started");
	}
}
