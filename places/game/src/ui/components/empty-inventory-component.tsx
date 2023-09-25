import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Theme from "ui/theme";

interface EmptyInventoryItemProps {
	color?: Color3;
	LayoutOrder: number;
}

const EmptyInventoryItem: Hooks.FC<EmptyInventoryItemProps> = (props) => {
	return (
		<frame
			Key={"EmptyInventoryItem"}
			BackgroundColor3={props.color ?? Color3.fromRGB(38, 33, 33)}
			LayoutOrder={props.LayoutOrder}
			Size={UDim2.fromScale(1, 1)}
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
			<uipadding
				PaddingTop={new UDim(0, 6)}
				PaddingBottom={new UDim(0, 6)}
				PaddingLeft={new UDim(0, 6)}
				PaddingRight={new UDim(0, 6)}
			/>
		</frame>
	);
};

export default new Hooks(Roact)(EmptyInventoryItem);
