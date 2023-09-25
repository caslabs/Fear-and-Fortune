import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { SocialService, Players } from "@rbxts/services";
import { Context, Pages } from "ui/routers/Lobby/Context-LobbyHUD";

interface TutorialProp {}

// Opens Friend Social Service GUI
const TutorialButton: Hooks.FC<TutorialProp> = (props, { useState }) => {
	const [buttonText, setButtonText] = useState("Play Tutorial");
	return (
		<Context.Consumer
			render={(value: { viewIndex: number; setPage: (index: number) => void }) => {
				return (
					<frame
						Key={"TutorialButton"}
						Size={UDim2.fromScale(0.1, 0.045)}
						Position={new UDim2(0.34, 0, 0.011, 0)}
						AnchorPoint={new Vector2(0, 0)}
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
							Text={buttonText}
							FontSize={Enum.FontSize.Size8}
							Size={UDim2.fromScale(1, 1)}
							BorderSizePixel={0}
							BackgroundColor3={Color3.fromRGB(0, 0, 0)}
							ZIndex={5}
							BackgroundTransparency={0.5}
							TextColor3={Color3.fromRGB(255, 255, 255)}
							Event={{
								MouseButton1Click: () => {
									// Open Tutorial Panel
									const index = Pages.tutorial;
									if (value.viewIndex === index) {
										value.setPage(1);
									} else {
										value.setPage(index);
									}
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
			}}
		></Context.Consumer>
	);
};

export default new Hooks(Roact)(TutorialButton);
