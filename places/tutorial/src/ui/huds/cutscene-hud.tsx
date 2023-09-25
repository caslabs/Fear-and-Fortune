import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";

interface CutsceneHUDProps {
	visible?: boolean;
}

const CutsceneHUD: Hooks.FC<CutsceneHUDProps> = (props, { useState }) => {
	const barHeightRatio = 0.1;

	return (
		<Panel index={Pages.cutscene} visible={props.visible}>
			<frame
				Size={new UDim2(1, 0, barHeightRatio, 0)}
				Position={new UDim2(0, 0, 0, 0)}
				BackgroundColor3={new Color3(0, 0, 0)}
				BorderSizePixel={0}
			/>
			<frame
				Size={new UDim2(1, 0, barHeightRatio, 0)}
				Position={new UDim2(0, 0, 1 - barHeightRatio, 0)}
				BackgroundColor3={new Color3(0, 0, 0)}
				BorderSizePixel={0}
			/>
		</Panel>
	);
};

export default new Hooks(Roact)(CutsceneHUD);
