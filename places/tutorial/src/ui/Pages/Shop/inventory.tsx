import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import PurchaseItem from "ui/components/Items/ItemPurchase";
import { Data } from "./index";
import { AutoScrollingFrame } from "ui/components/Dynamic/ScrollingFrame";

interface InventoryProps {
	data: Array<Data>;
	visible: string;
}

const Inventory: Hooks.FC<InventoryProps> = (props, { useState }) => {
	return (
		<frame
			Key={"InventoryPage"}
			Size={new UDim2(1, 0, 1, -46)}
			Position={UDim2.fromScale(0, 1)}
			AnchorPoint={new Vector2(0, 1)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			Visible={props.visible === "inventory"}
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
		</frame>
	);
};

export default new Hooks(Roact)(Inventory);
