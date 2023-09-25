import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import { Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";
import ButtonDefault from "ui/components/Inputs/Buttons/ButtonDefault";

interface SpectateHUDProps {
	visible?: boolean;
}

const ExtractToLobbyEvent = Remotes.Client.Get("ExtractToLobby");
const player = Players.LocalPlayer;
const SpectateHUD: Hooks.FC<SpectateHUDProps> = (props, { useState }) => {
	return (
		<Panel index={Pages.spectate} visible={props.visible}>
			<frame
				//TODO: Fix Size
				Size={new UDim2(1, 0, 1, 0)}
				AnchorPoint={new Vector2(0, 0)}
				BackgroundTransparency={1}
			>
				<textbutton Modal={true} BackgroundTransparency={1} Size={new UDim2(0, 0, 0, 0)} />
				<frame BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
					<uilistlayout
						SortOrder={"LayoutOrder"}
						VerticalAlignment={Enum.VerticalAlignment.Bottom}
						FillDirection={Enum.FillDirection.Horizontal}
						HorizontalAlignment={Enum.HorizontalAlignment.Center}
						Padding={new UDim(0, 100)}
					></uilistlayout>
					<uipadding PaddingBottom={new UDim(0, 30)} />
					<ButtonDefault
						onClick={function (): void {
							Signals.switchToPreviousPlayer.Fire();
						}}
						text={"<"}
						layout={0}
						Size={new UDim2(0.1, 0, 0.2, 0)}
					/>
					{/*
					TODO: Add name of player for spectating
					<textlabel Text={"Player1"} Size={new UDim2(0.1, 0, 0.1, 0)} />
					*/}
					<ButtonDefault
						onClick={function (): void {
							Signals.switchToNextPlayer.Fire();
						}}
						text={">"}
						layout={1}
						Size={new UDim2(0.1, 0, 0.2, 0)}
					/>
				</frame>
			</frame>
		</Panel>
	);
};

export default new Hooks(Roact)(SpectateHUD);
