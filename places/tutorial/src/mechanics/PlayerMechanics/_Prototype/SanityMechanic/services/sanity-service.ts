// sanity-manager.ts
import { Players } from "@rbxts/services";
import { Service } from "@flamework/core";
import { OnStart } from "@flamework/core";
import Remotes from "shared/remotes";

const DecreaseSanityEvent = Remotes.Server.Get("DecreaseSanityEvent");
const UpdateSanityEvent = Remotes.Server.Get("UpdateSanityEvent");

@Service({})
export class SanityMechanicService implements OnStart {
	private playerSanity: Map<Player, number>;

	constructor() {
		this.playerSanity = new Map<Player, number>();
	}

	onStart() {
		print("SanityMechanic Service started");
		Players.PlayerAdded.Connect((player) => this.initializePlayer(player));

		// Decrease Sanity Event will trigger the decreaseSanity which will update the player's sanity
		DecreaseSanityEvent.Connect((player: Player) => {
			this.decreaseSanity(player, 10);
		});
	}

	initializePlayer(player: Player) {
		this.playerSanity.set(player, 100);
	}

	decreaseSanity(player: Player, amount: number) {
		let currentSanity = this.playerSanity.get(player);
		if (currentSanity !== undefined) {
			currentSanity = math.max(0, currentSanity - amount);
			this.playerSanity.set(player, currentSanity);
			print(`Player: ${player.Name}, Sanity: ${currentSanity}`);
			UpdateSanityEvent.SendToPlayer(player, player, currentSanity);
		}
	}

	getSanity(player: Player): number {
		// eslint-disable-next-line roblox-ts/lua-truthiness
		return this.playerSanity.get(player) || 100;
	}
}
