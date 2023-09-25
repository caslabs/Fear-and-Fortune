// inventoryData.ts

export interface InventoryItemData {
	name: string;
	color?: Color3;
	desc?: string;
	quantity: number;
}

export const itemValues: { [key: string]: number } = {
	HumanMeat: 3,
	StrangeMeat: 3,
	Meat: 3,
	DarkMeat: 3,
	CookedMeat: 3,
	HumanHeart: 3,
	// other items here
};

export const tradeInventoryList: Array<InventoryItemData> = [
	{
		name: "HumanMeat",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 10,
	},
	{
		name: "StrangeMeat",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 10,
	},
	{
		name: "Meat",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 10,
	},
	{
		name: "DarkMeat",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 10,
	},
	{
		name: "CookedMeat",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 10,
	},
	// Add more items as needed
];
