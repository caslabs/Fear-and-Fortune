import { OnStart, Service } from "@flamework/core";
import { Players, TeleportService, MessagingService } from "@rbxts/services";
import Remotes from "shared/remotes";
import { QueueState } from "shared/signals";
import { Settings, PlayFabClient, PlayFabMultiplayer, PlayFabServer } from "@rbxts/playfab";
import PlayFabSessionService from "./session-service";
import PartyService from "./party-service";

interface PlayerData {
	userId: number;
	username: string;
	// Add more fields as needed.
}

interface MatchFoundMessage {
	type: string;
	matchId: string;
	reservedServerCode: string;
	userIds: string[]; // Add this line
}

export interface EntityKey {
	/** Unique ID of the entity. */
	Id: string;
	/** Entity type. See https://docs.microsoft.com/gaming/playfab/features/data/entities/available-built-in-entity-types */
	Type?: string;
}

function tableToString(obj: Record<string, unknown>): string {
	let result = "{ ";
	for (const [key, val] of pairs(obj)) {
		result = result + key + " : " + tostring(val) + ", ";
	}
	return result + " }";
}

interface IPlayerSession {
	sessionTicket: string;
	playFabId: string;
	entityToken: string;
	entityKey: {
		Id: string;
		Type: string;
	};
}

const ExecuteMatchEvent = Remotes.Server.Get("ExecuteMatch");
const UpdatePlayerCountEvent = Remotes.Server.Get("UpdatePlayerCount");
const QueueStateChangeEvent = Remotes.Server.Get("QueueStateChange");
const UpdateQueueMembers = Remotes.Server.Get("UpdateQueueMembers");

@Service({})
export default class MatchMakingService implements OnStart {
	public queuedPlayers: Map<number, PlayerData> = new Map();
	public matchToServerMap: Map<string, string> = new Map(); // Added new Map to store MatchId to reservedServerCode mapping

	//PROTOTPE: Playfab matchmaking
	public queuedPlayersPLAYFAB: Map<number, PlayerData> = new Map();
	public playerMatchmakingTickets: Map<Player, string> = new Map();
	public memberMatchmakingTickets: Map<Player, string> = new Map();
	private queueName = "Demo_Queue";
	private matchmakingTimeout = 120;
	private matchmakingPollInterval = 6;

	constructor(private readonly sessionService: PlayFabSessionService, private readonly partyService: PartyService) {}

	public onStart() {
		print("MatchMaking Service Started");
		const JoinMatchEvent = Remotes.Server.Get("JoinMatch").Connect((player: Player) => {
			//this.addPlayerToQueue(player);
			//this.addPlayerToQueue(player);
			this.handleJoinQueueRequest(player);
		});

		const LeaveMatchEvent = Remotes.Server.Get("LeaveMatch").Connect((player: Player) => {
			this.handlePlayerRemoving(player);
		});

		const TeleportMatchEvent = Remotes.Server.Get("TeleportMatch").Connect((player: Player) => {
			//this.startMatch();
		});

		try {
			MessagingService.SubscribeAsync("MatchMakingChannel", async (message: unknown) => {
				print("[MATCH MAKING] Received message: ", message);
				print("[MATCH MAKING] Received message as string: ", tableToString(message as Record<string, unknown>));
				const messageData = (message as { Data: unknown }).Data;
				print("[MATCH MAKING] Message Data: ", messageData);
				print("[MATCH MAKING] Message Data as string: ", tableToString(messageData as Record<string, unknown>));
				const castedMessage = messageData as MatchFoundMessage;

				if (castedMessage.type === "MATCH_FOUND") {
					this.matchToServerMap.set(castedMessage.matchId, castedMessage.reservedServerCode);

					// When a match is found, get the corresponding players and teleport them
					// When a match is found, get the corresponding players and teleport them
					const players: Player[] = [];

					for (const userId of castedMessage.userIds) {
						const numUserId = tonumber(userId);
						if (numUserId !== undefined) {
							const player = Players.GetPlayerByUserId(numUserId);
							if (player !== undefined) {
								players.push(player);
							}
						}
					}
					if (players.size() > 0) {
						this.teleportPlayerToMatch(players, castedMessage.matchId);
					}
				} else {
					print("none BRUH");
				}
			});
		} catch {
			print("[MATCH MAKING] Error subscribing to MessagingService: ");
		}

		Players.PlayerAdded.Connect((player: Player) => {
			print("[MATCH MAKING] Player added: ", player.Name);
		});

		this.driveMatchmakingLoop();
	}

	private async handleJoinQueueRequest(player: Player) {
		const playerSession = this.sessionService.getPlayerSession(player);
		print("[MATCH MAKING] Player in handleJoin", player.Name);
		//If host, then have MembersToMatchWith

		// eslint-disable-next-line roblox-ts/lua-truthiness
		if (this.partyService.isHost(tostring(player.UserId))) {
			print("[HOST] Player is host");
			// Assuming you have a method that identifies if the player is the host.
			// Create a ticket specifically for the host
			// Assuming your match-making service has a reference to your party service.
			const partyMembers = this.partyService.getPartyMembers(tostring(player.UserId));
			for (const member of partyMembers) {
				print("[HOST] member: ", member.userId);
			}
			// Loop over each party member to get their player session and entity key
			const memberEntityKeys: PlayFabMultiplayerModels.EntityKey[] = [];
			for (const member of partyMembers) {
				const userIdNumber = tonumber(member.userId);
				if (userIdNumber !== undefined) {
					const memberPlayer = Players.GetPlayerByUserId(userIdNumber);
					if (memberPlayer) {
						const playerSession = await this.sessionService.getPlayerSession(memberPlayer);
						if (playerSession) {
							// Make sure the entityKey has a Type
							memberEntityKeys.push(playerSession.entityKey);
						} else {
							error("PlayerSession could not be retrieved or the entityKey does not have a Type");
						}
					} else {
						error("userId does not correspond to a valid Player");
					}
				} else {
					error("userId is not a valid number");
				}
			}

			print("[HOST] memberEntityKeys: ", memberEntityKeys);
			// Iterate over memberEntityKeys
			for (const memberEntityKey of memberEntityKeys) {
				print("[HOST] memberEntityKey: ", memberEntityKey.Id, memberEntityKey.Type);
			}

			const ticket = PlayFabMultiplayer.CreateMatchmakingTicket(playerSession.entityToken, {
				Creator: {
					Entity: playerSession.entityKey,
				},
				GiveUpAfterSeconds: this.matchmakingTimeout,
				QueueName: this.queueName, // You can change queueName or any other parameter here
				MembersToMatchWith: [...(memberEntityKeys as PlayFabMultiplayerModels.EntityKey[])], // Add the members to match with here
			}).then((ticket) => {
				print("[HOST] ticket: ", ticket);

				// The line should be here
				print("ABOUT OT ENTER TICKET");
				print("[HOST] ticket: ", ticket);
				this.playerMatchmakingTickets.set(player, ticket.TicketId);
				print("HOST ENTERED TICKET");
			});
		} else if (this.partyService.isMember(tostring(player.UserId))) {
			const hostPlayer = this.partyService.getHostPlayer(player); // You need a method to get the host Player of a given member
			if (!hostPlayer) {
				error("Error getting host player");
			}
			const ticketId = this.playerMatchmakingTickets.get(hostPlayer);
			// eslint-disable-next-line roblox-ts/lua-truthiness
			if (ticketId) {
				PlayFabMultiplayer.JoinMatchmakingTicket(playerSession.entityToken, {
					TicketId: ticketId,
					QueueName: this.queueName,
					Member: {
						Entity: playerSession.entityKey,
					},
				});
				this.memberMatchmakingTickets.set(player, ticketId);
			}

			print("MEMBER JOINED TICKET");
		} else {
			// Solo queue
			const ticket = PlayFabMultiplayer.CreateMatchmakingTicket(playerSession.entityToken, {
				Creator: {
					Entity: playerSession.entityKey,
				},
				GiveUpAfterSeconds: this.matchmakingTimeout,
				QueueName: this.queueName,
			});

			this.playerMatchmakingTickets.set(player, (await ticket).TicketId);
		}
		return true;
	}

	private handlePlayerRemoving(player: Player) {
		if (!this.playerMatchmakingTickets.has(player)) {
			return; // No outstanding tickets
		}

		const playerSession = this.sessionService.getPlayerSession(player);
		PlayFabMultiplayer.CancelAllMatchmakingTicketsForPlayer(playerSession.entityToken, {
			QueueName: this.queueName,
			Entity: playerSession.entityKey,
		});

		this.playerMatchmakingTickets.delete(player);
	}

	private async driveMatchmakingLoop() {
		// Map to hold matched players grouped by matchId
		const matchedPlayersMap = new Map<string, Player[]>();

		if (this.playerMatchmakingTickets.size() > 0) {
			for (const [player, ticketId] of this.playerMatchmakingTickets) {
				const playerSession = this.sessionService.getPlayerSession(player);
				const ticket = await PlayFabMultiplayer.GetMatchmakingTicket(playerSession.entityToken, {
					TicketId: ticketId,
					QueueName: this.queueName,
					EscapeObject: false,
				});
				print("Ticket", ticket);

				if (ticket.Status === "Matched" && ticket.MatchId) {
					// We found a match!
					if (!matchedPlayersMap.has(ticket.MatchId)) {
						matchedPlayersMap.set(ticket.MatchId, []); // Initialize the matchId key with an empty array if it does not exist
					}
					// Get the player list and check if it is defined
					const players = matchedPlayersMap.get(ticket.MatchId);
					if (players) {
						players.push(player); // Add the player to the array for the matched matchId
					}
				}
			}
		}

		if (this.memberMatchmakingTickets.size() > 0) {
			for (const [player, ticketId] of this.memberMatchmakingTickets) {
				const playerSession = this.sessionService.getPlayerSession(player);
				const ticket = await PlayFabMultiplayer.GetMatchmakingTicket(playerSession.entityToken, {
					TicketId: ticketId,
					QueueName: this.queueName,
					EscapeObject: false,
				});
				print("Ticket", ticket);

				if (ticket.Status === "Matched" && ticket.MatchId) {
					// We found a match!
					if (!matchedPlayersMap.has(ticket.MatchId)) {
						matchedPlayersMap.set(ticket.MatchId, []); // Initialize the matchId key with an empty array if it does not exist
					}
					// Get the player list and check if it is defined
					const players = matchedPlayersMap.get(ticket.MatchId);
					if (players) {
						players.push(player); // Add the player to the array for the matched matchId
					}
				}
			}
		} else {
			print("No tickets to process");
		}

		// Iterate over the matchedPlayersMap and handle each unique match
		for (const [matchId, players] of matchedPlayersMap) {
			this.handleFoundMatch(players, matchId);
		}

		task.delay(this.matchmakingPollInterval, () => {
			this.driveMatchmakingLoop();
		});
	}

	private handleFoundMatch(players: Player[], matchId: string) {
		const placeId = 13885123622; // Replace with your destination place id
		const [reservedServerCode, reservedPlaceID] = TeleportService.ReserveServer(placeId);
		const message = {
			type: "MATCH_FOUND",
			matchId: matchId,
			reservedServerCode: reservedServerCode,
			// Include all user Ids in the message
			userIds: players.map((player) => player.UserId),
		};

		print("[MATCH MAKING HANDLE] Publishing message: ", message);
		MessagingService.PublishAsync("MatchMakingChannel", message);
		print("[MATCH MAKING HANDLE] Message published successfully");
		print("[MATCH MAKING HANDLE] matchId: ", matchId, " reservedServerCode: ", reservedServerCode); // Logging added here
	}

	private teleportPlayerToMatch(players: Player[], matchId: string) {
		const reservedServerCode = this.matchToServerMap.get(matchId);

		// eslint-disable-next-line roblox-ts/lua-truthiness
		if (reservedServerCode) {
			const placeId = 13885123622; // Replace with your destination place id

			const validPlayers = players.filter((player) => player !== undefined);

			if (validPlayers.size() > 0) {
				validPlayers.forEach((player) => {
					ExecuteMatchEvent.SendToPlayer(player, player);
				});
				TeleportService.TeleportToPrivateServer(placeId, reservedServerCode, validPlayers);
			} else {
				print("[MATCH MAKING] No valid players found for teleportation in match: ", matchId);
			}
		} else {
			print("[MATCH MAKING] No server code found for match: ", matchId);
		}
	}

	public startGame(player: Player) {
		if (this.queuedPlayers.has(player.UserId)) {
			this.updateQueueState(QueueState.Searching);
			// Starting the game simulation like countdown and finding a server can be implemented here.
		} else {
			warn(`Player ${player.Name} tried to start the game but is not in the queue.`);
		}
	}

	public addPlayerToQueue(player: Player) {
		const playerData = this.getPlayerData(player);
		this.queuedPlayers.set(player.UserId, playerData);
		// Notify the client about the updated player count.
		UpdatePlayerCountEvent.SendToAllPlayers(this.queuedPlayers.size());
		this.syncMembers();
	}

	public removePlayerFromQueue(player: Player) {
		this.queuedPlayers.delete(player.UserId);
		// Notify the client about the updated player count.
		UpdatePlayerCountEvent.SendToAllPlayers(this.queuedPlayers.size());
		this.syncMembers();
	}

	public getPlayerData(player: Player): PlayerData {
		return {
			userId: player.UserId,
			username: player.Name,
			// Add more data as needed.
		};
	}

	public updateQueueState(newState: QueueState) {
		for (const [userId, playerData] of this.queuedPlayers) {
			const player = Players.GetPlayerByUserId(userId);
			if (player) {
				QueueStateChangeEvent.SendToPlayer(player, newState);
			}
		}
	}

	public getQueuedPlayersAsPlayerArray(): Player[] {
		const playerArray: Player[] = [];

		for (const [userId, playerData] of this.queuedPlayers) {
			const player = Players.GetPlayerByUserId(userId);
			if (player) {
				playerArray.push(player);
			}
		}

		return playerArray;
	}

	//TODO: this would just execute TP for all players (see the for loop?)

	private syncMembers() {
		UpdateQueueMembers.SendToAllPlayers(this.getQueuedPlayersAsPlayerArray());
	}
}
