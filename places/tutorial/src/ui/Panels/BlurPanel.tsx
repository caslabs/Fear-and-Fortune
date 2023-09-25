import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
//TODO: This component uses Context from lobby. Needs to be independent.
import { Context } from "../Context";
interface PanelProps {
	index: number;
	visible?: boolean;
	opacity?: number;
}

interface PanelProps {}

// Blur Panel for NoticeBoard
const BlurPanel: Hooks.FC<PanelProps> = (props, { useState }) => {
	const [panelVisible, setPanelVisible] = useState(false);
	return (
		<Context.Consumer
			render={(value: { viewIndex: number; setPage: (index: number) => void }) => {
				if (panelVisible === true && value.viewIndex !== props.index) {
					setPanelVisible(false);
				} else if (panelVisible === false && value.viewIndex === props.index) {
					setPanelVisible(true);
				}

				return (
					<frame
						Key={"BlurPanel-NoticeBoard"}
						Position={UDim2.fromScale(0.5, 0.5)}
						Size={UDim2.fromScale(1, 1)}
						AnchorPoint={new Vector2(0.5, 0.5)}
						BackgroundTransparency={props.opacity ?? 0.5}
						BorderSizePixel={0}
						BackgroundColor3={new Color3(30, 30, 30)}
						Visible={props.visible ?? panelVisible}
					>
						{props[Roact.Children]}
					</frame>
				);
			}}
		></Context.Consumer>
	);
};

export default new Hooks(Roact)(BlurPanel);
