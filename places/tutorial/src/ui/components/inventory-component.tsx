import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Theme from "ui/theme";

// InventoryItem.ts

interface InventoryItemProps {
	name: string;
	color?: Color3;
	desc?: string;
}

const InventoryItem: Hooks.FC<InventoryItemProps> = (props, { useState }) => {
	const [highlighted, setHighlighted] = useState(false);

	return (
		<textbutton
			Key={props.name}
			Text={props.name}
			BackgroundColor3={
				highlighted ? props.color ?? Color3.fromRGB(255, 255, 255) : Color3.fromRGB(107, 105, 105)
			}
			Event={{
				MouseEnter: () => setHighlighted(true),
				MouseLeave: () => setHighlighted(false),
			}}
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
			<uipadding
				PaddingTop={new UDim(0, 6)}
				PaddingBottom={new UDim(0, 6)}
				PaddingLeft={new UDim(0, 6)}
				PaddingRight={new UDim(0, 6)}
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

export default new Hooks(Roact)(InventoryItem);
