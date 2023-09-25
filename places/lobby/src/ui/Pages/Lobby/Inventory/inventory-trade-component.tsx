import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Theme from "ui/theme";

// InventoryItem.ts

interface InventoryItemProps {
	name: string;
	color?: Color3;
	desc?: string;
	quantity: number;
	LayoutOrder: number;
	onClick: () => void; // Added onClick prop
}

const InventoryTradeItem: Hooks.FC<InventoryItemProps> = (props, { useState }) => {
	const [highlighted, setHighlighted] = useState(false);

	return (
		<textbutton
			Key={props.name}
			Text={props.name}
			TextColor3={Color3.fromRGB(222, 222, 222)}
			BackgroundColor3={highlighted ? props.color ?? Color3.fromRGB(26, 26, 26) : Color3.fromRGB(60, 60, 60)}
			Event={{
				MouseEnter: () => setHighlighted(true),
				MouseLeave: () => setHighlighted(false),
				MouseButton1Click: props.onClick, // Here's where we use the onClick function
			}}
			LayoutOrder={props.LayoutOrder}
			TextScaled={true}
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
			<uipadding
				PaddingTop={new UDim(0, 6)}
				PaddingBottom={new UDim(0, 6)}
				PaddingLeft={new UDim(0, 6)}
				PaddingRight={new UDim(0, 6)}
			/>
			<textlabel
				Text={"x" + tostring(props.quantity)}
				BackgroundTransparency={1}
				TextColor3={Color3.fromRGB(200, 200, 200)}
				Font={Theme.FontNormal}
				TextSize={18}
				AutomaticSize={"Y"}
				TextWrapped={true}
				Size={new UDim2(1, 0, 0, 0)}
			/>

			{/* Display the item description when the button is highlighted */}
			{highlighted && (
				<textlabel
					Text={props.desc ?? ""}
					BackgroundTransparency={1}
					TextColor3={Color3.fromRGB(255, 255, 255)}
					Font={Theme.FontNormal}
					TextSize={18}
					AutomaticSize={"Y"}
					TextWrapped={true}
				/>
			)}
		</textbutton>
	);
};

export default new Hooks(Roact)(InventoryTradeItem);
