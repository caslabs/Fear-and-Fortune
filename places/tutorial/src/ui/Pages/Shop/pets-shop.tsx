import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Data } from "./index";
import ItemPurchase from "ui/components/Items/ItemPurchase";
interface PetsProps {
	data: Array<Data>;
	visible: string;
}

// Pet Shop Tab
const Pets: Hooks.FC<PetsProps> = (props, { useState }) => {
	return (
		<frame
			Key={"MoneyPage"}
			Size={new UDim2(1, 0, 1, -46)}
			Position={UDim2.fromScale(0, 1)}
			AnchorPoint={new Vector2(0, 1)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			Visible={props.visible === "pets"}
		>
			<uigridlayout CellPadding={UDim2.fromOffset(6, 6)} CellSize={UDim2.fromOffset(156, 142)} />
			{props.data.map((info) => (
				<ItemPurchase Key={info.name} title={info.name} desc={info.desc} color={info.color} />
			))}
		</frame>
	);
};

export default new Hooks(Roact)(Pets);
