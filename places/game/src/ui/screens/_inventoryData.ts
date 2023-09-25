// inventoryData.ts

export interface InventoryItemData {
	name: string;
	color?: Color3;
	desc?: string;
	quantity: number;
	tool?: Tool;
}

export const inventoryList: Array<InventoryItemData> = [
	{
		name: "Eldritch Runestone",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
		quantity: 0,
	},
	// Add more items as needed
];
