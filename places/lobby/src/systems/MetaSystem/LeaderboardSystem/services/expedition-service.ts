import { OnInit, OnStart, Service } from "@flamework/core";
import { Players, MarketplaceService, DataStoreService } from "@rbxts/services";
import { ProfileSystemMechanic } from "mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service";
import Remotes from "shared/remotes";

const getExpeditionDataFunc = Remotes.Server.Get("GetExpeditionData");

interface ExpeditionData {
	name: string;
	expedition: number;
}

@Service({})
export default class ExpeditionSystemService implements OnStart, OnInit {
	constructor(private readonly profileService: ProfileSystemMechanic) {}

	private ExpeditionExpedition = DataStoreService.GetOrderedDataStore("ExpeditionLeaderboard");

	onInit(): void {
		print("ExpeditionSystem Service initialized");
	}

	onStart(): void {
		print("ExpeditionSystem Service Started");

		getExpeditionDataFunc.SetCallback(async (player: Player) => {
			// Add print statement for debugging
			print("Fetching Expedition data...");

			const topDonators = [];
			const dataPages = this.ExpeditionExpedition.GetSortedAsync(false, 10); // get top 10 players in descending order

			// Get first page
			const data = dataPages.GetCurrentPage();

			for (let i = 0; i < data.size() && i < 10; i++) {
				const ExpeditionData = data[i];
				const userId = tonumber(ExpeditionData.key);

				// Ensure userId is not undefined before passing to GetNameFromUserIdAsync
				if (userId === undefined) {
					warn(`Unable to convert ${ExpeditionData.key} to a number`);
					continue;
				}

				topDonators.push({
					name: await Players.GetNameFromUserIdAsync(userId), // userId is stored as the key
					expedition: ExpeditionData.value as number, // Expedition amount is stored as the value
				});
			}

			// Add print statement for debugging
			print("Fetched Expedition data");
			// eslint-disable-next-line roblox-ts/no-array-pairs
			for (const [player, Expedition] of pairs(topDonators)) {
				print(`${player + 1}. ${Expedition.name} - ₹${Expedition.expedition}`);
			}

			return topDonators as ExpeditionData[];
		});
	}
}
