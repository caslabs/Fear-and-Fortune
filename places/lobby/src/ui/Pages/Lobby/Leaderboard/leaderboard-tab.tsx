import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import PurchaseItem from "ui/components/Items/ItemPurchase";
import { AutoScrollingFrame } from "ui/components/Dynamic/ScrollingFrame";
import { Players, MarketplaceService } from "@rbxts/services";
import Remotes from "shared/remotes";

interface LeaderboardProps {
	visible?: string;
	playerName: string;
}

interface LeaderboardData {
	name: string;
	donation: number;
}

interface ExpeditionData {
	name: string;
	expedition: number;
}

const getDonationDataFunc = Remotes.Client.Get("GetDonationData");
const getExpeditionDataFunc = Remotes.Client.Get("GetExpeditionData");

//TODO: is there a better way? Had to use Global as setData was not updating the data variable
const Leaderboard: Hooks.FC<LeaderboardProps> = (props, { useState, useEffect }) => {
	const [selectedTab, setSelectedTab] = useState<"Top Donated" | "Most Expeditions">("Top Donated");
	const [entries, setEntries] = useState(10);
	const [leaderboardData, setLeaderboardData] = useState([] as LeaderboardData[]); // Define initial state
	const [expeditionData, setExpeditionData] = useState([] as ExpeditionData[]); // Define initial state
	const [refresh, setRefresh] = useState(false);
	const [refreshState, setRefreshState] = useState("Refresh");

	const [isCoolDown, setIsCoolDown] = useState(false);

	useEffect(() => {
		if (refresh) {
			setRefreshState("Refreshing...");
			if (selectedTab === "Top Donated") {
				getDonationDataFunc.CallServerAsync().then(async (data) => {
					print("Data:", data);
					setLeaderboardData(await data);
					setRefreshState("Refreshed!");

					Promise.delay(1.5).then(() => {
						setRefreshState("Refresh");
						setRefresh(false);
						setIsCoolDown(false);
					});
				});
			} else if (selectedTab === "Most Expeditions") {
				getExpeditionDataFunc.CallServerAsync().then(async (data) => {
					print("Data:", data);
					setExpeditionData(await data);
					setRefreshState("Refreshed!");

					Promise.delay(1.5).then(() => {
						setRefreshState("Refresh");
						setRefresh(false);
						setIsCoolDown(false);
					});
				});
			}
		}
	}, [refresh]);

	useEffect(() => {
		if (selectedTab === "Top Donated") {
			getDonationDataFunc.CallServerAsync().then(async (data) => {
				print("Data:", data);
				setLeaderboardData(await data);
			});
		} else if (selectedTab === "Most Expeditions") {
			getExpeditionDataFunc.CallServerAsync().then(async (data) => {
				print("Data:", data);
				setExpeditionData(await data);
			});
		}
	}, [selectedTab]);

	return (
		<frame
			Key={"LeaderboardPage"}
			Size={new UDim2(1, 0, 1, 0)}
			Position={UDim2.fromScale(0, 1)}
			AnchorPoint={new Vector2(0, 1)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			Visible={props.visible === "leaderboard"}
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
					Key={"LeaderboardTabButton1"}
					Text={"Donators"}
					TextSize={13}
					Font={"GothamBold"}
					Size={UDim2.fromScale(1, 0.35)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Event={{
						MouseButton1Click: () => setSelectedTab("Top Donated"),
					}}
					BackgroundColor3={
						selectedTab === "Top Donated" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
					}
				/>
				<textbutton
					Key={"LeaderboardTabButton2"}
					Text={"Expeditions"}
					Font={"GothamBold"}
					TextSize={13}
					Size={UDim2.fromScale(1, 0.35)}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Position={UDim2.fromScale(0, 0.4)}
					Event={{
						MouseButton1Click: () => setSelectedTab("Most Expeditions"),
					}}
					BackgroundColor3={
						selectedTab === "Most Expeditions" ? Color3.fromRGB(128, 128, 128) : Color3.fromRGB(45, 45, 45)
					}
				/>
			</frame>

			<scrollingframe
				Size={UDim2.fromScale(0.77, 1)}
				Position={UDim2.fromScale(0.2, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				ScrollBarThickness={6}
				Visible={selectedTab === "Top Donated"}
				CanvasSize={UDim2.fromScale(0, 1)}
			>
				<textlabel
					Text={"Top Donators"}
					Size={UDim2.fromScale(0.4, 0.09)}
					Position={UDim2.fromScale(0.5, 0.03)}
					AnchorPoint={new Vector2(0.5, 0)}
					BackgroundTransparency={1}
					TextColor3={new Color3(1, 1, 1)}
					Font={Enum.Font.GothamBold}
					TextSize={30}
				/>
				{leaderboardData.map((entry, index) => {
					return (
						<textlabel
							Key={tostring(index)}
							Text={`${entry.name} - ${entry.donation}`}
							Size={UDim2.fromScale(0.5, 0.05)}
							BackgroundTransparency={0.7}
							Position={UDim2.fromScale(0.5, 0.12 + index * 0.05)}
							AnchorPoint={new Vector2(0.5, 0)}
							BackgroundColor3={Color3.fromRGB(45, 45, 45)}
							TextColor3={Color3.fromRGB(222, 222, 222)}
							Font={Enum.Font.GothamBold}
						/>
					);
				})}
			</scrollingframe>

			<scrollingframe
				Size={UDim2.fromScale(0.77, 1)}
				Position={UDim2.fromScale(0.2, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				ScrollBarThickness={6}
				Visible={selectedTab === "Most Expeditions"}
				CanvasSize={UDim2.fromScale(0, 1)}
			>
				<textlabel
					Text={"Most Expeditions"}
					Size={UDim2.fromScale(0.4, 0.09)}
					Position={UDim2.fromScale(0.5, 0.03)}
					AnchorPoint={new Vector2(0.5, 0)}
					BackgroundTransparency={1}
					TextColor3={new Color3(1, 1, 1)}
					Font={Enum.Font.GothamBold}
					TextSize={30}
				/>
				{expeditionData.map((entry, index) => {
					return (
						<textlabel
							Key={tostring(index)}
							Text={`${entry.name} - ${entry.expedition}`}
							Size={UDim2.fromScale(0.5, 0.05)}
							BackgroundTransparency={0.7}
							Position={UDim2.fromScale(0.5, 0.12 + index * 0.05)}
							AnchorPoint={new Vector2(0.5, 0)}
							BackgroundColor3={Color3.fromRGB(45, 45, 45)}
							TextColor3={Color3.fromRGB(222, 222, 222)}
							Font={Enum.Font.GothamBold}
						/>
					);
				})}
			</scrollingframe>

			<textbutton
				Key={"DonateButton"}
				Text={"Donate  100"} // Substitute ₹ for Roblox logo
				Visible={selectedTab === "Top Donated"}
				Size={UDim2.fromScale(0.2, 0.1)}
				Position={UDim2.fromScale(0.6, 0.9)} // Positioned at the bottom-center
				AnchorPoint={new Vector2(0.5, 0.5)}
				BackgroundTransparency={0.1}
				BackgroundColor3={Color3.fromRGB(45, 45, 45)}
				TextColor3={Color3.fromRGB(222, 222, 222)}
				Font={Enum.Font.GothamBold}
				Event={{
					MouseButton1Click: () => {
						MarketplaceService.PromptProductPurchase(Players.LocalPlayer, 1585639493);

						//TODO: Upon success, call the server to update the leaderboard
						//setRefresh(!refresh);
					},
				}}
			/>

			<textbutton
				Key={"RefreshButton"}
				Text={refreshState}
				Size={UDim2.fromScale(0.1, 0.05)}
				Position={UDim2.fromScale(0.9, 0.05)}
				BackgroundColor3={Color3.fromRGB(45, 45, 45)}
				TextColor3={Color3.fromRGB(222, 222, 222)}
				Font={Enum.Font.GothamBold}
				TextSize={14}
				Event={{
					MouseButton1Click: () => {
						if (!isCoolDown) {
							setIsCoolDown(true);
							setRefresh(!refresh);

							Promise.delay(1.5).then(() => {
								setIsCoolDown(false);
							});
						}
					},
				}}
			/>
		</frame>
	);
};

export default new Hooks(Roact)(Leaderboard);
