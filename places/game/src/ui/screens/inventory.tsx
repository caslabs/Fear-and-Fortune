import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Players } from "@rbxts/services";
import { Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";
import InventoryItem from "ui/components/inventory-component";
import EmptyInventoryItem from "ui/components/empty-inventory-component";
import { InventoryItemData } from "./_inventoryData";
import Remotes from "shared/remotes";

interface InventoryProps {
	visible?: boolean;
	data: Array<InventoryItemData>; // Add this line to declare the data prop
}

//TODO: is there a better way? Had to use Global as setData was not updating the data variable
const full_inventory = [] as InventoryItemData[];

const UpdateInventoryEvent = Remotes.Client.Get("UpdateInventory");
print("Inventory loaded");
const Inventory: Hooks.FC<InventoryProps> = (props, { useState, useEffect }) => {
	const [data, setData] = useState<Array<InventoryItemData>>([]);
	useEffect(() => {
		const connection = UpdateInventoryEvent.Connect((player, item, action, quantity) => {
			print("[DEBUG] Calling UpdateInventoryEvent");
			if (player === Players.LocalPlayer) {
				setData((prevData) => {
					const existingItemIndex = prevData.findIndex((data) => data.name === item);
					let newData = [...prevData]; // Create a new array from the previous data

					if (existingItemIndex >= 0) {
						const existingItem = newData[existingItemIndex];
						if (action === "add") {
							existingItem.quantity = quantity;
						} else if (action === "remove") {
							if (existingItem.quantity > 1) {
								existingItem.quantity -= 1;
							} else {
								newData = newData.filter((data) => data.name !== item);
							}
						}
					} else if (action === "add") {
						newData.push({ name: item, quantity });
					}

					print("[DEBUG] New inventory data:", newData);
					return newData;
				});
			}
		});

		return () => connection.Disconnect();
	}, []);

	return (
		<Panel Key={"Inventory"} index={Pages.inventory} visible={props.visible}>
			<textbutton Modal={true} BackgroundTransparency={1} Size={new UDim2(0, 0, 0, 0)} />
			<frame
				Key={"Inventory"}
				Size={new UDim2(0.4, 0, 0.7, 0)}
				Position={UDim2.fromScale(0.5, 0.5)}
				AnchorPoint={new Vector2(0.5, 0.5)}
				BorderSizePixel={0}
				BackgroundTransparency={0}
				BackgroundColor3={Color3.fromRGB(26, 26, 26)}
			>
				<scrollingframe
					Size={UDim2.fromScale(1, 1)} // Adjust to make room for crafting info
					Position={UDim2.fromScale(0, 0)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
					ScrollBarThickness={6}
					BackgroundColor3={Color3.fromRGB(0, 0, 0)}
				>
					<uigridlayout
						CellPadding={UDim2.fromOffset(6, 6)}
						CellSize={UDim2.fromScale(0.2, 0.1)}
						SortOrder={Enum.SortOrder.LayoutOrder}
					/>

					{data.map((item, index) =>
						//TODO: Update the backpack system
						// eslint-disable-next-line roblox-ts/lua-truthiness
						item.name ? (
							<InventoryItem
								Key={item.name}
								name={item.name}
								quantity={item.quantity}
								LayoutOrder={index}
							/>
						) : (
							<EmptyInventoryItem Key={"Empty_" + tostring(index)} LayoutOrder={index} />
						),
					)}
				</scrollingframe>

				<textlabel
					Text={`backpack ${data.size()}/10`}
					Size={UDim2.fromScale(0.4, 0.09)}
					Position={UDim2.fromScale(0.5, 0.9)}
					AnchorPoint={new Vector2(0.5, 0)}
					BackgroundTransparency={1}
					TextColor3={new Color3(1, 1, 1)}
					Font={Enum.Font.GothamBold}
				/>
			</frame>
		</Panel>
	);
};

export default new Hooks(Roact)(Inventory);
