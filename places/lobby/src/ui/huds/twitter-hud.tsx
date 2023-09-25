import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Close from "ui/Pages/Panels/PanelLobby/Close";
import { Players } from "@rbxts/services";
import { Panel } from "ui/Pages/Panels/PanelLobby/Panel";
import { Pages } from "ui/routers/Lobby/Context-LobbyHUD";
import Remotes from "shared/remotes";

interface TwitterHUDProps {
	visible?: boolean;
}

const CheckIfReedemEvent = Remotes.Client.Get("CheckIfReedem");
const ReedemTwitterCode = Remotes.Client.Get("ReedemTwitterCode");

const TwitterHUD: Hooks.FC<TwitterHUDProps> = (props, { useState, useEffect }) => {
	const textboxRef = Roact.createRef<TextBox>();
	const [players, setPlayers] = useState(() => Players.GetPlayers());
	const [partyName, setPartyName] = useState("TWITTER CODE");
	const [buttonText, setButtonText] = useState("Redeem");
	const [isRedeeming, setIsRedeeming] = useState(false);
	const [currency, setCurrency] = useState(0);
	const [textBoxValue, setTextBoxValue] = useState("");

	const UpdateCurrencyTwitterEvent = Remotes.Client.Get("UpdateCurrencyTwitter");

	useEffect(() => {
		const updateCurrency = UpdateCurrencyTwitterEvent.Connect((player: Player, currency: number) => {
			setCurrency(currency);
			print("Currency updated", currency);
		});
		print("Update currency on Twitter Page");
		return () => updateCurrency.Disconnect();
	}, []);

	useEffect(() => {
		const textboxInstance = textboxRef.getValue();
		print(textboxRef);
		print(textboxRef.getValue());

		if (textboxInstance) {
			textboxInstance.FocusLost.Connect(() => {
				print("Focus Lost", textboxInstance.Text);
				if (textboxInstance.Text === "") {
					textboxInstance.Text = "ENTER CODE HERE";
				}
			});

			textboxInstance.GetPropertyChangedSignal("Text").Connect(() => {
				setTextBoxValue(textboxInstance.Text);
			});
		}

		if (isRedeeming) {
			CheckIfReedemEvent.CallServerAsync().then(async (alreadyRedeemed) => {
				if (await alreadyRedeemed) {
					setButtonText("Already Redeemed!");
					// wait for 2 seconds, then reset button
					Promise.delay(2).then(() => {
						setButtonText("Redeem");
						setIsRedeeming(false);
					});
				} else {
					setButtonText("Redeeming...");

					// eslint-disable-next-line roblox-ts/lua-truthiness
					if (textBoxValue) {
						ReedemTwitterCode.CallServerAsync(textBoxValue).then((response) => {
							print(response);
							setButtonText(response); // Use the response from server
							Promise.delay(2).then(() => {
								setButtonText("Redeem");
								setIsRedeeming(false);
							});
						});
					} else {
						print("No textbox value");
						print(textBoxValue);
					}
				}
			});
		}

		// Cleanup function
		return () => {};
	}, [isRedeeming]);

	return (
		<Panel index={Pages.twitter} visible={props.visible}>
			<frame
				Size={new UDim2(1, 0, 1, 0)}
				Position={new UDim2(0, 0, 0, 0)}
				BackgroundColor3={Color3.fromRGB(0, 0, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={0}
			></frame>

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

			<frame
				Size={new UDim2(0.5, 0, 0.5, 0)}
				Position={new UDim2(0.5, 0, 0.5, 0)}
				BackgroundColor3={Color3.fromRGB(26, 26, 26)}
				BorderSizePixel={0}
				BackgroundTransparency={0}
				AnchorPoint={new Vector2(0.5, 0.5)}
			>
				<textlabel
					Key={"Title"}
					Text={"Twitter Code"}
					FontSize={Enum.FontSize.Size14}
					Size={new UDim2(1, 0, 0.7, 0)}
					Position={new UDim2(0, 0, 0, 0)}
					BackgroundTransparency={1}
					TextColor3={Color3.fromRGB(255, 255, 255)}
					TextWrapped={true}
				/>
				<textbox
					Text={partyName}
					Size={UDim2.fromScale(0.2, 0.12)}
					Position={UDim2.fromScale(0.3, 0.4)}
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
					Text={buttonText}
					Size={UDim2.fromScale(0.15, 0.12)}
					Position={UDim2.fromScale(0.5, 0.4)}
					TextSize={15}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Font={Enum.Font.SourceSansBold}
					BackgroundColor3={Color3.fromRGB(128, 128, 128)}
					Event={{
						MouseButton1Click: () => {
							if (textBoxValue === "") {
								print("No textbox value");
								print(textBoxValue);
								return;
							}

							setIsRedeeming(true); // Set isRedeeming true here after textBoxValue check
						},
					}}
				/>
				<Close />
			</frame>
		</Panel>
	);
};

export default new Hooks(Roact)(TwitterHUD);
