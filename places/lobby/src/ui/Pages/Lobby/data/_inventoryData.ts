// inventoryData.ts

export interface InventoryItemData {
	name: string;
	color?: Color3;
	desc?: string;
	quantity: number;
}

export const inventoryList: Array<InventoryItemData> = [
	{
		name: "HumanHeart",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 1,
	},
	// Add more items as needed
];
