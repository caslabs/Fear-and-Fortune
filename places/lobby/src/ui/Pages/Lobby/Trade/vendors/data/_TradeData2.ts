// inventoryData.ts

export interface InventoryItemData {
	name: string;
	color?: Color3;
	desc?: string;
	quantity: number;
}

export const itemValues2: { [key: string]: number } = {
	Amulet: 2,
	Ring: 2,
	Bracelet: 2,
	Trinket: 2,
	// other items here
};

export const tradeInventoryList2: Array<InventoryItemData> = [
	{
		name: "Amulet",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 10,
	},
	{
		name: "Ring",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 10,
	},
	{
		name: "Bracelet",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 10,
	},
	{
		name: "Trinket",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 10,
	},
	// Add more items as needed
];
