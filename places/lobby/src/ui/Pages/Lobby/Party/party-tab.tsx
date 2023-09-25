import Roact from "@rbxts/roact";
import { Players, StarterGui } from "@rbxts/services";
import Hooks from "@rbxts/roact-hooks";
import { Data } from "../index";
import Remotes from "shared/remotes";
import PlayerItem from "./playerItem";

interface PartyProps {
	data: Array<Data>;
	visible: string;
}

type PartyRole = "host" | "member";

enum PlayerClass {
	Mountaineer,
	Soldier,
	Engineer,
	Doctor,
	Scholar,
	Cameraman,
}

class PartyPlayer {
	userId: string;
	role: PartyRole;

	constructor(userId: string, role: PartyRole) {
		this.userId = userId;
		this.role = role;
	}
}

function getPlayerfromUserId(userId: string): Player | undefined {
	const userIdNumber = tonumber(userId);

	if (userIdNumber !== undefined) {
		return Players.GetPlayerByUserId(userIdNumber) || undefined;
	} else {
		return undefined;
	}
}

function PlayerClassToString(playerClass: PlayerClass) {
	switch (playerClass) {
		case PlayerClass.Mountaineer:
			return "Mountaineer";
		case PlayerClass.Soldier:
			return "Soldier";
		case PlayerClass.Engineer:
			return "Engineer";
		case PlayerClass.Doctor:
			return "Doctor";
		case PlayerClass.Scholar:
			return "Scholar";
		case PlayerClass.Cameraman:
			return "Cameraman";
	}
}

const player = Players.LocalPlayer;
const PartyUpdateEvent = Remotes.Client.Get("PartyUpdate");
const InvitePlayerToPartyEvent = Remotes.Client.Get("InvitePlayerToParty");
const OnPlayerInvitedToPartyEvent = Remotes.Client.Get("OnPlayerInvitedToParty");
const RespondToPartyInvitationEvent = Remotes.Client.Get("RespondToPartyInvitation");
const SendPartyMemberofClassEvent = Remotes.Client.Get("SendPartyMemberofClassEvent");
const PlayerProfessionUpdateEvent = Remotes.Client.Get("PlayerProfessionUpdate");
OnPlayerInvitedToPartyEvent.Connect((invitedPlayer: Player, invitingPlayer: Player) => {
	print(`Received invitation from ${invitingPlayer.Name}`);

	const responseFunc = new Instance("BindableFunction");
	responseFunc.OnInvoke = (choice: string) => {
		RespondToPartyInvitationEvent.SendToServer(invitedPlayer.UserId, invitingPlayer.UserId, choice === "Accept");
		print("Calling RespondToPartyInvitationEvent");
	};

	StarterGui.SetCore("SendNotification", {
		Title: "Party Invitation",
		Text: `${invitingPlayer.Name} has sent an invite!`,
		Button1: "Accept",
		Button2: "Decline",
		Duration: 10,
		Callback: responseFunc,
	});
});

const Party: Hooks.FC<PartyProps> = (props, { useState, useEffect }) => {
	const [invite, setInvite] = useState("Invite");
	const [partyMembers, setPartyMembers] = useState<Array<PartyPlayer>>([]);
	const [partySize, setPartySize] = useState(1);
	const [players, setPlayers] = useState(() => Players.GetPlayers().filter((p) => p !== Players.LocalPlayer));
	const [playerProfession, setPlayerProfession] = useState("Mountaineer");
	const [playerProfessions, setPlayerProfessions] = useState<Map<string, string>>(new Map<string, string>());

	const [partyName, setPartyName] = useState("The Nameless Party");
	const textboxRef = Roact.createRef<TextBox>();
	const [isHost, setIsHost] = useState(true);

	useEffect(() => {
		const onPlayerAddedConnection = Players.PlayerAdded.Connect((player) => {
			if (player !== Players.LocalPlayer) {
				setPlayers((prevPlayers) => [...prevPlayers, player]);
			}
		});

		const onPlayerRemovingConnection = Players.PlayerRemoving.Connect((player) => {
			setPlayers((prevPlayers) => prevPlayers.filter((p) => p !== player));
		});

		// Ensure that the TextBox instance is available
		const textboxInstance = textboxRef.getValue();
		if (textboxInstance) {
			textboxInstance.FocusLost.Connect(() => {
				if (textboxInstance.Text === "") {
					textboxInstance.Text = "The Nameless Party";
				}
			});
		}

		// Cleanup function
		return () => {
			onPlayerAddedConnection.Disconnect();
			onPlayerRemovingConnection.Disconnect();
		};
	}, []);

	useEffect(() => {
		const onPlayerProfessionUpdateEvent = PlayerProfessionUpdateEvent.Connect((profession: string) => {
			setPlayerProfession(profession);
		});
		return () => {
			onPlayerProfessionUpdateEvent.Disconnect();
		};
	}, []);

	useEffect(() => {
		const onPartyUpdate = PartyUpdateEvent.Connect((hostId: string, memberIds: Array<number>) => {
			const hostPlayer = new PartyPlayer(hostId, "host");
			const updatedPartyMembers = [hostPlayer];

			for (const id of memberIds) {
				if (tostring(id) !== hostId) {
					const memberPlayer = new PartyPlayer(tostring(id), "member");
					updatedPartyMembers.push(memberPlayer);
				}
			}

			print("updatedPartyMembers", updatedPartyMembers);
			setPartyMembers(updatedPartyMembers);
			setPartySize(updatedPartyMembers.size());
		});

		return () => {
			onPartyUpdate.Disconnect();
		};
	}, []);

	useEffect(() => {
		const onSendPartyMemberofClassEvent = SendPartyMemberofClassEvent.Connect(
			(members: Player[], profession: string) => {
				setPlayerProfessions((oldProfessions) => {
					const newProfessions: Map<string, string> = new Map<string, string>();

					for (const [key, value] of oldProfessions) {
						newProfessions.set(key, value);
					}

					// Iterate over each member and set their profession
					members.forEach((member) => {
						newProfessions.set(tostring(member.UserId), profession);
					});

					return newProfessions;
				});
			},
		);

		return () => {
			onSendPartyMemberofClassEvent.Disconnect();
		};
	}, []);

	useEffect(() => {
		const connection = PartyUpdateEvent.Connect((hostId: string, memberIds: Array<number>) => {
			const currentPlayerId = tostring(Players.LocalPlayer.UserId);
			if (currentPlayerId === hostId) {
				setIsHost(true);
			} else {
				setIsHost(false);
			}
		});

		return () => connection.Disconnect();
	}, []);

	return (
		<frame
			Key={"Party"}
			Size={new UDim2(1, 0, 1, 0)}
			Position={UDim2.fromScale(0, 1)}
			AnchorPoint={new Vector2(0, 1)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			Visible={props.visible === "party"}
		>
			<frame Key={"PartyContent"} Size={new UDim2(0.7, 0, 1, 0)} BackgroundTransparency={1}>
				<textlabel
					Text={"Your Party: " + partyName}
					Size={UDim2.fromScale(0.6, 0.1)}
					TextSize={15}
					Position={UDim2.fromScale(0, 0)}
					BackgroundTransparency={1}
					Font={Enum.Font.SourceSansBold}
					TextColor3={Color3.fromRGB(200, 200, 200)}
				/>
				<textbox
					Text={partyName}
					Size={UDim2.fromScale(0.2, 0.12)}
					Position={UDim2.fromScale(0.6, 0)}
					TextSize={12}
					Font={Enum.Font.SourceSansBold}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					BackgroundTransparency={0.5}
					BackgroundColor3={Color3.fromRGB(40, 40, 40)}
					ClearTextOnFocus={true}
					Ref={textboxRef} // Add this
					TextWrapped={true}
				/>

				<textbutton
					Text={"Set Name"}
					Size={UDim2.fromScale(0.15, 0.12)}
					Position={UDim2.fromScale(0.8, 0)}
					TextSize={15}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Font={Enum.Font.SourceSansBold}
					BackgroundColor3={Color3.fromRGB(128, 128, 128)}
					Event={{
						MouseButton1Click: () => {
							const textBoxValue = textboxRef.getValue()?.Text;
							if (textBoxValue !== undefined && textBoxValue !== undefined && textBoxValue !== "") {
								setPartyName(textBoxValue);
								// Add your code here to update the party name in your application state
							}
						},
					}}
				/>

				<textlabel
					Text={tostring(partySize) + "/7 members"}
					Size={UDim2.fromScale(1, 0.1)}
					Position={UDim2.fromScale(0, 0.12)}
					BackgroundTransparency={1}
					TextColor3={Color3.fromRGB(200, 200, 200)}
				/>
				<textbutton
					Text={"Invite a player to form a party"}
					Size={UDim2.fromScale(1, 0.1)}
					TextSize={15}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Position={UDim2.fromScale(0, 0.9)}
					Font={Enum.Font.SourceSansBold}
					BackgroundColor3={Color3.fromRGB(128, 128, 128)}
				/>
			</frame>

			<scrollingframe
				Key={"PlayerList"}
				Size={new UDim2(0.3, 0, 0.9, 0)} // Changed from 1 to 0.9 to leave space at the bottom
				Position={UDim2.fromScale(0.7, 0)}
				CanvasSize={UDim2.fromScale(0.3, players.size() * 0.1)} // Adjust this value depending on the size of your items and the number of players
				BackgroundTransparency={1}
			>
				<uilistlayout FillDirection={"Vertical"} SortOrder={"LayoutOrder"} Padding={new UDim(0, 10)} />

				{players
					.filter(
						(player) => !partyMembers.some((partyMember) => partyMember.userId === tostring(player.UserId)),
					)
					.map((player, index) => (
						<PlayerItem name={player.Name} player={player} isHost={isHost} />
					))}
			</scrollingframe>

			<scrollingframe
				Key={"PartyList"}
				Size={new UDim2(0.2, 0, 1, 0)}
				Position={UDim2.fromScale(0, 0.1)}
				CanvasSize={UDim2.fromScale(0.3, partyMembers.size() * 0.1)}
				BackgroundTransparency={1}
			>
				<uilistlayout FillDirection={"Vertical"} SortOrder={"LayoutOrder"} Padding={new UDim(0, 10)} />
				{partyMembers
					.filter((partyMember) => getPlayerfromUserId(partyMember.userId) !== undefined)
					.map((partyMember, index) => (
						<frame Key={partyMember.userId} Size={new UDim2(1, 0, 0, 50)} BackgroundTransparency={1}>
							<textlabel
								Text={
									getPlayerfromUserId(partyMember.userId)?.Name +
									(partyMember.userId === tostring(Players.LocalPlayer.UserId) ? " (You)" : "") +
									" " +
									partyMember.role
								}
								Size={UDim2.fromScale(0.7, 1)}
								TextColor3={Color3.fromRGB(200, 200, 200)}
								BackgroundColor3={Color3.fromRGB(40, 40, 40)}
							/>
							{/* Remove the "Invite" button for party members */}
						</frame>
					))}
			</scrollingframe>

			{/*
			<frame
				Key={"PlayerInfo"}
				Size={new UDim2(0.28, 0, 0.1, 0)}
				Position={UDim2.fromScale(0.7, 0.9)}
				BackgroundTransparency={1}
			>
				<textlabel
					Size={UDim2.fromScale(1, 1)}
					BackgroundTransparency={1}
					TextColor3={Color3.fromRGB(255, 255, 255)}
					Text={
						"[Exclusive Event] Within the first 48 hours, party with 5 friends and win the Gods Hand! Act now - you have only 2 days!"
					}
					TextWrapped={true}
					TextSize={15}
					TextScaled={true}
					TextXAlignment={Enum.TextXAlignment.Center}
					TextYAlignment={Enum.TextYAlignment.Center}
				/>
			</frame>
				*/}
		</frame>
	);
};

export default new Hooks(Roact)(Party);
