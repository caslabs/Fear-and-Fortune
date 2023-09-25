import { OnStart, Service } from "@flamework/core";
import { Players, BadgeService } from "@rbxts/services";

/*
Badge Manager manages badge award to player

*/
@Service({
	loadOrder: 0,
})
export default class BadgeManagerService implements OnStart {
	public onStart() {
		print("BadgeManagerService Service Started");
	}

	/**
	 * Awards a badge to the player.
	 * @param playerID Player's ID.
	 * @param badgeID Badge's ID.
	 * @returns Promise which resolves if the badge was awarded, rejects otherwise.
	 */
	public AwardBadge(playerID: number, badgeID: number) {
		BadgeService.AwardBadge(playerID, badgeID);
	}

	public async awardBadge(playerID: number, badgeID: number): Promise<void> {
		// eslint-disable-next-line roblox-ts/lua-truthiness
		if (await this.hasBadge(playerID, badgeID)) {
			error(`Player ${playerID} already has badge ${badgeID}`);
		}
		BadgeService.AwardBadge(playerID, badgeID);
	}

	/**
	 * Checks if the player has a specific badge.
	 * @param playerID Player's ID.
	 * @param badgeID Badge's ID.
	 * @returns Promise which resolves to a boolean indicating if the player has the badge.
	 */
	public async hasBadge(playerID: number, badgeID: number): Promise<boolean> {
		return BadgeService.UserHasBadgeAsync(playerID, badgeID);
	}
}
