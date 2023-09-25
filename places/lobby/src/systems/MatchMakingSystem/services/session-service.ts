import { Players } from "@rbxts/services";
import { Settings, PlayFabClient } from "@rbxts/playfab";
import { Service, OnStart } from "@flamework/core";

interface IPlayerSession {
	sessionTicket: string;
	playFabId: string;
	entityToken: string;
	entityKey: {
		Id: string;
		Type: string;
	};
}

@Service({})
export default class PlayFabSessionService implements OnStart {
	private playerSessions = new Map<Player, IPlayerSession>();

	public onStart(): void {
		Players.PlayerAdded.Connect((player) => this.handlePlayerJoin(player));
		Players.PlayerRemoving.Connect((player) => {
			wait(5); // Give other services time to clean up using the players session
			this.playerSessions.delete(player);
		});
	}

	public getPlayerSession(player: Player): IPlayerSession {
		const session = this.playerSessions.get(player);
		if (!session) {
			error("Player doesn't have a session yet!");
		}
		return session!;
	}

	private handlePlayerJoin(player: Player): void {
		Settings.titleId = "D1B10";
		PlayFabClient.LoginWithCustomID({
			CustomId: tostring(player.UserId),
			CreateAccount: true, // Create an account if one doesn't exist
		})
			.then((response) => {
				const playfabId = response.PlayFabId!;
				const sessionTicket = response.SessionTicket!;
				const entityId = response.EntityToken!.Entity!.Id!;
				const entityType = response.EntityToken!.Entity!.Type!;
				const entityToken = response.EntityToken!.EntityToken!;

				this.playerSessions.set(player, {
					playFabId: playfabId,
					sessionTicket: sessionTicket,
					entityToken: entityToken,
					entityKey: {
						Id: entityId,
						Type: entityType,
					},
				});

				print(
					"----------------------\nPlayer " +
						player.Name +
						" authenticated with PlayFab:" +
						"\n    PlayFab ID: " +
						playfabId +
						"\n    Entity ID: " +
						entityId +
						"\n    Entity Type: " +
						entityType +
						"\n    Session Ticket: " +
						sessionTicket +
						"\n    Entity Token: " +
						entityToken +
						"\n----------------------" +
						"\n",
				);
			})
			.catch(() => {
				warn("Something went wrong!");
			});
	}
}
