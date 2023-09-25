// sanity-manager.ts
import { Players } from "@rbxts/services";

//TODO: We did not use the SanityManager. We used the SanityMechanicService instead.
// So, would a Manager be useful? Or just a Service? to manage states?
export class SanityManager {
	private playerSanity: Map<Player, number>;

	constructor() {
		// Each player has a "sanity" meter that starts at 100 and decreases over time
		this.playerSanity = new Map<Player, number>();
		Players.PlayerAdded.Connect((player) => this.initializePlayer(player));
	}

	initializePlayer(player: Player) {
		this.playerSanity.set(player, 100);
	}

	decreaseSanity(player: Player, amount: number) {
		let currentSanity = this.playerSanity.get(player);
		if (currentSanity !== undefined) {
			currentSanity = math.max(0, currentSanity - amount);
			this.playerSanity.set(player, currentSanity);
			print(`[INFO] Player: ${player.Name}, Sanity: ${currentSanity}`);
		}
	}

	getSanity(player: Player): number {
		// eslint-disable-next-line roblox-ts/lua-truthiness
		return this.playerSanity.get(player) || 100;
	}
}
