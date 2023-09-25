import { OnStart, Service } from "@flamework/core";
import { Players, StarterPlayer, UserInputService } from "@rbxts/services";
import Remotes from "shared/remotes";
import MatchMakingService from "systems/MatchMakingSystem/services/match-making-service";

const ExecuteMatchEvent = Remotes.Server.Get("ExecuteMatch");
const RequestToCancelMatchEvent = Remotes.Server.Get("RequestToCancelMatch");

export enum QueueState {
	Idle,
	Searching,
	ServerFound,
	EmbarkFailed,
}

@Service({
	loadOrder: 0,
})
export default class EventFlowService implements OnStart {
	constructor(private readonly matchMakingService: MatchMakingService) {}
	public onStart() {
		Players.PlayerAdded.Connect(async (player) => {
			player.Chatted.Connect((message) => this.onPlayerChat(player, message));
		});

		print("EventFlowSystem Service Started");
	}

	private onPlayerChat(player: Player, message: string) {
		print("onPlayerChat", player, message);
		//TODO: DEV ONLY CAN START THE GAME
		if (player.UserId === 11697914) {
			if (message === "/start game") {
				//TODO: Sync
				for (const [userId, playerData] of this.matchMakingService.queuedPlayers) {
					const player = Players.GetPlayerByUserId(userId);
					if (player) {
						ExecuteMatchEvent.SendToPlayer(player, player);
					}
				}
				//ExecuteMatchEvent.SendToPlayers([player], player);
				//this.matchMakingService.updateQueueState(QueueState.ServerFound); // Update queue state first
			} else if (message === "/cancel game") {
				for (const [userId, playerData] of this.matchMakingService.queuedPlayers) {
					const player = Players.GetPlayerByUserId(userId);
					if (player) {
						RequestToCancelMatchEvent.SendToPlayer(player, player);
					}
				}
			}
		} else {
			print("Not a dev! Sorry!");
		}
	}
}
