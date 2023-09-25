import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { RunService, Players, TeleportService } from "@rbxts/services";
import { Pages } from "../../routers/Lobby/Context-LobbyHUD";
import { setCurrentTab, getCurrentTab, getPageVisible, setPageVisibleGlob } from "./data/shop-manager";
import { ItemsList } from "./data/items-list";
import { CraftingList } from "./data/crafting-list";
import { Panel } from "ui/Pages/Panels/PanelLobby/Panel";
import Tab from "ui/Pages/Panels/PanelLobby/Tab";
import Play from "./Play/play-tab";
import Party from "./Party/party-tab";
import Trade from "./Trade/trade-tab";
import Leaderboard from "./Leaderboard/leaderboard-tab";
import Inventory from "./Inventory/inventory-tab";
//import Profession from "./profession-tab";
import { Signals } from "shared/signals";
import Remotes from "shared/remotes";
import { ProfessionList } from "./data/profession-list";
import InviteFriends from "./TwitterButton";
import Crafting from "./Craft/crafting-tab";
import Tutorial from "./TutorialButton";
import Profession from "./Profession/profession-tab";
import Notification from "mechanics/PlayerMechanics/UIMechanic/manager/notification";
import { inventoryList } from "./data/_inventoryData";
import TitleScreenButton from "./TitleScreenButton";
import CreditsButton from "./CreditsButton";
import { inventoryListDesc } from "./data/_inventoryDataDesc";
import TwitterButton from "./TwitterButton";
import InviteFriendsButton from "./InviteFriendsButton";
import TutorialButton from "./TutorialButton";
import { HuntingList } from "./data/hunting-list";
import VersionButton from "./VersionButton";

export interface Data {
	name: string;
	color: Color3;
	desc?: string;
	audio?: string;
}
interface ShopProps {
	visible?: boolean;
}

export class TimerState {
	isActive = false;
}

export interface Inventory {
	[itemId: string]: number; // Key is the item ID, value is the quantity
}

export enum QueueState {
	Idle,
	Searching,
	ServerFound,
	EmbarkFailed,
}

enum PlayerClass {
	Mountaineer,
	Soldier,
	Engineer,
	Doctor,
	Scholar,
	Cameraman,
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

const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

const QueueStateChangeEvent = Remotes.Client.Get("QueueStateChange");
const GetInventoryEvent = Remotes.Client.Get("GetInventory");
const UpdateCurrencyEvent = Remotes.Client.Get("UpdateCurrency");
const PlayerProfessionUpdateEvent = Remotes.Client.Get("PlayerProfessionUpdate");

const LobbyPage: Hooks.FC<ShopProps> = (props, { useState, useEffect }) => {
	const [tabChosen, setTabChosen] = useState(getCurrentTab());
	const [pageVisible, setPageVisible] = useState(getPageVisible());
	const [queueState, setQueueState] = useState<QueueState>(QueueState.Idle);
	const [queueText, setQueueText] = useState<string>("");
	const [queueTimer, setQueueTimer] = useState(0);
	const [countdownTime, setCountdownTime] = useState<number | undefined>(undefined);
	const [itemsList, setItemsList] = useState<Inventory>({});
	const [currency, setCurrency] = useState(0);
	const [profession, setProfession] = useState("Mountaineer");

	useEffect(() => {
		const connection = Signals.queueStateChangedSignal.Connect(setQueueState);
		return () => connection.Disconnect();
	}, []);

	useEffect(() => {
		const connection = QueueStateChangeEvent.Connect(setQueueState);
		return () => connection.Disconnect();
	}, []);

	useEffect(() => {
		const connection = UpdateCurrencyEvent.Connect((player: Player, currency: number) => {
			setCurrency(currency);
		});
		print("Update currency");
		return () => connection.Disconnect();
	}, []);

	useEffect(() => {
		const connection = PlayerProfessionUpdateEvent.Connect((profession: string) => {
			setProfession(profession);
		});
		print("Update profession");
		return () => connection.Disconnect();
	}, []);

	useEffect(() => {
		const startConnection = Signals.startCountdownSignal.Connect((time: number) => {
			setCountdownTime(time);
		});
		const endConnection = Signals.endCountdownSignal.Connect(() => {
			setCountdownTime(undefined);
		});
		const embarkFailedConnection = Signals.embarkFailedSignal.Connect(() => {
			// You could handle this signal separately if you need to.
		});

		return () => {
			startConnection.Disconnect();
			endConnection.Disconnect();
			embarkFailedConnection.Disconnect();
		};
	}, []);

	useEffect(() => {
		const minutes = (queueTimer - (queueTimer % 60)) / 60;
		const seconds = queueTimer - minutes * 60;
		const queueTimeString = "%02d:%02d".format(minutes, seconds);

		switch (queueState) {
			case QueueState.Idle:
				setQueueText("");
				break;
			case QueueState.Searching:
				setQueueText(`[${queueTimeString}] Searching for Players and Servers...`);
				print(`Queue time string: ${queueTimeString}`);
				break;
			case QueueState.ServerFound:
				if (countdownTime !== undefined) {
					// Add this check
					setQueueText(`[${countdownTime}] Server Found! Attempting to Embark...`);

					if (countdownTime === 1) {
						setQueueText(`Embarking...`);
					}
				}
				break;
			case QueueState.EmbarkFailed:
				setQueueText("Embark failed! Retrying...");
				break;
		}
	}, [queueState, queueTimer, countdownTime]); // Note the dependency array now includes countdownTime

	useEffect(() => {
		let connection: RBXScriptConnection | undefined;

		if (queueState === QueueState.Searching) {
			let index = 0;
			let lastTime = tick();

			connection = RunService.RenderStepped.Connect(() => {
				if (queueState !== QueueState.Searching) {
					connection?.Disconnect();
					setQueueTimer(0);
					print("QueueState is not Searching anymore, disconnecting and resetting timer");
				} else {
					const currentTime = tick();
					if (currentTime - lastTime >= 1) {
						setQueueTimer(index);
						print(`Timer incremented, queueTimer is now ${index}`);
						index++;
						lastTime = currentTime;
					}
				}
			});
		} else {
			setQueueTimer(0);
			print("QueueState is not Searching, resetting timer");
		}

		return () => {
			if (connection) {
				connection.Disconnect();
			}
		};
	}, [queueState]);

	useEffect(() => {
		const player = Players.LocalPlayer;
	}, []);

	return (
		<Panel Key={"LobbyPanel"} index={Pages.lobby} visible={props.visible}>
			<InviteFriendsButton />
			<TwitterButton />
			{/* <TutorialButton /> */}
			<CreditsButton />
			<VersionButton />
			<frame
				Size={UDim2.fromScale(0.1, 0.05)}
				Position={UDim2.fromScale(0, 1)}
				BackgroundTransparency={1}
				AnchorPoint={new Vector2(0, 1)}
			>
				<imagelabel
					Image="rbxassetid://12644643565" // Replace ImageID with the ID of your image
					Size={UDim2.fromScale(0.3, 0.7)} // Adjust as per the required size
					Position={UDim2.fromScale(0.15, 0.1)} // Position to the left
					BackgroundTransparency={1}
					ScaleType={Enum.ScaleType.Fit}
				/>
				<textlabel
					Text={tostring(currency)}
					TextScaled={true}
					Font={"GrenzeGotisch"}
					Size={UDim2.fromScale(0.5, 1)} // Adjust as per the required size
					Position={UDim2.fromScale(0.5, -0.1)} // Position to the right
					BackgroundTransparency={1}
					TextColor3={new Color3(1, 1, 1)}
					TextXAlignment={Enum.TextXAlignment.Left} // Align text to the left of the TextLabel
				/>
			</frame>

			<textlabel
				Key={"QueueText"}
				Text={queueText}
				ZIndex={5}
				Size={UDim2.fromScale(0.25, 0.1)}
				Position={UDim2.fromScale(1, 1)}
				BackgroundTransparency={1}
				TextColor3={new Color3(1, 1, 1)}
				AnchorPoint={new Vector2(1, 1)}
			/>

			<textlabel
				Key={"Studio"}
				Text={"QTREE STUDIO"}
				ZIndex={5}
				Size={UDim2.fromScale(0.1, 0.1)}
				Position={UDim2.fromScale(0, 1)}
				BackgroundTransparency={1}
				TextColor3={new Color3(1, 1, 1)}
				AnchorPoint={new Vector2(0, 1)}
			/>

			<frame
				Key={"Lobby"}
				BorderSizePixel={0}
				Size={UDim2.fromScale(1, 1)}
				AnchorPoint={new Vector2(0.5, 0.5)}
				Position={UDim2.fromScale(0.5, 0.5)}
				BackgroundColor3={Color3.fromRGB(26, 26, 26)}
			>
				<uicorner CornerRadius={new UDim(0, 6)} />
				<uipadding
					PaddingTop={new UDim(0, 12)}
					PaddingBottom={new UDim(0, 12)}
					PaddingLeft={new UDim(0, 12)}
					PaddingRight={new UDim(0, 12)}
				/>
				<frame
					Key={"Tabs"}
					Size={new UDim2(0.1, 0, 0.9, 0)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
					Position={new UDim2(0, 0, 0.05, 0)}
				>
					<uilistlayout FillDirection={"Vertical"} Padding={new UDim(0, 6)} />
					<Tab
						text="Leaderboard"
						page="leaderboard"
						active={"Leaderboard" === tabChosen}
						onClick={(page) => {
							setTabChosen("Leaderboard");
							setCurrentTab("Leaderboard");
							setPageVisible(page);
							setPageVisibleGlob(page);
						}}
					/>
					<Tab
						text="Play"
						page="play"
						active={"Play" === tabChosen}
						onClick={(page) => {
							setTabChosen("Play");
							setCurrentTab("Play");
							setPageVisible(page);
							setPageVisibleGlob(page);
						}}
					/>
					<Tab
						text="Party"
						page="party"
						active={"Party" === tabChosen}
						onClick={(page) => {
							setTabChosen("Party");
							setCurrentTab("Party");
							setPageVisible(page);
							setPageVisibleGlob(page);
						}}
					/>
					<Tab
						text={"Profession\n[" + profession + "]"}
						page="profession"
						active={"Profession" === tabChosen}
						onClick={(page) => {
							setTabChosen("Profession");
							setCurrentTab("Profession");
							setPageVisible(page);
							setPageVisibleGlob(page);
						}}
					/>
					<Tab
						text="Stash"
						page="inventory"
						active={"Inventory" === tabChosen}
						onClick={(page) => {
							setTabChosen("Inventory");
							setCurrentTab("Inventory");
							setPageVisible(page);
							setPageVisibleGlob(page);
						}}
					/>
					<Tab
						text="Crafting"
						page="crafting"
						active={"Crafting" === tabChosen}
						onClick={(page) => {
							setTabChosen("Crafting");
							setCurrentTab("Crafting");
							setPageVisible(page);
							setPageVisibleGlob(page);
						}}
					/>
					<Tab
						text="Trade"
						page="trade"
						active={"Trade" === tabChosen}
						onClick={(page) => {
							setTabChosen("Trade");
							setCurrentTab("Trade");
							setPageVisible(page);
							setPageVisibleGlob(page);
						}}
					/>
				</frame>
				<frame
					Key={"Content"}
					Size={new UDim2(0.75, 0, 1, 0)}
					Position={new UDim2(0.25, 0, 0, 0)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
				>
					<Leaderboard visible={pageVisible} playerName={"qwertyman10"} />
					<Inventory visible={pageVisible} data={inventoryListDesc} />
					<Play visible={pageVisible} data={HuntingList} />
					<Party visible={pageVisible} data={ItemsList} />
					<Profession visible={pageVisible} data={ProfessionList} />
					<Crafting visible={pageVisible} data={CraftingList} />
					<Trade visible={pageVisible} data={inventoryList} />
				</frame>
			</frame>
		</Panel>
	);
};

export default new Hooks(Roact)(LobbyPage);
