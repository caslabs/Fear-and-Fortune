// BadgeObserver.ts

import { OnStart, Service } from "@flamework/core";
import { Signals } from "shared/signals";
import BadgeManager from "./BadgeManager";
import { badges } from "./BadgeDefinitions";

/*
This acts as a hub to control all badge signals received from game logic

*/
@Service({
	loadOrder: 99998, // Make sure this loads before other services that might emit signals
})
export default class BadgeObserver implements OnStart {
	constructor(private readonly badgeService: BadgeManager) {}

	public onStart() {
		Signals.playerFirstJoinSignal.Connect((player) => {
			this.badgeService.AwardBadge(player.UserId, badges.first_time_player.id);
			// Assuming you have a method in BadgeService that handles awarding badges
		});

		//TODO: Add more badge triggers

		// You can add listeners for other signals here...
	}
}
