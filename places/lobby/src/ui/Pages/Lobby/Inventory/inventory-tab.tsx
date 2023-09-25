import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import PurchaseItem from "ui/components/Items/ItemPurchase";
import { AutoScrollingFrame } from "ui/components/Dynamic/ScrollingFrame";
import InventoryItem from "./inventory-component";
import EmptyInventoryItem from "./empty-inventory-component";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";
import { InventoryItemData } from "../data/_inventoryData";
import { inventoryListDesc } from "../data/_inventoryDataDesc";
import { itemDesc } from "./description";

interface InventoryProps {
	visible?: string;
	data: Array<InventoryItemData>; // Add this line to declare the data prop
}

const UpdateInventoryEvent = Remotes.Client.Get("UpdateInventory");
const emptyInventoryItem: InventoryItemData = {
	name: "",
	quantity: 0,
	desc: "",
	// include any other necessary properties with default/empty values
};

function sortInventory(a: InventoryItemData, b: InventoryItemData) {
	if (a.name === "" && b.name !== "") {
		return false;
	} else if (a.name !== "" && b.name === "") {
		return true;
	} else {
		// If you need secondary sorting conditions, you can add them here
		return false;
	}
}

function returnDesc(itemName: string) {
	return (itemDesc as { [key: string]: string })[itemName];
}

//TODO: is there a better way? Had to use Global as setData was not updating the data variable
let full_inventory = [] as InventoryItemData[];
const Inventory: Hooks.FC<InventoryProps> = (props, { useState, useEffect }) => {
	const [data, setData] = useState<Array<InventoryItemData>>([]);
	const [backpackData, setBackpackData] = useState<Array<InventoryItemData>>([]); // New state for backpack data
	const [selectedTab, setSelectedTab] = useState<"inventory" | "backpack">("inventory");
	const [selectedItem, setSelectedItem] = useState("");

	useEffect(() => {
		const connection = UpdateInventoryEvent.Connect((player, item, action, quantity) => {
			print("[DEBUG] Calling UpdateInventoryEvent");
			if (player === Players.LocalPlayer) {
				setData((prevData) => {
					const existingItemIndex = prevData.findIndex((data) => data.name === item);
					let newData = full_inventory;

					if (existingItemIndex >= 0) {
						const existingItem = newData[existingItemIndex];
						if (action === "add") {
							existingItem.quantity += quantity;
						} else if (action === "remove") {
							if (existingItem.quantity > 1) {
								print(existingItem.quantity);
								existingItem.quantity += quantity;
							} else {
								newData = newData.filter((data) => data.name !== item);
							}
						}
					} else if (action === "add") {
						newData.push({ name: item, quantity, desc: "" });
					}

					print("[DEBUG-INVENTORY-TAB] New inventory data:", newData);
					full_inventory = newData;
					return full_inventory;
				});
			}
		});

		return () => connection.Disconnect();
	}, []);

	let filledInventoryArray = [...data];
	for (let i = data.size(); i < 50; i++) {
		filledInventoryArray.push(emptyInventoryItem);
	}

	filledInventoryArray = filledInventoryArray.sort(sortInventory);

	let filledBackpackArray = [...backpackData];
	for (let i = backpackData.size(); i < 10; i++) {
		filledBackpackArray.push(emptyInventoryItem);
	}

	filledBackpackArray = filledBackpackArray.sort(sortInventory);

	const filledArray = selectedTab === "inventory" ? filledInventoryArray : filledBackpackArray; // Select appropriate array based on tab

	return (
		<frame
			Key={"InventoryPage"}
			Size={new UDim2(1, 0, 1, 0)}
			Position={UDim2.fromScale(0, 1)}
			AnchorPoint={new Vector2(0, 1)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			Visible={props.visible === "inventory"}
		>
			<frame
				Key={"TabButtons"}
				Size={new UDim2(0.2, 0, 0.3, 0)}
				Position={UDim2.fromScale(0.8, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				BackgroundColor3={new Color3(0, 0, 0)}
			>
				<textbutton
					Key={"InventoryTabButton"}
					Text={"Inventory"}
					TextSize={13}
					Font={"GothamBold"}
					Size={UDim2.fromScale(1, 0.35)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Event={{
						MouseButton1Click: () => setSelectedTab("inventory"),
					}}
					BackgroundColor3={
						selectedTab === "inventory" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
					}
				/>
				<textbutton
					Key={"BackpackTabButton"}
					Text={"Backpack"}
					Font={"GothamBold"}
					TextSize={13}
					Size={UDim2.fromScale(1, 0.35)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Position={UDim2.fromScale(0, 0.4)}
					Event={{
						MouseButton1Click: () => setSelectedTab("backpack"),
					}}
					BackgroundColor3={
						selectedTab === "backpack" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
					}
				/>
			</frame>

			<scrollingframe
				Size={UDim2.fromScale(0.77, 1)}
				Position={UDim2.fromScale(0, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				ScrollBarThickness={6}
				Visible={selectedTab === "inventory"}
			>
				<uigridlayout
					CellPadding={UDim2.fromOffset(6, 6)}
					CellSize={UDim2.fromScale(0.15, 0.09)}
					SortOrder={Enum.SortOrder.LayoutOrder}
				/>

				{filledInventoryArray.map((item, index) =>
					// eslint-disable-next-line roblox-ts/lua-truthiness
					item.name ? (
						<InventoryItem
							Key={item.name}
							name={item.name}
							quantity={item.quantity}
							LayoutOrder={index}
							onClick={() => {
								setSelectedItem(returnDesc(item.name));
							}}
						/>
					) : (
						<EmptyInventoryItem Key={"Empty_" + tostring(index)} LayoutOrder={index} />
					),
				)}
			</scrollingframe>

			<scrollingframe
				Size={UDim2.fromScale(0.77, 1)}
				Position={UDim2.fromScale(0, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				ScrollBarThickness={6}
				Visible={selectedTab === "backpack"}
			>
				<uigridlayout
					CellPadding={UDim2.fromOffset(6, 6)}
					CellSize={UDim2.fromScale(0.2, 0.1)}
					SortOrder={Enum.SortOrder.LayoutOrder}
				/>

				{filledBackpackArray.map((item, index) =>
					// eslint-disable-next-line roblox-ts/lua-truthiness
					item.name ? (
						<InventoryItem Key={item.name} name={item.name} quantity={item.quantity} LayoutOrder={index} />
					) : (
						<EmptyInventoryItem Key={"Empty_" + tostring(index)} LayoutOrder={index} />
					),
				)}
			</scrollingframe>

			<textlabel
				// eslint-disable-next-line roblox-ts/lua-truthiness
				Text={selectedItem ? selectedItem : ""}
				Size={UDim2.fromScale(0.25, 0.3)}
				Position={UDim2.fromScale(0.89, 1)}
				AnchorPoint={new Vector2(0.5, 1)}
				BackgroundTransparency={1}
				TextColor3={new Color3(1, 1, 1)}
				Font={Enum.Font.GothamBold}
				TextWrapped={true}
				TextYAlignment={Enum.TextYAlignment.Top}
				TextXAlignment={Enum.TextXAlignment.Left}
			/>

			<textlabel
				Text={`${selectedTab} (${data.size()}/${selectedTab === "inventory" ? "50" : "10"})`}
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

export default new Hooks(Roact)(Inventory);
