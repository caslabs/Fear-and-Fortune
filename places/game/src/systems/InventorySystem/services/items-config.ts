interface CooldownBehavior {
	duration: number;
	lastSwingTime: Map<Player, number>;
}

export type ToolConfig = {
	id: string;
	name: string;
	model_id: string;
	tool: string;
	actions: Array<{
		type: string;
		functionId: string;
		cooldownBehavior?: CooldownBehavior;
		collisions?: Array<{ type: string; soundId: string[]; amount: number }>;
		animationId: string;
		soundId: string;
	}>;
};

export interface ToolActionContext {
	lastActionTime: Map<Player, number>;
	player: Player;
	action: ToolConfig["actions"][0]; // This directly refers to the action type in ToolConfig
	tool: Tool;
}

// Prototype
/*
My philosophy is that everything you can pick up can be a tool

Known types
- Ritual Table (Portable Gear on Hand)
- Crafting Table (Portable Gear on Hand)
- Tools
-  - Weapons
-   - Melee
-   - Ranged
- - Resource Gathering Tools
-   - Hatchet
-   - Pickaxe
*/
export const ToolDataConfig: Array<ToolConfig> = [
	{
		id: "axe_001",
		name: "AxeToolTrigger", //This complies with Inventory System naming convention
		model_id: "Axe",
		tool: "Axe",
		actions: [
			{
				type: "swing",
				functionId: "swing",
				// Modify these base on class
				cooldownBehavior: {
					duration: 1,
					lastSwingTime: new Map<Player, number>(),
				},
				collisions: [
					{
						type: "IronWoodTree",
						soundId: ["159798328"],
						amount: 3,
					},
					{
						type: "WoodTree",
						soundId: ["159798328"],
						amount: 3,
					},
				],
				animationId: "567480700O",
				soundId: "some_sound_id",
			},
		],
	},
];

export type ToolFunction = (context: ToolActionContext) => void;

export class CooldownManager {
	isActionOnCooldown(action: ToolConfig["actions"][0], player: Player): boolean {
		const cooldownBehavior = action.cooldownBehavior;
		if (!cooldownBehavior) return false;

		const lastSwing = cooldownBehavior.lastSwingTime.get(player);
		// eslint-disable-next-line roblox-ts/lua-truthiness
		if (!lastSwing) return false;

		const currentTime = tick();
		return currentTime - lastSwing < cooldownBehavior.duration;
	}

	updateCooldown(action: ToolConfig["actions"][0], player: Player): void {
		if (action.cooldownBehavior) {
			action.cooldownBehavior.lastSwingTime.set(player, tick());
		}
	}
}
