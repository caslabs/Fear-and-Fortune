// inventoryData.ts

export interface InventoryItemData {
	name: string;
	color?: Color3;
	desc?: string;
}

export const inventoryList: Array<InventoryItemData> = [
	{
		name: "Eldritch Runestone",
		color: Color3.fromRGB(224, 237, 227),
		desc: "A mysterious stone with enigmatic inscriptions. Origin unknown.",
	},
	// Add more items as needed
];
