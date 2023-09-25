import Roact, { Ref } from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Players, Workspace } from "@rbxts/services";
import { Data } from "../index";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import { QueueState, Signals } from "shared/signals";
import Remotes from "shared/remotes";
import ProfileImage from "./profile-image";
import { InventoryItemData } from "../data/_inventoryData";
import InventoryItem from "./inventory-component";
import EmptyInventoryItem from "./empty-inventory-component";
import CraftItem from "ui/components/Items/CraftItem";
import { CharacterViewport } from "@rbxts/character-viewport";
import Section from "./section";
import VerticalFeature from "./verticalfeature";
import Footer from "./footer";

const JoinMatchEvent = Remotes.Client.Get("JoinMatch");
const LeaveMatchEvent = Remotes.Client.Get("LeaveMatch");
const UpdatePlayerCountEvent = Remotes.Client.Get("UpdatePlayerCount");
const UpdateQueueMembersEvent = Remotes.Client.Get("UpdateQueueMembers");
const PartyUpdateEvent = Remotes.Client.Get("PartyUpdate");
const GetHumanoidDescriptionFromUserIdEvent = Remotes.Client.Get("GetHumanoidDescriptionFromUserId");

interface InventoryProps {
	visible?: string;
	data: Array<InventoryItemData>; // Add this line to declare the data prop
}

function sortInventory(a: InventoryItemData, b: InventoryItemData) {
	if (a.name === "" && b.name !== "") {
		return false;
	} else if (a.name !== "" && b.name === "") {
		return true;
	} else {
		// If you need secondary sorting conditions, you can add them here
		return false;
	}
}

const UpdateInventoryEvent = Remotes.Client.Get("UpdateInventory");
const emptyInventoryItem: InventoryItemData = {
	name: "",
	quantity: 0,
	desc: "",
	// include any other necessary properties with default/empty values
};

type PartyRole = "host" | "member";

class PartyPlayer {
	userId: string;
	role: PartyRole;

	constructor(userId: string, role: PartyRole) {
		this.userId = userId;
		this.role = role;
	}
}

export interface HuntingData {
	name: string;
	desc: string;
	color: Color3;
	ingredients: Array<{ itemName: string; quantity: number }>; // New property
}

interface LobbyProps {
	data: Array<HuntingData>;
	visible: string;
}

// For members of the party
const EnterQueueEvent = Remotes.Client.Get("EnterQueue");
const ExitQueueEvent = Remotes.Client.Get("ExitQueue");
const RequestQueueEvent = Remotes.Client.Get("RequestQueue");

EnterQueueEvent.Connect(() => {
	SoundSystemController.playSound(SoundKeys.UI_QUEUE_ENTER, 2);
	Signals.queueStateChangedSignal.Fire(QueueState.Searching); // Queue entered
	JoinMatchEvent.SendToServer();
});

ExitQueueEvent.Connect(() => {
	SoundSystemController.playSound(SoundKeys.UI_QUEUE_EXIT, 2);
	Signals.queueStateChangedSignal.Fire(QueueState.Idle);
	LeaveMatchEvent.SendToServer();
});

function CloneMe(char: Model) {
	// a function that clones a player
	char.Archivable = true;
	const clone = char.Clone();
	char.Archivable = false;

	print("Character cloned");
	return clone;
}

const GetPlayerEvent = Remotes.Client.Get("GetPlayer");
GetPlayerEvent.SendToServer();
const Lobby: Hooks.FC<LobbyProps> = (props, { useState, useEffect }) => {
	const [playState, setPlayState] = useState<"play" | "awaiting expedition" | "cancel expedition?">("play");
	const [selectedTab, setSelectedTab] = useState<"play" | "hunt" | "patchNotes">("play");
	const [playerCount, setPlayerCount] = useState(0);
	const [QueueMembers, setQueueMembers] = useState<Player[]>([]);
	const [backpackData, setBackpackData] = useState<Array<InventoryItemData>>([]); // New state for backpack data
	const [playerClasses, setPlayerClasses] = useState<{ [userId: string]: string }>({});
	const [isHost, setIsHost] = useState(true);
	const [partyMembers, setPartyMembers] = useState<Array<PartyPlayer>>([]);
	const [partySize, setPartySize] = useState(1);
	const [selectedCraftItem, setSelectedCraftItem] = useState<HuntingData | undefined>(props.data[0]); // Default to first item
	const [activeCraftItem, setActiveCraftItem] = useState<string>(props.data[0].name); // Default to first item's name

	const camera = new Instance("Camera");
	camera.FieldOfView = 13.055;
	const CameraRef = Roact.createRef<Camera>();
	const ViewportRef = Roact.createRef<ViewportFrame>();
	const luffy = Workspace.WaitForChild("Luffy");
	const char = luffy.Clone() as Model;
	camera.FieldOfView = 13.055;

	useEffect(() => {
		const viewport = ViewportRef.getValue()!;
		char.Parent = viewport;
		camera.Parent = viewport;
		viewport.CurrentCamera = camera;
		char.Name = "curChar";
		const char_humanoid = char.WaitForChild("Humanoid") as Humanoid;
		print("char_humanoid", char_humanoid);

		// Get the positions
		const cameraPos = camera.CFrame.Position;
		const charPos = char.PrimaryPart!.Position;

		// Create new CFrame for the character, facing the camera
		const characterCFrame = new CFrame(charPos, cameraPos);
		char.PrimaryPart!.CFrame = characterCFrame.mul(CFrame.Angles(0, math.pi, 0)); // Rotate 180 degrees around the Y-axis
	});

	useEffect(() => {
		const connection = UpdatePlayerCountEvent.Connect((queuedPlayerCount) => {
			setPlayerCount(queuedPlayerCount);
		});

		return () => connection.Disconnect();
	}, []);

	let filledBackpackArray = [...backpackData];
	for (let i = backpackData.size(); i < 10; i++) {
		filledBackpackArray.push(emptyInventoryItem);
	}

	let filledBackpack2Array = [...backpackData];
	for (let i = backpackData.size(); i < 5; i++) {
		filledBackpack2Array.push(emptyInventoryItem);
	}

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

	filledBackpackArray = filledBackpackArray.sort(sortInventory);
	filledBackpack2Array = filledBackpack2Array.sort(sortInventory);

	const playStateRef = Roact.createRef<TextButton>();
	const gridImageComponentRef = Roact.createRef<Frame>();
	return (
		<frame
			Key={"Play"}
			Size={new UDim2(1, 0, 1, 0)}
			Position={UDim2.fromScale(0, 1)}
			AnchorPoint={new Vector2(0, 1)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			Visible={props.visible === "play"}
		>
			<frame
				Key={"TabButtons"}
				Size={new UDim2(0.2, 0, 0.3, 0)}
				Position={UDim2.fromScale(0, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				BackgroundColor3={new Color3(0, 0, 0)}
			>
				<textbutton
					Key={"PlayTabButton"}
					Text={"Expedition"}
					TextSize={13}
					Font={"GothamBold"}
					Size={UDim2.fromScale(1, 0.35)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Event={{
						MouseButton1Click: () => setSelectedTab("play"),
					}}
					BackgroundColor3={
						selectedTab === "play" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
					}
				/>
				<textbutton
					Key={"HuntTabButton"}
					Text={"Hunt"}
					Font={"GothamBold"}
					TextSize={13}
					Size={UDim2.fromScale(1, 0.35)}
					Position={UDim2.fromScale(1.1, 0)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Event={{
						MouseButton1Click: () => setSelectedTab("hunt"),
					}}
					BackgroundColor3={
						selectedTab === "hunt" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
					}
				/>

				<textbutton
					Key={"PatchNotes"}
					Text={"Patch Notes"}
					Font={"GothamBold"}
					TextSize={13}
					Size={UDim2.fromScale(1, 0.35)}
					Position={UDim2.fromScale(2.2, 0)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Event={{
						MouseButton1Click: () => setSelectedTab("patchNotes"),
					}}
					BackgroundColor3={
						selectedTab === "patchNotes" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
					}
				/>
			</frame>

			<frame
				Key={"Play"}
				Size={UDim2.fromScale(1, 1)}
				Position={UDim2.fromScale(0, 0.12)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				Visible={selectedTab === "play"}
			>
				<textlabel
					Text={"Expedition No.1924"}
					Size={UDim2.fromScale(0.9, 0.05)}
					Position={UDim2.fromScale(0, 0.05)}
					AnchorPoint={new Vector2(0, 0)}
					BackgroundTransparency={1}
					Font={"SpecialElite"}
					TextScaled={true}
					FontSize={Enum.FontSize.Size24}
					TextColor3={Color3.fromRGB(150, 150, 150)}
					TextXAlignment={Enum.TextXAlignment.Left}
					Visible={false}
				/>

				<scrollingframe
					Size={UDim2.fromScale(0.45, 0.64)}
					Position={UDim2.fromScale(1, 0.05)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
					ScrollBarThickness={6}
					AnchorPoint={new Vector2(1, 0)}
				>
					<uigridlayout
						CellPadding={UDim2.fromOffset(6, 6)}
						CellSize={UDim2.fromScale(0.2, 0.1)}
						SortOrder={Enum.SortOrder.LayoutOrder}
					/>

					{filledBackpackArray.map((item, index) =>
						// eslint-disable-next-line roblox-ts/lua-truthiness
						item.name ? (
							<InventoryItem
								Key={item.name}
								name={item.name}
								quantity={item.quantity}
								LayoutOrder={index}
							/>
						) : (
							<EmptyInventoryItem Key={"Empty_" + tostring(index)} LayoutOrder={index} />
						),
					)}
				</scrollingframe>

				<frame
					Key={"BodyImage"}
					BackgroundTransparency={0}
					BackgroundColor3={Color3.fromRGB(211, 245, 230)}
					Position={UDim2.fromScale(-0.02, 0.05)}
					AnchorPoint={new Vector2(0, 0)}
					Size={UDim2.fromScale(0.5, 0.5)}
					BorderSizePixel={0}
				>
					<viewportframe
						Size={new UDim2(0.9, 0, 0.9, 0)}
						Position={new UDim2(0, 15, 0, 13)}
						BackgroundColor3={Color3.fromRGB(255, 255, 204)}
						BorderColor3={Color3.fromRGB(170, 150, 127)}
						BorderSizePixel={0}
						BackgroundTransparency={0}
						CurrentCamera={CameraRef}
						Ref={ViewportRef}
					>
						<frame
							Key={"OverlayVintage"}
							BackgroundTransparency={0.7}
							BackgroundColor3={Color3.fromRGB(158, 135, 59)}
							AnchorPoint={new Vector2(0, 0)}
							Size={UDim2.fromScale(1, 1)}
							BorderSizePixel={0}
						></frame>
					</viewportframe>
				</frame>

				<scrollingframe
					Size={UDim2.fromScale(0.5, 0.1)}
					Position={UDim2.fromScale(0.52, 0.68)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
					ScrollBarThickness={6}
					AnchorPoint={new Vector2(1, 1)}
				>
					<uigridlayout
						CellPadding={UDim2.fromOffset(6, 6)}
						CellSize={UDim2.fromScale(0.15, 0.05)}
						SortOrder={Enum.SortOrder.LayoutOrder}
					/>

					{filledBackpack2Array.map((item, index) =>
						// eslint-disable-next-line roblox-ts/lua-truthiness
						item.name ? (
							<InventoryItem
								Key={item.name}
								name={item.name}
								quantity={item.quantity}
								LayoutOrder={index}
							/>
						) : (
							<EmptyInventoryItem Key={"Empty_" + tostring(index)} LayoutOrder={index} />
						),
					)}
				</scrollingframe>

				<textbutton
					Text={isHost ? playState : "HOST ONLY"}
					Size={UDim2.fromScale(0.3, 0.1)}
					BackgroundColor3={Color3.fromRGB(75, 75, 75)}
					Position={UDim2.fromScale(0.5, 0.8)}
					AnchorPoint={new Vector2(0.5, 0.5)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Ref={playStateRef}
					Event={{
						MouseButton1Click: () => {
							if (!isHost) return;

							if (playState === "play") {
								// If the player is in a party, let everyone in party also enter the queue
								if (partySize > 1) {
									const allPartyMembers: number[] = [];
									for (const partyMember of partyMembers) {
										if (partyMember.userId === undefined) return;
										if (
											partyMember.userId !== tostring(Players.LocalPlayer.UserId) &&
											partyMember.role === "member"
										) {
											const memberId = tonumber(partyMember.userId);
											if (memberId !== undefined) {
												allPartyMembers.push(memberId);
											}
										}
										RequestQueueEvent.SendToServer(allPartyMembers, "ENTER_QUEUE");
									}
								}

								setPlayState("awaiting expedition");
								SoundSystemController.playSound(SoundKeys.UI_QUEUE_ENTER, 2);
								Signals.queueStateChangedSignal.Fire(QueueState.Searching); // Queue entered
								JoinMatchEvent.SendToServer();
							} else if (playState === "cancel expedition?") {
								if (partySize > 1) {
									const allPartyMembers: number[] = [];
									for (const partyMember of partyMembers) {
										if (partyMember.userId === undefined) return;
										if (
											partyMember.userId !== tostring(Players.LocalPlayer.UserId) &&
											partyMember.role === "member"
										) {
											const memberId = tonumber(partyMember.userId);
											if (memberId !== undefined) {
												allPartyMembers.push(memberId);
											}
										}
										RequestQueueEvent.SendToServer(allPartyMembers, "EXIT_QUEUE");
									}
								}

								SoundSystemController.playSound(SoundKeys.UI_QUEUE_EXIT, 2);
								setPlayState("play");
								Signals.queueStateChangedSignal.Fire(QueueState.Idle);
								LeaveMatchEvent.SendToServer();
							}
						},
						MouseEnter: () => {
							if (!isHost) return;

							if (playState === "awaiting expedition") {
								setPlayState("cancel expedition?");
							}
						},
						MouseLeave: () => {
							if (!isHost) return;

							if (playState === "cancel expedition?") {
								setPlayState("awaiting expedition");
							} else if (playState === "play") {
								setPlayState("play");
							}
						},
					}}
				/>
			</frame>

			<frame
				Size={UDim2.fromScale(1, 0.9)}
				Key={"Hunt"}
				Position={UDim2.fromScale(0, 0.12)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				Visible={selectedTab === "hunt"}
			>
				<scrollingframe
					Size={UDim2.fromScale(0.27, 1)} // Adjust to make room for crafting info
					Position={UDim2.fromScale(0, 0)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
					ScrollBarThickness={3}
					AutomaticCanvasSize={"Y"}
				>
					<uigridlayout CellPadding={UDim2.fromScale(0, 0.03)} CellSize={UDim2.fromScale(1, 0.2)} />
					{props.data.map((info, index) => (
						<CraftItem
							Key={info.name}
							title={info.name}
							desc={info.desc}
							color={info.color}
							layoutOrder={index}
							active={activeCraftItem === info.name} // Pass active state
							onClick={() => {
								setSelectedCraftItem(info);
								setActiveCraftItem(info.name); // Set this item as active
							}}
						/>
					))}
				</scrollingframe>

				{selectedCraftItem && (
					<frame
						// Crafting Info Panel
						Size={UDim2.fromScale(0.7, 1)}
						Position={UDim2.fromScale(0.3, 0)}
						BorderSizePixel={0}
						BackgroundTransparency={1}
					>
						<textlabel
							Text={selectedCraftItem.name}
							Size={UDim2.fromScale(1, 0.2)} /* Rest of the properties */
							BackgroundTransparency={1}
							Font={Enum.Font.Gotham}
							TextColor3={Color3.fromRGB(230, 230, 230)}
							FontSize={Enum.FontSize.Size24}
						/>
						<textlabel
							Text={selectedCraftItem.desc}
							Position={UDim2.fromScale(0, 0.2)}
							Size={UDim2.fromScale(1, 0.25)} /* Rest of the properties */
							BackgroundTransparency={1}
							TextXAlignment={Enum.TextXAlignment.Left}
							TextYAlignment={Enum.TextYAlignment.Top}
							Font={Enum.Font.Gotham}
							FontSize={Enum.FontSize.Size14}
							RichText={true}
							TextWrapped={true}
							TextColor3={Color3.fromRGB(230, 230, 230)}
						/>

						<textbutton
							Text={"HUNT"}
							Size={UDim2.fromScale(1, 0.2)}
							AnchorPoint={new Vector2(0, 1)}
							Position={UDim2.fromScale(0, 1)}
							Font={Enum.Font.Gotham}
							TextColor3={Color3.fromRGB(200, 200, 200)}
							BackgroundColor3={Color3.fromRGB(75, 75, 75)}
						/>
					</frame>
				)}
			</frame>

			<frame
				Size={UDim2.fromScale(1, 0.9)}
				Key={"patchNotes"}
				Position={UDim2.fromScale(0, 0.12)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				Visible={selectedTab === "patchNotes"}
			>
				<scrollingframe
					Key={"ScrollingFrame"}
					Size={UDim2.fromScale(1, 1)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
					ScrollBarThickness={6}
					AutomaticCanvasSize={"Y"}
					CanvasSize={UDim2.fromScale(0, 7)}
				>
					<uilistlayout SortOrder={"LayoutOrder"} HorizontalAlignment={"Center"} FillDirection={"Vertical"} />
					<Section title={"Fear and Fortune"} description={"🎉 Alpha Launch 🎉"} LayoutOrder={0}>
						<VerticalFeature title={"Version 1.0.0"} LayoutOrder={3} fontsize={25} yalign={"Bottom"} />
						<VerticalFeature title={"Procedure Generated Maps"} LayoutOrder={4} />
						<imagelabel
							Size={UDim2.fromScale(0.8, 0.5)}
							Key={"5.5"}
							BackgroundTransparency={1}
							Image={"rbxassetid://11407592028"}
							LayoutOrder={5}
						/>
						<textlabel
							BackgroundTransparency={1}
							Size={UDim2.fromScale(0.8, 0.3)}
							Text={
								"We want players to explore the ice cold wastelands of Fear and Fortune. Every game session will curate a different experience."
							}
							Font={Enum.Font.GothamBold}
							TextColor3={Color3.fromRGB(255, 255, 255)}
							TextSize={15}
							LayoutOrder={6}
							RichText={true}
							TextWrapped={true}
						/>
						<VerticalFeature title={"Hunting System"} LayoutOrder={7} />
						<imagelabel
							Size={UDim2.fromScale(0.8, 0.5)}
							Key={"6.5"}
							BackgroundTransparency={1}
							Image={"rbxassetid://11407871999"}
							LayoutOrder={8}
						/>
						<textlabel
							BackgroundTransparency={1}
							Size={UDim2.fromScale(0.8, 0.3)}
							Text={
								"Explore the world and hunt down the most dangerous creatures. Collect their parts and craft the most powerful weapons and armor."
							}
							Font={Enum.Font.GothamBold}
							TextColor3={Color3.fromRGB(255, 255, 255)}
							TextSize={15}
							LayoutOrder={9}
							RichText={true}
							TextWrapped={true}
						/>
						<VerticalFeature title={"Profession Mechanic"} LayoutOrder={16} />
						<imagelabel
							Size={UDim2.fromScale(0.8, 0.5)}
							Key={"9.5"}
							BackgroundTransparency={1}
							Image={"rbxassetid://11407773585"}
							LayoutOrder={17}
						/>
						<textlabel
							BackgroundTransparency={1}
							Size={UDim2.fromScale(0.8, 0.3)}
							Text={
								"Choose a profession and specialize in it. Each profession has its own unique abilities and playstyle."
							}
							Font={Enum.Font.GothamBold}
							TextColor3={Color3.fromRGB(255, 255, 255)}
							TextSize={15}
							LayoutOrder={18}
							RichText={true}
							TextWrapped={true}
						/>
						<textlabel
							BackgroundTransparency={1}
							Size={UDim2.fromScale(0.8, 0.3)}
							Text={"Twitter Code: ALPHA"}
							Font={Enum.Font.GothamBold}
							TextColor3={Color3.fromRGB(255, 255, 255)}
							TextSize={21}
							LayoutOrder={19}
							RichText={true}
							TextWrapped={true}
						/>
						<Footer Key={"dd"} title={"made with ❤️ by qtree"} LayoutOrder={19} />
					</Section>
				</scrollingframe>
			</frame>
		</frame>
	);
};

export default new Hooks(Roact)(Lobby);
