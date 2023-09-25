import { Controller, OnInit, OnStart } from "@flamework/core";
import Roact from "@rbxts/roact";
import { UserInputService, ReplicatedStorage, StarterGui } from "@rbxts/services";
import LifeMechanic from "mechanics/PlayerMechanics/LifeMechanic/controller/life-controller";
import { HUDController } from "mechanics/PlayerMechanics/UIMechanic/controller/hud-controller";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";
import { Players } from "@rbxts/services";
import PostEventScreen from "ui/screens/post-event-screen";
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

const UpdateExpeditionCountEvent = Remotes.Client.Get("UpdateExpeditionCount");
@Controller()
export default class GameFlowSystemController implements OnInit, OnStart {
	constructor(
		private readonly lifeMechanic: LifeMechanic,
		private readonly hudController: HUDController,
		private readonly musicSystem: MusicSystemController,
	) {} // Inject LifeMechanic

	onInit(): void {}

	onStart(): void {
		StarterGui.SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false);
		StarterGui.SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
		StarterGui.SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
		StarterGui.SetCore("ResetButtonCallback", false);
		// Connect to the livesChanged signal
		this.lifeMechanic.livesChanged.Connect((lives) => {
			if (lives <= 0) {
				//TODO: Death Mechanic interferes with the Life Mechanic?
				//this.transitionToSpectating();
			}
		});

		Signals.PlayerDied.Connect(() => {
			this.transitionToSpectating();

			//TODO: temporarily hack to show lobby if choose to stay
			const lobbyButton: Roact.Tree = Roact.mount(
				<screengui Key={"LobbyScreen"} IgnoreGuiInset={true} ResetOnSpawn={false}>
					<textbutton
						Key={"LobbyButton"}
						Text={"Return To Lobby"}
						LayoutOrder={2}
						FontSize={Enum.FontSize.Size8}
						Size={UDim2.fromScale(0.15, 0.15)}
						AnchorPoint={new Vector2(0.5, 0)}
						Position={new UDim2(0.5, 0, -0.001, 10)}
						BorderSizePixel={0}
						BackgroundColor3={Color3.fromRGB(0, 0, 0)}
						ZIndex={5}
						BackgroundTransparency={0.5}
						TextColor3={Color3.fromRGB(255, 255, 255)}
						Event={{
							MouseButton1Click: () => {
								const ExtractToLobbyEvent = Remotes.Client.Get("ExtractToLobby");
								ExtractToLobbyEvent.SendToServer(Player);
								print("Extracting to lobby button triggered...");
							},
						}}
					></textbutton>
				</screengui>,
				PlayerGui,
			);
		});

		// If Exit Portal is touched, transition to spectating
		Signals.ExitPortalTouched.Connect(() => {
			this.transitionToSpectating();
			//TODO: Show different Exit screen based on the amount of players
			// If there is only one player, show the "No one's here" Screen
			// If there is more than one player, show the "Spectate option" Screen
			//TODO: Quick hack, make dedicated Context System for Spectating HUD
			const handle: Roact.Tree = Roact.mount(
				<screengui Key={"ExitScreen"} IgnoreGuiInset={true} ResetOnSpawn={false}>
					<PostEventScreen />
				</screengui>,
				PlayerGui,
			);
			Signals.OnExitScreenClosed.Wait();
			//TODO: Tell Server to increment successful_expedition

			Roact.unmount(handle);

			//TODO: temporarily hack to show lobby if choose to stay
			const lobbyButton: Roact.Tree = Roact.mount(
				<screengui Key={"LobbyScreen"} IgnoreGuiInset={true} ResetOnSpawn={false}>
					<textbutton
						Key={"LobbyButton"}
						Text={"Return To Lobby"}
						LayoutOrder={2}
						FontSize={Enum.FontSize.Size8}
						Size={UDim2.fromScale(0.15, 0.15)}
						AnchorPoint={new Vector2(0.5, 0)}
						Position={new UDim2(0.5, 0, -0.001, 10)}
						BorderSizePixel={0}
						BackgroundColor3={Color3.fromRGB(0, 0, 0)}
						ZIndex={5}
						BackgroundTransparency={0.5}
						TextColor3={Color3.fromRGB(255, 255, 255)}
						Event={{
							MouseButton1Click: () => {
								const ExtractToLobbyEvent = Remotes.Client.Get("ExtractToLobby");
								ExtractToLobbyEvent.SendToServer(Player);
								print("Extracting to lobby button triggered...");
							},
						}}
					></textbutton>
				</screengui>,
				PlayerGui,
			);
		});

		print("GameFlowSystem Controller started");
	}

	private transitionToSpectating() {
		print("Transitioning to spectating...");

		// Spectating Experience
		this.hudController.switchToSpectateHUD();
	}

	private transitionToPlaying() {
		print("Transitioning to playing...");
		//TODO: Somehow the player has more lives...
		// Enable Respawn
		// Transition to PlayHUD()
	}
}
