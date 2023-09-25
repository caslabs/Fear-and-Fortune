import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Signals } from "shared/signals";
import { Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";
import ButtonDefault from "ui/components/Inputs/Buttons/ButtonDefault";

interface SpectateHUDProps {
	visible?: boolean;
}

const SpectateHUD: Hooks.FC<SpectateHUDProps> = (props, { useState }) => {
	return (
		<Panel index={Pages.spectate} visible={props.visible}>
			<frame
				//TODO: Fix Size
				Size={new UDim2(1, 0, 1, 0)}
				AnchorPoint={new Vector2(0, 0)}
				BackgroundTransparency={1}
			>
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
					Size={new UDim2(0.2, 0, 0.2, 0)}
				/>
				<textlabel Text={"Player1"} Size={new UDim2(0.1, 0, 0.1, 0)} />
				<ButtonDefault
					onClick={function (): void {
						Signals.switchToNextPlayer.Fire();
					}}
					text={">"}
					layout={1}
					Size={new UDim2(0.2, 0, 0.2, 0)}
				/>
			</frame>
		</Panel>
	);
};

export default new Hooks(Roact)(SpectateHUD);
