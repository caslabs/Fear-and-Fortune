import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import PurchaseItem from "ui/components/Items/ItemPurchase";
import { Data } from "../index";
import { AutoScrollingFrame } from "ui/components/Dynamic/ScrollingFrame";

interface GamePassesProps {
	data: Array<Data>;
	visible: string;
}

const GamePasses: Hooks.FC<GamePassesProps> = (props, { useState }) => {
	return (
		<frame
			Key={"GamepassPage"}
			Size={new UDim2(1, 0, 1, 0)}
			Position={UDim2.fromScale(0, 1)}
			AnchorPoint={new Vector2(0, 1)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			Visible={props.visible === "gamepasses"}
		>
			<AutoScrollingFrame
				Size={UDim2.fromScale(1, 1)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				ScrollBarThickness={6}
			>
				<uigridlayout CellPadding={UDim2.fromOffset(6, 6)} CellSize={UDim2.fromOffset(152, 150)} />
				{props.data.map((info) => (
					<PurchaseItem Key={info.name} title={info.name} desc={info.desc} color={info.color} />
				))}
			</AutoScrollingFrame>
			<textlabel
				Text={"[PLAYTEST EDITION] You can only window shop for now!"}
				Size={UDim2.fromScale(0.4, 0.09)}
				Position={UDim2.fromScale(0.5, 0.95)}
				AnchorPoint={new Vector2(0.5, 0)}
				BackgroundTransparency={1}
				TextColor3={new Color3(1, 1, 1)}
				Font={Enum.Font.GothamBold}
			/>
		</frame>
	);
};

export default new Hooks(Roact)(GamePasses);
