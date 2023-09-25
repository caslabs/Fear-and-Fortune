import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import InventoryTradeItem from "../../Inventory/inventory-trade-component";
import EmptyInventoryItem from "../../Inventory/empty-inventory-component";
import Remotes from "shared/remotes";
import { tradeInventoryList2, itemValues2 } from "./data/_TradeData2";
import { InventoryItemData } from "../../data/_inventoryData";

interface ElGoblinoProps {
	isVisible: boolean;
	data: Array<InventoryItemData>;
}
const UpdateInventoryTradingEvent = Remotes.Client.Get("UpdateInventoryTrading");
const emptyInventoryItem: InventoryItemData = {
	name: "",
	quantity: 0,
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

// Credit Screen Button
const ElGoblino: Hooks.FC<ElGoblinoProps> = (props, { useState, useEffect }) => {
	const [data, setData] = useState<Array<InventoryItemData>>([]);
	const [tradeData, settradeData] = useState<Array<InventoryItemData>>(tradeInventoryList2); // New state for backpack data
	const [selectedTab, setSelectedTab] = useState<"inventory" | "vendor1" | "vendor2">("vendor1");
	const [tradeValue, setTradeValue] = useState<number>(0);

	let filledInventoryArray = [...data];
	for (let i = data.size(); i < 50; i++) {
		filledInventoryArray.push(emptyInventoryItem);
	}

	let filledTradeArray = [...tradeData];
	for (let i = tradeData.size(); i < 50; i++) {
		filledTradeArray.push(emptyInventoryItem);
	}

	useEffect(() => {
		filledTradeArray = filledTradeArray.sort(sortInventory);
		filledInventoryArray = filledInventoryArray.sort(sortInventory);
	}, []);

	return (
		<scrollingframe
			Size={UDim2.fromScale(0.77, 0.38)}
			Position={UDim2.fromScale(0, 0.6)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			ScrollBarThickness={6}
			Visible={props.isVisible}
		>
			<uigridlayout
				CellPadding={UDim2.fromOffset(6, 6)}
				CellSize={UDim2.fromScale(0.15, 0.09)}
				SortOrder={Enum.SortOrder.LayoutOrder}
			/>

			{props.data.map((item, index) =>
				// eslint-disable-next-line roblox-ts/lua-truthiness
				item.name ? (
					<InventoryTradeItem
						Key={item.name}
						name={item.name}
						quantity={item.quantity}
						LayoutOrder={index}
						onClick={() => {
							if (item.quantity > 0) {
								// Add this condition
								// create a copy of item but with quantity 1 for the trade
								const singleItem = { ...item, quantity: 1 };

								// reduce the quantity of this item in the player's inventory by 1
								const updatedInventory = filledInventoryArray
									.map((inventoryItem) =>
										inventoryItem.name === item.name
											? { ...inventoryItem, quantity: inventoryItem.quantity - 1 }
											: inventoryItem,
									)
									.filter((item) => item.quantity > 0); // this removes items with quantity 0
								print("[DEBUG] updatedInventory", updatedInventory);
								// check if the item already exists in the player's inventory
								const existingItemIndex = filledTradeArray.findIndex(
									(inventoryItem) => inventoryItem.name === item.name,
								);

								let updatedTradeInventory;
								if (existingItemIndex !== -1) {
									// item exists, update the quantity
									updatedTradeInventory = filledTradeArray.map((inventoryItem, index) =>
										index === existingItemIndex
											? { ...inventoryItem, quantity: inventoryItem.quantity + 1 }
											: inventoryItem,
									);
								} else {
									// item does not exist, add it to the inventory
									updatedTradeInventory = [...filledTradeArray, singleItem];
								}

								// Check if the item already exists in
								//filledTradeArray.push(singleItem);
								print("[BOOGA0] updatedInventory", updatedInventory);
								// Remove Empty Inventory Items
								//updatedInventory = filledInventoryArray.filter((item) => item.name !== "");
								setData(updatedInventory); // Updating the inventory data state
								settradeData(updatedTradeInventory); // Updating the trade data state

								if (singleItem.name in itemValues2) {
									setTradeValue((prevValue) => prevValue + itemValues2[singleItem.name]);
								}
							} else {
								// Display a message or warning that the player doesn't have enough quantity of the item
							}
						}}
					/>
				) : (
					<EmptyInventoryItem Key={"Empty_" + tostring(index)} LayoutOrder={index} />
				),
			)}
		</scrollingframe>
	);
};

export default new Hooks(Roact)(ElGoblino);
