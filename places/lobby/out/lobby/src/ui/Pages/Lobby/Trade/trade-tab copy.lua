-- Compiled with roblox-ts v1.3.3
--[[
	import Roact from "@rbxts/roact";
	import Hooks from "@rbxts/roact-hooks";
	import PurchaseItem from "ui/components/Items/ItemPurchase";
	import { Data, Inventory } from "../index";
	import { AutoScrollingFrame } from "ui/components/Dynamic/ScrollingFrame";
	import { InventoryItemData } from "../data/_inventoryData";
	import InventoryTradeItem from "../Inventory/inventory-component";
	import EmptyInventoryItem from "../Inventory/empty-inventory-component";
	import { Players } from "@rbxts/services";
	import Remotes from "shared/remotes";
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
	function handleTradeItem(
	item: InventoryItemData,
	action: string,
	playerData: Array<InventoryItemData>,
	vendorData: Array<InventoryItemData>,
	) {
	const existingPlayerItemIndex = playerData.findIndex((data) => data.name === item.name);
	const existingVendorItemIndex = vendorData.findIndex((data) => data.name === item.name);
	let newPlayerData = [...playerData];
	const newVendorData = [...vendorData];
	if (existingPlayerItemIndex >= 0 && action === "trade") {
	const existingPlayerItem = newPlayerData[existingPlayerItemIndex];
	existingPlayerItem.quantity -= 1;
	if (existingPlayerItem.quantity <= 0) {
	newPlayerData = newPlayerData.filter((data) => data.name !== item.name);
	}
	}
	if (existingVendorItemIndex >= 0 && action === "trade") {
	const existingVendorItem = newVendorData[existingVendorItemIndex];
	existingVendorItem.quantity += 1;
	} else if (action === "trade") {
	newVendorData.push({ name: item.name, quantity: 1 });
	}
	return [newPlayerData, newVendorData];
	}
	//TODO: Apparently UpdateInventory is a one-to-one event, so we need to create a new event for trading
	//TODO: is there a better way? Had to use Global as setData was not updating the data variable
	let full_inventory = [] as InventoryItemData[];
	const temp_trade_inventory = [] as InventoryItemData[];
	const Trade: Hooks.FC<InventoryProps> = (props, { useState, useEffect }) => {
	const [data, setData] = useState<Array<InventoryItemData>>([]);
	const [tradeData, settradeData] = useState<Array<InventoryItemData>>([]); // New state for backpack data
	const [selectedTab, setSelectedTab] = useState<"inventory" | "vendor1" | "vendor2">("inventory");
	// Initialize state for vendor2
	const [vendor2Data, setVendor2Data] = useState<Array<InventoryItemData>>([]);
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
	if (action === "add") {
	existingItem.quantity += quantity;
	} else if (action === "remove") {
	if (existingItem.quantity > 1) {
	existingItem.quantity -= quantity;
	} else {
	newData = newData.filter((data) => data.name !== item);
	}
	}
	} else if (action === "add") {
	newData.push({ name: item, quantity });
	}
	print("[DEBUG] New inventory data:", newData);
	full_inventory = newData;
	return full_inventory;
	});
	}
	});
	return () => connection1.Disconnect();
	}, []);
	let filledInventoryArray = [...data];
	for (let i = data.size(); i < 50; i++) {
	filledInventoryArray.push(emptyInventoryItem);
	}
	let filledTradeArray = [...tradeData];
	for (let i = tradeData.size(); i < 50; i++) {
	filledTradeArray.push(emptyInventoryItem);
	}
	filledTradeArray = filledTradeArray.sort(sortInventory);
	filledInventoryArray = filledInventoryArray.sort(sortInventory);
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
	<textbutton
	Key={"InventoryTabButton"}
	Text={"Trade"}
	TextSize={13}
	Font={"GothamBold"}
	Size={UDim2.fromScale(1, 0.1)}
	TextColor3={Color3.fromRGB(200, 200, 200)}
	Event={{
	MouseButton1Click: () => setSelectedTab("inventory"),
	}}
	BackgroundColor3={
	selectedTab === "inventory" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
	}
	/>
	<textlabel
	Key={"VendorHeader"}
	Text={"Vendors"}
	Font={"GothamBold"}
	TextSize={13}
	BackgroundTransparency={1}
	Size={UDim2.fromScale(1, 0.05)}
	TextColor3={Color3.fromRGB(200, 200, 200)}
	Position={UDim2.fromScale(0, 0.15)}
	BackgroundColor3={Color3.fromRGB(45, 45, 45)}
	/>
	<textbutton
	Key={"BackpackTabButton"}
	Text={"Pocketcat"}
	Font={"GothamBold"}
	TextSize={13}
	Size={UDim2.fromScale(1, 0.1)}
	TextColor3={Color3.fromRGB(200, 200, 200)}
	Position={UDim2.fromScale(0, 0.21)}
	Event={{
	MouseButton1Click: () => setSelectedTab("vendor1"),
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
	Position={UDim2.fromScale(0, 0.33)}
	Event={{
	MouseButton1Click: () => setSelectedTab("vendor2"),
	}}
	BackgroundColor3={
	selectedTab === "vendor2" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
	}
	/>
	<textbutton
	Key={"SellButton"}
	Text={"Sell"}
	Font={"GothamBold"}
	TextSize={13}
	Size={UDim2.fromScale(1, 0.1)}
	TextColor3={Color3.fromRGB(200, 200, 200)}
	Position={UDim2.fromScale(0, 1)}
	AnchorPoint={new Vector2(0, 1)}
	Event={{
	MouseButton1Click: () => {
	print("Selling items");
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
	Text={`inventory (${data.size()}/${selectedTab === "inventory" ? "50" : "50"})`}
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
	<scrollingframe
	Size={UDim2.fromScale(0.77, 0.38)}
	Position={UDim2.fromScale(0, 0.6)}
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
	item.name ? (
	<InventoryTradeItem
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
	<scrollingframe
	Size={UDim2.fromScale(0.77, 0.38)}
	Position={UDim2.fromScale(0, 0.6)}
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
	{filledInventoryArray.map((item, index) =>
	item.name ? (
	<InventoryTradeItem
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
	<scrollingframe
	Size={UDim2.fromScale(0.77, 0.38)}
	Position={UDim2.fromScale(0, 0.6)}
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
	{filledInventoryArray.map((item, index) =>
	item.name ? (
	<InventoryTradeItem
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
	<scrollingframe
	Size={UDim2.fromScale(0.77, 0.5)}
	Position={UDim2.fromScale(0, 0.035)}
	BorderSizePixel={0}
	BackgroundTransparency={1}
	ScrollBarThickness={6}
	>
	<uigridlayout
	CellPadding={UDim2.fromOffset(6, 6)}
	CellSize={UDim2.fromScale(0.15, 0.09)}
	SortOrder={Enum.SortOrder.LayoutOrder}
	/>
	{filledTradeArray.map((item, index) =>
	// eslint-disable-next-line roblox-ts/lua-truthiness
	item.name ? (
	<InventoryTradeItem
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
	</frame>
	);
	};
	export default new Hooks(Roact)(Trade);
]]
return nil
