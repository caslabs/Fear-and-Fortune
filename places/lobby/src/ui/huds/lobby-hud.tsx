import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Pages } from "ui/routers/Lobby/Context-LobbyHUD";
import { Panel } from "ui/Pages/Panels/PanelLobby/Panel";
import Lobby from "ui/Pages/Lobby";

interface LobbyHUDProps {
	visible?: boolean;
}

const LobbyHUD: Hooks.FC<LobbyHUDProps> = (props, { useState }) => {
	return (
		<Panel index={Pages.lobby} visible={props.visible}>
			<frame
				Size={new UDim2(1, 0, 1, 0)}
				Position={new UDim2(0, 0, 0, 0)}
				BackgroundColor3={Color3.fromRGB(0, 0, 0)}
				BorderSizePixel={0}
			/>
			<Lobby />
		</Panel>
	);
};

export default new Hooks(Roact)(LobbyHUD);
