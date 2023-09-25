import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { SocialService, Players } from "@rbxts/services";
import { Signals } from "shared/signals";
import CreditScreen from "ui/screens/credit-screen";

interface TitleScreenProps {}

const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

// Credit Screen Button
const CreditsButton: Hooks.FC<TitleScreenProps> = (props, { useState }) => {
	const [buttonText, setButtonText] = useState("Invite Friends");
	return (
		<frame
			Key={"CreditScreenButton"}
			Size={UDim2.fromScale(0.15, 0.035)}
			Position={new UDim2(0, 0, 1, 0)}
			AnchorPoint={new Vector2(0, 1)}
			BackgroundTransparency={0}
			BorderColor3={Color3.fromRGB(255, 255, 255)}
			BorderSizePixel={1}
			BackgroundColor3={Color3.fromRGB(0, 0, 0)}
		>
			<uilistlayout
				Key={"Layout"}
				Padding={new UDim(0, 10)}
				FillDirection={"Vertical"}
				VerticalAlignment={"Top"}
				SortOrder={"LayoutOrder"}
			/>
			<textbutton
				Key={"Button"}
				Text={"Credits"}
				FontSize={Enum.FontSize.Size8}
				TextSize={8}
				Size={UDim2.fromScale(1, 1)}
				BorderSizePixel={0}
				BackgroundColor3={Color3.fromRGB(0, 0, 0)}
				ZIndex={5}
				BackgroundTransparency={0.5}
				TextColor3={Color3.fromRGB(255, 255, 255)}
				Event={{
					MouseButton1Click: () => {
						//Credits
						const handle: Roact.Tree = Roact.mount(
							<screengui Key={"ExitScreen"} IgnoreGuiInset={true} ResetOnSpawn={false}>
								<CreditScreen />
							</screengui>,
							PlayerGui,
						);

						Signals.OnCreditScreenExit.Wait();
						Roact.unmount(handle);
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
		</frame>
	);
};

export default new Hooks(Roact)(CreditsButton);
