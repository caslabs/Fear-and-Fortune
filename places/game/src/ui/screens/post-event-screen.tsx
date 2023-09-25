import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import { Pages } from "ui/Context";
import Close from "ui/Panels/Close";
import { Panel } from "ui/Panels/Panel";

interface PostEventProps {}

const player = Players.LocalPlayer;

const ExtractToLobbyEvent = Remotes.Client.Get("ExtractToLobby");
// Shows the notice board upon on joined in lobby place
const PostEventScreen: Hooks.FC<PostEventProps> = (props, { useState }) => {
	return (
		<frame
			Key={"PostEventScreen"}
			BorderSizePixel={0}
			Size={UDim2.fromOffset(504, 360)}
			AnchorPoint={new Vector2(0.5, 0.5)}
			Position={UDim2.fromScale(0.5, 0.5)}
			BackgroundColor3={Color3.fromRGB(70, 70, 70)}
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
			<uipadding
				PaddingTop={new UDim(0, 12)}
				PaddingBottom={new UDim(0, 12)}
				PaddingLeft={new UDim(0, 12)}
				PaddingRight={new UDim(0, 12)}
			/>
			<scrollingframe
				Key={"ScrollingFrame"}
				Size={UDim2.fromScale(1, 1)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				ScrollBarThickness={6}
				AutomaticCanvasSize={"Y"}
				CanvasSize={UDim2.fromScale(0, 1)}
			>
				<uilistlayout
					SortOrder={"LayoutOrder"}
					HorizontalAlignment={"Center"}
					FillDirection={"Vertical"}
					Padding={new UDim(0.05, 0)}
				/>
				<textlabel
					Key={"Title"}
					Text={"You can safely leave the game now!"}
					TextSize={24}
					Font={Enum.Font.Garamond}
					ZIndex={999}
					BackgroundTransparency={1}
					Size={UDim2.fromScale(1, 0.2)}
					LayoutOrder={-1}
					TextColor3={Color3.fromRGB(255, 255, 255)}
				/>
				<textlabel
					Key={"SubTitle"}
					Text={"Stop Spectating and Return To Lobby?"}
					TextSize={20}
					Font={Enum.Font.Garamond}
					ZIndex={999}
					BackgroundTransparency={1}
					Size={UDim2.fromScale(1, 0.2)}
					LayoutOrder={0}
					TextColor3={Color3.fromRGB(255, 255, 255)}
				/>

				<textbutton
					Key={"LobbyButton"}
					Text={"Return To Lobby"}
					LayoutOrder={2}
					FontSize={Enum.FontSize.Size8}
					Size={UDim2.fromScale(0.3, 0.2)}
					BorderSizePixel={0}
					BackgroundColor3={Color3.fromRGB(0, 0, 0)}
					ZIndex={5}
					BackgroundTransparency={0.5}
					TextColor3={Color3.fromRGB(255, 255, 255)}
					Event={{
						MouseButton1Click: () => {
							ExtractToLobbyEvent.SendToServer(player);
							print("Extracting to lobby button triggered...");
						},
					}}
				>
					<uicorner CornerRadius={new UDim(0, 6)} />
					<uipadding
						PaddingTop={new UDim(0, 6)}
						PaddingBottom={new UDim(0, 6)}
						PaddingLeft={new UDim(0, 6)}
						PaddingRight={new UDim(0, 6)}
					/>
				</textbutton>

				<textbutton
					Key={"SpectatingButtton"}
					Text={"Keep Spectating"}
					LayoutOrder={1}
					FontSize={Enum.FontSize.Size8}
					Size={UDim2.fromScale(0.3, 0.2)}
					BorderSizePixel={0}
					BackgroundColor3={Color3.fromRGB(0, 0, 0)}
					ZIndex={5}
					BackgroundTransparency={0.5}
					TextColor3={Color3.fromRGB(255, 255, 255)}
					Event={{
						MouseButton1Click: () => {
							Signals.OnExitScreenClosed.Fire();
						},
					}}
				>
					<uicorner CornerRadius={new UDim(0, 6)} />
					<uipadding
						PaddingTop={new UDim(0, 6)}
						PaddingBottom={new UDim(0, 6)}
						PaddingLeft={new UDim(0, 6)}
						PaddingRight={new UDim(0, 6)}
					/>
				</textbutton>
			</scrollingframe>

			<textbutton
				Key={"Close"}
				Text={""}
				Size={UDim2.fromOffset(40, 40)}
				AnchorPoint={new Vector2(1, 0)}
				Position={UDim2.fromScale(1, 0)}
				Event={{
					MouseButton1Click: () => {
						Signals.OnExitScreenClosed.Fire();
					},
				}}
			>
				<uicorner CornerRadius={new UDim(0, 6)} />
				<uipadding
					PaddingTop={new UDim(0, 6)}
					PaddingBottom={new UDim(0, 6)}
					PaddingLeft={new UDim(0, 6)}
					PaddingRight={new UDim(0, 6)}
				/>
				<imagelabel
					Key={"Icon"}
					Image={"http://www.roblox.com/asset/?id=5107150301"}
					Size={UDim2.fromScale(1, 1)}
					AnchorPoint={new Vector2(0.5, 0.5)}
					Position={UDim2.fromScale(0.5, 0.5)}
					BackgroundTransparency={1}
				/>
			</textbutton>
		</frame>
	);
};

export default new Hooks(Roact)(PostEventScreen);
