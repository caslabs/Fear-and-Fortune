import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import CraftItem from "ui/components/Items/CraftItem"; // Import CraftItem
import { AutoScrollingFrame } from "ui/components/Dynamic/ScrollingFrame";

export interface Data {
	name: string;
	desc: string;
	color: Color3;
	ingredients: Array<{ itemName: string; quantity: number }>; // New property
}

interface CraftingProps {
	data: Array<Data>;
	visible: string;
}

const Crafting: Hooks.FC<CraftingProps> = (props, { useState }) => {
	const [selectedCraftItem, setSelectedCraftItem] = useState<Data | undefined>(props.data[0]); // Default to first item
	const [activeCraftItem, setActiveCraftItem] = useState<string>(props.data[0].name); // Default to first item's name

	return (
		<frame
			Key={"Crafting"}
			Size={new UDim2(1, 0, 1, 0)}
			Position={UDim2.fromScale(0, 1)}
			AnchorPoint={new Vector2(0, 1)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			Visible={props.visible === "crafting"}
		>
			<scrollingframe
				Size={UDim2.fromScale(0.27, 1)} // Adjust to make room for crafting info
				Position={UDim2.fromScale(0, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				ScrollBarThickness={3}
				AutomaticCanvasSize={"Y"}
			>
				<uigridlayout CellPadding={UDim2.fromScale(0, 0.03)} CellSize={UDim2.fromScale(1, 0.2)} />
				{props.data.map((info, index) => (
					<CraftItem
						Key={info.name}
						title={info.name}
						desc={info.desc}
						color={info.color}
						layoutOrder={index}
						active={activeCraftItem === info.name} // Pass active state
						onClick={() => {
							setSelectedCraftItem(info);
							setActiveCraftItem(info.name); // Set this item as active
						}}
					/>
				))}
			</scrollingframe>
			{selectedCraftItem && (
				<frame
					// Crafting Info Panel
					Size={UDim2.fromScale(0.7, 1)}
					Position={UDim2.fromScale(0.3, 0)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
				>
					<textlabel
						Text={selectedCraftItem.name}
						Size={UDim2.fromScale(1, 0.2)} /* Rest of the properties */
						BackgroundTransparency={1}
						Font={Enum.Font.Gotham}
						TextColor3={Color3.fromRGB(230, 230, 230)}
						FontSize={Enum.FontSize.Size24}
					/>
					<textlabel
						Text={selectedCraftItem.desc}
						Position={UDim2.fromScale(0, 0.2)}
						Size={UDim2.fromScale(1, 0.25)} /* Rest of the properties */
						BackgroundTransparency={1}
						TextXAlignment={Enum.TextXAlignment.Left}
						TextYAlignment={Enum.TextYAlignment.Top}
						Font={Enum.Font.Gotham}
						FontSize={Enum.FontSize.Size14}
						RichText={true}
						TextWrapped={true}
						TextColor3={Color3.fromRGB(230, 230, 230)}
					/>
					<textlabel
						Text={"Ingredients:"}
						Position={UDim2.fromScale(0, 0.5)}
						Size={UDim2.fromScale(1, 0.1)}
						BackgroundTransparency={1}
						TextXAlignment={Enum.TextXAlignment.Left}
						TextYAlignment={Enum.TextYAlignment.Top}
						Font={Enum.Font.Gotham}
						FontSize={Enum.FontSize.Size14}
						RichText={true}
						TextColor3={Color3.fromRGB(230, 230, 230)}
					/>
					{selectedCraftItem.ingredients.map((ingredient, index) => (
						<textlabel
							Key={ingredient.itemName}
							Text={`${ingredient.quantity}x ${ingredient.itemName}`}
							Position={UDim2.fromScale(0, 0.55 + index * 0.05)}
							Size={UDim2.fromScale(1, 0.02)}
							BackgroundTransparency={1}
							TextXAlignment={Enum.TextXAlignment.Left}
							TextYAlignment={Enum.TextYAlignment.Top}
							Font={Enum.Font.Gotham}
							FontSize={Enum.FontSize.Size14}
							RichText={true}
							TextColor3={Color3.fromRGB(230, 230, 230)}
						/>
					))}
					<textbutton
						Text={"CRAFT"}
						Size={UDim2.fromScale(1, 0.2)}
						AnchorPoint={new Vector2(0, 1)}
						Position={UDim2.fromScale(0, 1)}
						Font={Enum.Font.Gotham}
						TextColor3={Color3.fromRGB(200, 200, 200)}
						BackgroundColor3={Color3.fromRGB(75, 75, 75)}
					/>
				</frame>
			)}
		</frame>
	);
};

export default new Hooks(Roact)(Crafting);
