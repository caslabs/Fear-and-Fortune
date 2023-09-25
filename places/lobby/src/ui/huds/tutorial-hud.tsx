import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Close from "ui/Pages/Panels/PanelLobby/Close";
import { Players, TeleportService } from "@rbxts/services";
import { Panel } from "ui/Pages/Panels/PanelLobby/Panel";
import { Pages } from "ui/routers/Lobby/Context-LobbyHUD";

interface TutorialHUDProps {
	visible?: boolean;
}

const TutorialHUD: Hooks.FC<TutorialHUDProps> = (props, { useState, useEffect }) => {
	const textboxRef = Roact.createRef<TextBox>();
	const [players, setPlayers] = useState(() => Players.GetPlayers());
	const [partyName, setPartyName] = useState("Tutorial CODE");
	useEffect(() => {
		const onPlayerAddedConnection = Players.PlayerAdded.Connect((player) => {
			setPlayers((prevPlayers) => [...prevPlayers, player]);
		});

		const onPlayerRemovingConnection = Players.PlayerRemoving.Connect((player) => {
			setPlayers((prevPlayers) => prevPlayers.filter((p) => p !== player));
		});

		// Ensure that the TextBox instance is available
		const textboxInstance = textboxRef.getValue();
		if (textboxInstance) {
			textboxInstance.FocusLost.Connect(() => {
				if (textboxInstance.Text === "") {
					textboxInstance.Text = "The Nameless Party";
				}
			});
		}

		// Cleanup function
		return () => {
			onPlayerAddedConnection.Disconnect();
			onPlayerRemovingConnection.Disconnect();
		};
	}, []);

	return (
		<Panel index={Pages.tutorial} visible={props.visible}>
			<frame
				Size={new UDim2(1, 0, 1, 0)}
				Position={new UDim2(0, 0, 0, 0)}
				BackgroundColor3={Color3.fromRGB(0, 0, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={0}
			></frame>

			<frame
				Size={new UDim2(0.5, 0, 0.5, 0)}
				Position={new UDim2(0.5, 0, 0.5, 0)}
				BackgroundColor3={Color3.fromRGB(26, 26, 26)}
				BorderSizePixel={0}
				BackgroundTransparency={0}
				AnchorPoint={new Vector2(0.5, 0.5)}
			>
				<textlabel
					Key={"Title"}
					Text={"Are you sure you want to exit lobby and enter tutorial?"}
					FontSize={Enum.FontSize.Size14}
					Size={new UDim2(1, 0, 0.7, 0)}
					Position={new UDim2(0, 0, 0, 0)}
					BackgroundTransparency={1}
					TextColor3={Color3.fromRGB(255, 255, 255)}
					TextWrapped={true}
				/>
				<textbutton
					Key={"EnterButton"}
					Text={"Enter Tutorial"}
					FontSize={Enum.FontSize.Size14}
					Size={new UDim2(1, 0, 0.3, 0)}
					Position={new UDim2(0, 0, 0.7, 0)}
					BorderSizePixel={0}
					BackgroundColor3={Color3.fromRGB(0, 0, 0)}
					ZIndex={5}
					BackgroundTransparency={0.5}
					TextColor3={Color3.fromRGB(255, 255, 255)}
					Event={{
						MouseButton1Click: () => {
							// Open Tutorial Panel 13961980582
							// Teleport to Tutorial Game
							const player = Players.LocalPlayer;
							const placeId = 13961980582; // Replace with your Tutorial place Id
							TeleportService.Teleport(placeId, player);
						},
					}}
				>
					<uicorner CornerRadius={new UDim(0, 6)} />
					<uipadding
						PaddingTop={new UDim(0, 6)}
						PaddingBottom={new UDim(0, 6)}
						PaddingLeft={new UDim(0, 6)}
						PaddingRight={new UDim(0, 6)}
					/>
				</textbutton>
				<Close />
			</frame>
		</Panel>
	);
};

export default new Hooks(Roact)(TutorialHUD);
