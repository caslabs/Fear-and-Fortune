import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import PurchaseItem from "ui/components/Items/ItemPurchase";
import { Data, Inventory } from "../index";
import { AutoScrollingFrame } from "ui/components/Dynamic/ScrollingFrame";
import { InventoryItemData } from "../data/_inventoryData";
import InventoryTradeItem from "../Inventory/inventory-trade-component";
import EmptyInventoryItem from "../Inventory/empty-inventory-component";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";
import { tradeInventoryList, itemValues } from "./vendors/data/_TradeData";
import { tradeInventoryList2, itemValues2 } from "./vendors/data/_TradeData2";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";

interface InventoryProps {
	visible?: string;
	data: Array<InventoryItemData>; // Add this line to declare the data prop
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

function reorderInventory(inventory: InventoryItemData[]) {
	return inventory.sort(sortInventory);
}

function compareInventories(
	oldInventory: readonly InventoryItemData[],
	newInventory: readonly InventoryItemData[],
): { [key: string]: number } {
	const oldInventoryMap = new Map<string, number>();
	const newInventoryMap = new Map<string, number>();
	const changes: { [key: string]: number } = {};

	oldInventory.forEach((item) => {
		oldInventoryMap.set(item.name, item.quantity);
	});

	newInventory.forEach((item) => {
		newInventoryMap.set(item.name, item.quantity);
	});

	oldInventoryMap.forEach((value: number, key: string) => {
		const newQuantity = newInventoryMap.get(key) ?? 0;
		const diff = newQuantity - value;
		if (diff !== 0) {
			changes[key] = diff;
		}
	});

	newInventoryMap.forEach((value: number, key: string) => {
		if (!oldInventoryMap.has(key)) {
			changes[key] = value;
		}
	});

	return changes;
}

//TODO: Apparently UpdateInventory is a one-to-one event, so we need to create a new event for trading

const TradeRequestEvent = Remotes.Client.Get("TradeRequest");
let full_inventory = [] as InventoryItemData[];

const player = Players.LocalPlayer;
const Trade: Hooks.FC<InventoryProps> = (props, { useState, useEffect }) => {
	const [data, setData] = useState<Array<InventoryItemData>>([]);
	const [tradeData, settradeData] = useState<Array<InventoryItemData>>(tradeInventoryList);
	const [tradeData2, settradeData2] = useState<Array<InventoryItemData>>(tradeInventoryList2); // New state for backpack data
	const [selectedTab, setSelectedTab] = useState<"inventory" | "vendor1" | "vendor2">("vendor1");
	const [tradeValue, setTradeValue] = useState<number>(0);
	const filledInventoryArray = [...data];
	for (let i = data.size(); i < 50; i++) {
		filledInventoryArray.push(emptyInventoryItem);
	}

	const filledTradeArray = [...tradeData];
	for (let i = tradeData.size(); i < 50; i++) {
		filledTradeArray.push(emptyInventoryItem);
	}

	const filledTradeArray2 = [...tradeData2];
	for (let i = tradeData2.size(); i < 50; i++) {
		filledTradeArray2.push(emptyInventoryItem);
	}

	//TODO : Fix Trading synchronization
	useEffect(() => {
		print("[TRADE] Running useEffect in Trade tab");
		const connection1 = UpdateInventoryTradingEvent.Connect((player, item, action, quantity) => {
			print("[TRADE] Calling UpdateInventoryTradingEvent in Trade tab");
			if (player === Players.LocalPlayer) {
				setData((prevData) => {
					const existingItemIndex = prevData.findIndex((data) => data.name === item);
					let newData = full_inventory;

					if (existingItemIndex >= 0) {
						const existingItem = newData[existingItemIndex];
						print(existingItem);
						if (action === "add") {
							existingItem.quantity += quantity;
						} else if (action === "remove") {
							print("[PLEASE] Remove item from inventory");
							if (existingItem.quantity > 1) {
								print(existingItem.quantity);
								existingItem.quantity += quantity;
								print("[BOOGA1], newData");
							} else {
								newData = newData.filter((data) => data.name !== item);
								print(newData);
								print("[BOOGA2], newData");
							}
						}
					} else if (action === "add") {
						newData.push({ name: item, quantity });
						print("[BOOGA-INFINITY], newData");
					}

					print("[DEBUG-TRADING-TAB] New inventory data:", newData);
					full_inventory = newData;
					return full_inventory;
				});
			}
		});

		return () => connection1.Disconnect();
	}, []);

	return (
		<frame
			Key={"TradePage"}
			Size={new UDim2(1, 0, 1, 0)}
			Position={UDim2.fromScale(0, 1)}
			AnchorPoint={new Vector2(0, 1)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			Visible={props.visible === "trade"}
		>
			<frame
				Key={"TabButtons"}
				Size={new UDim2(0.2, 0, 1, 0)}
				Position={UDim2.fromScale(0.8, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				BackgroundColor3={new Color3(0, 0, 0)}
			>
				<imagelabel
					Key={"TabButtonBackground"}
					Size={UDim2.fromScale(1, 0.25)}
					Position={UDim2.fromScale(0, 0)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
					Image={`${selectedTab === "vendor1" ? "rbxassetid://14034815981" : "rbxassetid://14041849448"}`}
					ScaleType={"Crop"}
				/>
				<textlabel
					Key={"VendorHeader"}
					Text={"Vendors"}
					Font={"GothamBold"}
					TextSize={13}
					BackgroundTransparency={1}
					Size={UDim2.fromScale(1, 0.1)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Position={UDim2.fromScale(0, 0.25)}
					BackgroundColor3={Color3.fromRGB(45, 45, 45)}
				/>

				<textbutton
					Key={"BackpackTabButton"}
					Text={"Pocketcat"}
					Font={"GothamBold"}
					TextSize={13}
					Size={UDim2.fromScale(1, 0.1)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Position={UDim2.fromScale(0, 0.33)}
					Event={{
						MouseButton1Click: () => {
							setSelectedTab("vendor1");
							SoundSystemController.playSound(SoundKeys.SFX_MR_KITTEN);
						},
					}}
					BackgroundColor3={
						selectedTab === "vendor1" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
					}
				/>

				<textbutton
					Key={"ElGoblinoMerchant"}
					Text={"El Goblino"}
					Font={"GothamBold"}
					TextSize={13}
					Size={UDim2.fromScale(1, 0.1)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Position={UDim2.fromScale(0, 0.45)}
					Event={{
						MouseButton1Click: () => {
							setSelectedTab("vendor2");
							SoundSystemController.playSound(SoundKeys.SFX_EL_GOBLINO);
						},
					}}
					BackgroundColor3={
						selectedTab === "vendor2" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
					}
				/>

				<textbutton
					Key={"SellButton"}
					Text={`Trade (${tradeValue}s)\n [LOCKED]`}
					Font={"GothamBold"}
					TextSize={13}
					Size={UDim2.fromScale(1, 0.1)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Position={UDim2.fromScale(0, 1)}
					AnchorPoint={new Vector2(0, 1)}
					Event={{
						MouseButton1Click: () => {
							print("Selling items");
							print("NEW STASH DATA 1", data);
							print("NEW STASH DATA 2", full_inventory);
							print(compareInventories(full_inventory, data));
							//TradeRequestEvent.SendToServer(tradeValue, compareInventories(full_inventory, data));
							//TradeRequestEvent.SendToServer(tradeValue, compareInventories(full_inventory, data));
							print("DATA, ", data);
							//setTradeValue(0);
						},
					}}
					BackgroundColor3={Color3.fromRGB(128, 128, 128)}
				/>
			</frame>

			<textlabel
				Text={`${
					selectedTab === "inventory" ? "Player" : selectedTab === "vendor1" ? "Pocketcat" : "El Goblino"
				}`}
				Size={UDim2.fromScale(0.3, 0.025)}
				TextScaled={true}
				Position={UDim2.fromScale(0, 0)}
				AnchorPoint={new Vector2(0, 0)}
				BackgroundTransparency={1}
				TextColor3={new Color3(1, 1, 1)}
				Font={Enum.Font.GothamBold}
				TextXAlignment={Enum.TextXAlignment.Left}
				TextYAlignment={Enum.TextYAlignment.Bottom}
			/>

			<textlabel
				Text={`Your inventory (${data.size()}/${selectedTab === "inventory" ? "50" : "50"})`}
				Size={UDim2.fromScale(0.3, 0.025)}
				TextScaled={true}
				Position={UDim2.fromScale(0, 0.55)}
				AnchorPoint={new Vector2(0, 0)}
				BackgroundTransparency={1}
				TextColor3={new Color3(1, 1, 1)}
				Font={Enum.Font.GothamBold}
				TextXAlignment={Enum.TextXAlignment.Left}
				TextYAlignment={Enum.TextYAlignment.Bottom}
			/>

			<textlabel
				Text={`${
					selectedTab === "vendor1"
						? "My trade's in whispers, silence my cheat, care to guess my cravings of such meat?"
						: "El Goblino, dweller of caverns deep, trades in trinkets of dreams and sleep; shadows whisper, in jingles and clink, 'Dare you barter on the brink?"
				}`}
				Size={UDim2.fromScale(1, 0.025)}
				TextScaled={true}
				Position={UDim2.fromScale(0.35, 1.1)}
				AnchorPoint={new Vector2(0.5, 0)}
				BackgroundTransparency={1}
				TextColor3={new Color3(1, 1, 1)}
				Font={Enum.Font.GothamBold}
				TextXAlignment={Enum.TextXAlignment.Center}
				TextYAlignment={Enum.TextYAlignment.Bottom}
			/>

			<scrollingframe
				Size={UDim2.fromScale(0.77, 0.38)}
				Position={UDim2.fromScale(0, 0.6)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				ScrollBarThickness={6}
			>
				<uigridlayout
					CellPadding={UDim2.fromOffset(6, 6)}
					CellSize={UDim2.fromScale(0.15, 0.09)}
					SortOrder={Enum.SortOrder.LayoutOrder}
				/>

				{filledInventoryArray.map((item, index) =>
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
										updatedTradeInventory = updatedTradeInventory.filter(
											(item) => item.name !== "",
										);

										for (let i = updatedTradeInventory.size(); i < 50; i++) {
											updatedTradeInventory.push(emptyInventoryItem);
										}

										print("[BOOGA0] updatedTradeInventory", updatedTradeInventory);
									}

									// Check if the item already exists in
									//filledTradeArray.push(singleItem);
									print("[BOOGA0] updatedInventory", updatedInventory);
									// Remove Empty Inventory Items
									//updatedInventory = filledInventoryArray.filter((item) => item.name !== "");
									setData(updatedInventory); // Updating the inventory data state
									settradeData(updatedTradeInventory); // Updating the trade data state
									print("updatedTradeInventory", updatedTradeInventory);

									if (singleItem.name in itemValues) {
										setTradeValue((prevValue) => prevValue + itemValues[singleItem.name]);
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

			<scrollingframe
				Size={UDim2.fromScale(0.77, 0.5)}
				Position={UDim2.fromScale(0, 0.035)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				ScrollBarThickness={6}
				Visible={selectedTab === "vendor1"}
			>
				<uigridlayout
					CellPadding={UDim2.fromOffset(6, 6)}
					CellSize={UDim2.fromScale(0.15, 0.09)}
					SortOrder={Enum.SortOrder.LayoutOrder}
				/>

				{filledTradeArray.map((item, index) =>
					item.name ? (
						<InventoryTradeItem
							Key={item.name}
							name={item.name}
							quantity={item.quantity}
							LayoutOrder={index}
							onClick={() => {
								if (item.quantity > 0) {
									// create a copy of item but with quantity 1 for the trade
									const singleItem = { ...item, quantity: 1 };

									// reduce the quantity of this item in the trade inventory by 1
									const updatedTrade = filledTradeArray
										.map((tradeItem) =>
											tradeItem.name === item.name
												? { ...tradeItem, quantity: tradeItem.quantity - 1 }
												: tradeItem,
										)
										.filter((item) => item.quantity > 0); // this removes items with quantity 0

									// check if the item already exists in the player's inventory
									const existingItemIndex = filledInventoryArray.findIndex(
										(inventoryItem) => inventoryItem.name === item.name,
									);

									let updatedInventory;
									if (existingItemIndex !== -1) {
										// item exists, update the quantity
										updatedInventory = filledInventoryArray.map((inventoryItem, index) =>
											index === existingItemIndex
												? { ...inventoryItem, quantity: inventoryItem.quantity + 1 }
												: inventoryItem,
										);
									} else {
										// item does not exist, add it to the inventory
										// fuklter
										updatedInventory = [...filledInventoryArray, singleItem];
									}

									// Filter out empty trade items
									print("[DEBUG VENDOR] updatedInventory", updatedInventory);
									// Remove Empty Inventory Items
									updatedInventory = updatedInventory.filter((item) => item.name !== "");
									setData(updatedInventory); // Updating the inventory data state
									settradeData(updatedTrade); // Updating the trade data state

									if (singleItem.name in itemValues) {
										setTradeValue((prevValue) => prevValue - itemValues[singleItem.name]);
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

			<scrollingframe
				Size={UDim2.fromScale(0.77, 0.5)}
				Position={UDim2.fromScale(0, 0.035)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				ScrollBarThickness={6}
				Visible={selectedTab === "vendor2"}
			>
				<uigridlayout
					CellPadding={UDim2.fromOffset(6, 6)}
					CellSize={UDim2.fromScale(0.15, 0.09)}
					SortOrder={Enum.SortOrder.LayoutOrder}
				/>

				{filledTradeArray2.map((item, index) =>
					item.name ? (
						<InventoryTradeItem
							Key={item.name}
							name={item.name}
							quantity={item.quantity}
							LayoutOrder={index}
							onClick={() => {
								if (item.quantity > 0) {
									// create a copy of item but with quantity 1 for the trade
									const singleItem = { ...item, quantity: 1 };

									// reduce the quantity of this item in the trade inventory by 1
									const updatedTrade = filledTradeArray2
										.map((tradeItem) =>
											tradeItem.name === item.name
												? { ...tradeItem, quantity: tradeItem.quantity - 1 }
												: tradeItem,
										)
										.filter((item) => item.quantity > 0); // this removes items with quantity 0

									// check if the item already exists in the player's inventory
									const existingItemIndex = filledInventoryArray.findIndex(
										(inventoryItem) => inventoryItem.name === item.name,
									);

									let updatedInventory;
									if (existingItemIndex !== -1) {
										// item exists, update the quantity
										updatedInventory = filledInventoryArray.map((inventoryItem, index) =>
											index === existingItemIndex
												? { ...inventoryItem, quantity: inventoryItem.quantity + 1 }
												: inventoryItem,
										);
									} else {
										// item does not exist, add it to the inventory
										// fuklter
										updatedInventory = [...filledInventoryArray, singleItem];
									}

									// Filter out empty trade items
									//updatedInventory = filledInventoryArray.filter((item) => item.name !== "");

									print("[DEBUG VENDOR] updatedInventory", updatedInventory);
									// Remove Empty Inventory Items
									updatedInventory = updatedInventory.filter((item) => item.name !== "");
									setData(updatedInventory); // Updating the inventory data state
									settradeData2(updatedTrade); // Updating the trade data state

									if (singleItem.name in itemValues) {
										setTradeValue((prevValue) => prevValue - itemValues[singleItem.name]);
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
		</frame>
	);
};

export default new Hooks(Roact)(Trade);
