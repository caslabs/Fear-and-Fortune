import { OnInit, OnStart, Service } from "@flamework/core";
import { Players, MarketplaceService, DataStoreService } from "@rbxts/services";
import { ProfileSystemMechanic } from "mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service";
import Remotes from "shared/remotes";

// Define the ProcessReceiptInfo interface
interface ProcessReceiptInfo {
	PlayerId: number;
	PlaceIdWherePurchased: number;
	PurchaseId: string;
	ProductId: number;
	CurrencyType: Enum.CurrencyType;
	CurrencySpent: number;
}

const getLeaderboardDataFunc = Remotes.Server.Get("GetDonationData");

interface LeaderboardData {
	name: string;
	donation: number;
}

@Service({})
export default class DonationSystemService implements OnStart, OnInit {
	constructor(private readonly profileService: ProfileSystemMechanic) {}

	private donationLeaderboard = DataStoreService.GetOrderedDataStore("DonationLeaderboard");

	// Define a dictionary with handler functions for each product
	private readonly productHandlers: { [id: number]: (receipt: ProcessReceiptInfo, player: Player) => void } = {
		1585639493: (receipt, player) => {
			const profile = this.profileService.getProfile(player);
			if (profile) {
				// Add 100 to donation value in profile
				profile.Data.donation += 100;
				print(`${player.Name} has donated a total of ₹${profile.Data.donation}`);

				// Update the OrderedDataStore with the new donation amount
				this.donationLeaderboard.SetAsync(tostring(player.UserId), profile.Data.donation);
			}
		},
		// add more handlers here...
	};

	onInit(): void {
		print("DonationSystem Service initialized");
		MarketplaceService.ProcessReceipt = (receipt) => this.processReceipt(receipt);
	}

	onStart(): void {
		print("DonationSystem Service Started");

		getLeaderboardDataFunc.SetCallback(async (player: Player) => {
			// Add print statement for debugging
			print("Fetching leaderboard data...");

			const topDonators = [];
			const dataPages = this.donationLeaderboard.GetSortedAsync(false, 10); // get top 10 players in descending order

			// Get first page
			const data = dataPages.GetCurrentPage();

			for (let i = 0; i < data.size() && i < 10; i++) {
				const donationData = data[i];
				const userId = tonumber(donationData.key);

				// Ensure userId is not undefined before passing to GetNameFromUserIdAsync
				if (userId === undefined) {
					warn(`Unable to convert ${donationData.key} to a number`);
					continue;
				}

				topDonators.push({
					name: await Players.GetNameFromUserIdAsync(userId), // userId is stored as the key
					donation: donationData.value as number, // donation amount is stored as the value
				});
			}

			// Add print statement for debugging
			print("Fetched leaderboard data");
			// eslint-disable-next-line roblox-ts/no-array-pairs
			for (const [player, donation] of pairs(topDonators)) {
				print(`${player + 1}. ${donation.name} - ₹${donation.donation}`);
			}

			return topDonators as LeaderboardData[];
		});
	}

	private processReceipt(receipt: ProcessReceiptInfo): Enum.ProductPurchaseDecision {
		const handler = this.productHandlers[receipt.ProductId];
		if (handler) {
			const player = Players.GetPlayerByUserId(receipt.PlayerId);
			if (player) {
				handler(receipt, player);
				return Enum.ProductPurchaseDecision.PurchaseGranted;
			} else {
				warn("Player not found");
			}
		}
		return Enum.ProductPurchaseDecision.NotProcessedYet;
	}
}
