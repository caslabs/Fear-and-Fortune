import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { InventoryItemData } from "ui/screens/_inventoryData";
import InventoryItem from "./inventory-component";
import EmptyInventoryItem from "./empty-inventory-component";
import Theme from "ui/theme";
import HotbarInventoryComponent from "./hotbar-inventory-component";

interface HotbarSlotProps {
	slotNumber: number;
	item?: InventoryItemData;
	LayoutOrder: number;
	selected?: boolean; // New prop
	onUserInput?: (slotNumber: number) => void; // Function to be called when user interacts with the slot
}

const HotbarSlot: Hooks.FC<HotbarSlotProps> = (props) => {
	const handleUserInput = () => {
		// Propagate event to parent component
		props.onUserInput && props.onUserInput(props.slotNumber);
	};

	return (
		<textbutton
			Key={"Slot " + props.slotNumber}
			LayoutOrder={props.LayoutOrder}
			BackgroundTransparency={1}
			TextTransparency={1}
			Event={{
				Activated: handleUserInput,
			}}
		>
			<textlabel
				Key={"Slot Number"}
				Text={tostring(props.slotNumber)}
				Position={UDim2.fromScale(0.8, 0.25)}
				TextColor3={props.selected ? Color3.fromRGB(255, 255, 255) : Color3.fromRGB(125, 125, 125)} // Change color based on selection state
				ZIndex={9999}
				TextStrokeTransparency={1}
			/>
			{/* TextLabel to display slot number */}
			{props.item ? (
				<HotbarInventoryComponent
					Key={props.item.name}
					name={props.item.name}
					quantity={props.item.quantity}
					LayoutOrder={props.LayoutOrder}
				/>
			) : (
				<EmptyInventoryItem Key={"Empty_" + props.slotNumber} LayoutOrder={props.LayoutOrder} />
			)}
		</textbutton>
	);
};

export default new Hooks(Roact)(HotbarSlot);
