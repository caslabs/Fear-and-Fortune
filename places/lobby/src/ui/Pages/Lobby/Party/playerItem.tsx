import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";
import Theme from "ui/theme";

// PlayerItem.ts

interface PlayerItemProps {
	name: string;
	player: Player;
	isHost: boolean;
	onClick?: () => void;
}

const player = Players.LocalPlayer;
const InvitePlayerToPartyEvent = Remotes.Client.Get("InvitePlayerToParty");

const PlayerItem: Hooks.FC<PlayerItemProps> = (props, { useState }) => {
	const [invite, setInvite] = useState("Invite");

	return (
		<frame Key={props.name} Size={new UDim2(1, 0, 0, 50)} BackgroundTransparency={1}>
			<textlabel
				Text={props.name}
				Size={UDim2.fromScale(0.7, 1)}
				TextColor3={Color3.fromRGB(200, 200, 200)}
				BackgroundColor3={Color3.fromRGB(40, 40, 40)}
			/>
			<textbutton
				Text={invite}
				Size={UDim2.fromScale(0.3, 1)}
				TextSize={15}
				Position={UDim2.fromScale(0.7, 0)}
				TextColor3={Color3.fromRGB(255, 255, 255)}
				Font={Enum.Font.SourceSansBold}
				Visible={props.isHost}
				Event={{
					MouseButton1Click: () => {
						const playerToInvite = Players.GetPlayerByUserId(props.player.UserId);
						if (playerToInvite) {
							InvitePlayerToPartyEvent.SendToServer(playerToInvite.UserId);
						}
						setInvite("Sent!");
						// Revert the button text after 2 seconds
						wait(2);
						setInvite("Invite");
					},
				}}
			/>
		</frame>
	);
};

export default new Hooks(Roact)(PlayerItem);
