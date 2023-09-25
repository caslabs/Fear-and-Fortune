import { Players, BadgeService } from "@rbxts/services";

export class BadgeManager {
	private static instance: BadgeManager;
	private constructor() {}

	public static getInstance(): BadgeManager {
		if (!BadgeManager.instance) {
			BadgeManager.instance = new BadgeManager();
		}
		return BadgeManager.instance;
	}

	public awardBadgeToPlayers(playerUserIds: number[], badgeId: number): void {
		playerUserIds.forEach((userId) => {
			const player = Players.GetPlayerByUserId(userId);
			if (player && !BadgeService.UserHasBadgeAsync(userId, badgeId)) {
				BadgeService.AwardBadge(userId, badgeId);
			}
		});
	}
}
