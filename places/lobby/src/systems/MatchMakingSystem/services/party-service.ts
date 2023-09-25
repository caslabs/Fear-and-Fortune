import { Players } from "@rbxts/services";
import { Service, OnStart } from "@flamework/core";
import Remotes from "shared/remotes";

type PartyRole = "host" | "member";

class PartyPlayer {
	userId: string;
	role: PartyRole;

	constructor(userId: string, role: PartyRole) {
		this.userId = userId;
		this.role = role;
	}
}

export class Party {
	host: PartyPlayer;
	members: PartyPlayer[];
	maxSize: number;

	constructor(host: PartyPlayer, maxSize = 5) {
		this.host = host;
		this.members = [];
		this.maxSize = maxSize;
	}

	addMember(PartyPlayer: PartyPlayer): void {
		if (this.members.size() < this.maxSize) {
			this.members.push(PartyPlayer);
		} else {
			error("Party is already full");
		}
	}

	removeMember(userId: string): void {
		this.members = this.members.filter((member) => member.userId !== userId);
	}

	changeHost(newHostId: string): void {
		const newHostIndex = this.members.findIndex((member) => member.userId === newHostId);
		if (newHostIndex >= 0) {
			const newHost = this.members[newHostIndex];
			newHost.role = "host";
			this.host.role = "member";
			this.members = this.members.filter((_, index) => index !== newHostIndex);

			const oldHostId = this.host.userId; // Save the old host Id
			this.host = newHost;
			this.members = this.members.filter((member) => member.userId !== oldHostId); // make sure the old host is not in the member list

			print("New Host: ", this.host.userId, " Old Host: ", oldHostId);
		} else {
			error("The new host is not in the party members list");
		}
	}

	kickMember(userId: string, kickedBy: PartyPlayer): void {
		if (kickedBy.role === "host") {
			this.removeMember(userId);
		} else {
			error("Only the host can kick party members");
		}
	}
}

const PartyUpdateEvent = Remotes.Server.Get("PartyUpdate");
const OnPlayerInvitedToPartyInvitationEvent = Remotes.Server.Get("OnPlayerInvitedToParty");
const InvitePlayerToPartyEvent = Remotes.Server.Get("InvitePlayerToParty");
const RespondToPartyInvitationEvent = Remotes.Server.Get("RespondToPartyInvitation");
const RequestQueueEvent = Remotes.Server.Get("RequestQueue");
const EnterQueueEvent = Remotes.Server.Get("EnterQueue");
const ExitQueueEvent = Remotes.Server.Get("ExitQueue");

@Service({})
export default class PartyService implements OnStart {
	private parties: Map<string, Party> = new Map();

	public onStart(): void {
		print("Party Service System Started");

		InvitePlayerToPartyEvent.Connect((player, invitedPlayerId) => {
			const invitedPlayer = Players.GetPlayerByUserId(invitedPlayerId);
			if (invitedPlayer) {
				OnPlayerInvitedToPartyInvitationEvent.SendToPlayer(invitedPlayer, invitedPlayer, player);
			}
		});

		RespondToPartyInvitationEvent.Connect((player, invitedPlayerId, invitingPlayerId, accepted) => {
			print("RespondToPartyInvitationEvent Called");
			const invitedPlayer = Players.GetPlayerByUserId(invitedPlayerId);
			if (invitedPlayer) {
				if (!accepted) {
					return;
				}

				const host = new PartyPlayer(tostring(invitingPlayerId), "host");
				let party = this.getParty(host);
				if (!party) {
					// If the inviting player is not currently a host, create a party for them
					party = new Party(host);
					this.parties.set(host.userId, party);
					print("Party Created");
				}
				const invitee = new PartyPlayer(tostring(invitedPlayerId), "member");
				party.addMember(invitee);
				this.updateParty(host);
			}
		});

		RequestQueueEvent.Connect((player: Player, partyMembers: number[], operation: string) => {
			// convert the array of party member user IDs to an array of Player instances
			const partyMembersInQueue: Player[] = [];
			for (const member of partyMembers) {
				if (member !== undefined) {
					const player = Players.GetPlayerByUserId(member);
					if (player) {
						partyMembersInQueue.push(player);
					}
				} else {
					// Handle the case where userId is not a valid number
					// e.g., throw an error, log a warning, etc.
					error("userId is not a valid number");
				}
			}

			if (operation === "ENTER_QUEUE") {
				EnterQueueEvent.SendToPlayers([...partyMembersInQueue]);
			} else if (operation === "EXIT_QUEUE") {
				ExitQueueEvent.SendToPlayers([...partyMembersInQueue]);
			}
		});

		Players.PlayerRemoving.Connect((player) => {
			this.handlePlayerDisconnect(tostring(player.UserId));
		});
	}

	private getParty(hostPlayer: PartyPlayer): Party | undefined {
		return this.parties.get(hostPlayer.userId);
	}

	public async invitePlayer(hostPlayer: PartyPlayer, invitedPlayer: PartyPlayer): Promise<void> {
		let party = this.getParty(hostPlayer);
		if (!party) {
			// If the inviting PartyPlayer is not currently a host, create a party for them
			party = new Party(hostPlayer);
			this.parties.set(hostPlayer.userId, party);
		}

		party.addMember(invitedPlayer);
		this.updateParty(hostPlayer);
	}

	public isMember(userId: string): boolean {
		let isMember = false;
		this.parties.forEach((party) => {
			if (party.host.userId === userId || party.members.some((member) => member.userId === userId)) {
				isMember = true;
				return;
			}
		});
		return isMember;
	}

	public removePlayerFromParty(playerId: string): void {
		this.parties.forEach((party, hostId) => {
			const initialMembersSize = party.members.size();
			party.removeMember(playerId);

			if (party.host.userId === playerId) {
				// If the party host leaves, assign a new host or destroy the party
				if (party.members.size() > 0) {
					print("HOST LEFT DETECTED! UPDATING NEW HOST");
					party.changeHost(party.members[0].userId);
					this.parties.delete(hostId); // remove the old host from the party list
					this.parties.set(party.host.userId, party); // add the new host to the party list
					this.updateParty(new PartyPlayer(party.host.userId, "host")); // the host has changed, so we update the party
				} else {
					this.parties.delete(hostId); // No need to update as the party is deleted
				}
			} else if (initialMembersSize !== party.members.size()) {
				// If the size of the party members has changed, then a member was removed and we update the party
				this.updateParty(new PartyPlayer(hostId, "host"));
			}
		});
	}

	public handlePlayerDisconnect(playerId: string): void {
		// Handle a PartyPlayer disconnecting or leaving the game
		this.removePlayerFromParty(playerId);
	}

	public acceptInvite(PartyPlayer: PartyPlayer, hostPlayer: PartyPlayer): void {
		const party = this.getParty(hostPlayer);
		if (party) {
			party.addMember(PartyPlayer);
		}
	}

	public isHost(userId: string): boolean {
		const party = this.parties.get(userId);
		if (party) {
			print("Party Found", party.host.userId, userId);

			return party.host.userId === userId && party.members.size() > 0;
		}
		return false;
	}

	public getPartyByMember(memberId: string): Party | undefined {
		let foundParty: Party | undefined;
		this.parties.forEach((party, hostId) => {
			if (party.members.some((member) => member.userId === memberId) || party.host.userId === memberId) {
				foundParty = party;
				print("Party Found", party.host.userId, memberId);
				return;
			}
		});
		return foundParty;
	}

	public getHostPlayer(member: Player): Player | undefined {
		const party = this.getPartyByMember(tostring(member.UserId));
		if (party) {
			const hostId = tonumber(party.host.userId);
			if (hostId !== undefined) {
				return Players.GetPlayerByUserId(hostId);
			} else {
				error("Invalid host ID: " + party.host.userId);
				return undefined;
			}
		}
		return undefined;
	}

	public kickPlayerFromParty(hostPlayer: PartyPlayer, targetPlayer: PartyPlayer): void {
		const party = this.getParty(hostPlayer);
		if (party && hostPlayer.role === "host") {
			party.kickMember(targetPlayer.userId, hostPlayer);
			this.updateParty(hostPlayer);
		} else {
			error("The host PartyPlayer either doesn't exist or isn't the host of a party");
		}
	}

	public getPartyMembers(hostId: string): PartyPlayer[] {
		const party = this.parties.get(hostId);
		if (party) {
			return party.members;
		} else {
			error("No party found for the provided hostId");
		}
	}

	public async updateParty(hostPlayer: PartyPlayer): Promise<void> {
		const party = this.getParty(hostPlayer);
		if (party) {
			// Get Player instances from string user IDs
			const partyMembers: Player[] = [];
			for (const member of party.members) {
				const userIdNumber = tonumber(member.userId);
				if (userIdNumber !== undefined) {
					const player = Players.GetPlayerByUserId(userIdNumber);
					if (player) {
						partyMembers.push(player);
					}
				} else {
					// Handle the case where userId is not a valid number
					// e.g., throw an error, log a warning, etc.
					error("userId is not a valid number");
				}
			}

			const hostId = party.host.userId;

			const hostPlayerIdNumber = tonumber(hostPlayer.userId);
			if (hostPlayerIdNumber !== undefined) {
				const hostPlayerRbx = Players.GetPlayerByUserId(hostPlayerIdNumber);
				print("Sending Update to", [hostPlayerRbx, ...partyMembers]);

				if (hostPlayerRbx) {
					// Fire the PartyUpdate event for the host player and pass the list of party members
					PartyUpdateEvent.SendToPlayers(
						[hostPlayerRbx, ...partyMembers],
						hostId,
						partyMembers.map((member) => member.UserId),
					);
				}
			} else {
				error("userId is not a valid number");
			}
		}
	}
}
