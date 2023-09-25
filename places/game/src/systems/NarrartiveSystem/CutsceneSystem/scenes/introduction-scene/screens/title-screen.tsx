import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { UserInputService } from "@rbxts/services";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import { Context, Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";
import WarningScreen from "./splash-screen";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import { MusicKeys } from "systems/AudioSystem/MusicSystem/manager/MusicData";
interface TitleScreenProps {
	visible?: boolean;
}

//Post Event Screen

//TODO: Make a META file for info of the game

const TitleScreen: Hooks.FC<TitleScreenProps> = (props, { useState, useEffect }) => {
	// The ratio of the screen's height occupied by each bar
	const barHeightRatio = 0.1;
	print("Initiated Title Screen");
	const [isLoading, setIsLoading] = useState("LOADING");

	useEffect(() => {
		let isRunning = true;
		let loadingCounter = 0;
		const updateLoading = async () => {
			while (isRunning) {
				loadingCounter = (loadingCounter + 1) % 4; // Make loadingCounter cycle from 0 to 3
				let dots = "";
				for (let i = 0; i < loadingCounter; i++) {
					dots += ".";
				}
				const loadingText = "LOADING" + dots;
				setIsLoading(loadingText);
				await Promise.delay(0.5); // update every 500ms
			}
		};

		const handleEffect = async () => {
			// Start animation
			updateLoading();

			// Start Timer
			// 10 seconds for warning screen
			await Promise.delay(10);
			MusicSystemController.playMusic(MusicKeys.INTRODUCTION_MUSIC);

			// 14 seconds for title screen
			await Promise.delay(17);
			isRunning = false; // stop the loading animation
			setIsLoading("Press any button to play");
			const connection = UserInputService.InputBegan.Connect(() => {
				// Disconnect the event before switching to the play HUD
				connection.Disconnect();
				SoundSystemController.playSound(SoundKeys.UI_CLOSE);
				MusicSystemController.stopMusic(MusicKeys.INTRODUCTION_MUSIC);
				Signals.finishedTitleScreen.Fire();
			});
		};

		handleEffect();
	}, []); // <-- Pass an empty array here to ensure this code runs only once
	return (
		<Context.Consumer
			render={(value: { viewIndex: number; setPage: (index: number) => void }) => {
				return (
					<Panel index={Pages.titleScreen} visible={props.visible}>
						<WarningScreen />
						<frame
							Size={new UDim2(1, 0, barHeightRatio, 0)}
							Position={new UDim2(0, 0, 0, 0)}
							BackgroundColor3={new Color3(0, 0, 0)}
							BorderSizePixel={0}
						/>
						<frame
							Size={new UDim2(1, 0, barHeightRatio, 0)}
							Position={new UDim2(0, 0, 1 - barHeightRatio, 0)}
							BackgroundColor3={new Color3(0, 0, 0)}
							BorderSizePixel={0}
						>
							<textlabel
								BackgroundTransparency={1}
								TextColor3={new Color3(255, 255, 255)}
								AnchorPoint={new Vector2(0.5, 0)}
								Position={new UDim2(0.5, 0, 0, 0)}
								Text={isLoading}
								Font={Enum.Font.Merriweather}
								FontSize={Enum.FontSize.Size14}
								Size={new UDim2(0, 0, 1, 0)}
							/>
							<textlabel
								Text={"The Yeti of Mount Everest"}
								Size={new UDim2(0.3, 0, 13, 0)}
								Position={new UDim2(0, 30, 2.5, 0)}
								BackgroundTransparency={1}
								TextColor3={new Color3(1, 1, 1)}
								FontSize={Enum.FontSize.Size42}
								AnchorPoint={new Vector2(0, 1)}
								TextWrapped={true}
								TextScaled={true}
								Font={Enum.Font.GothamBold}
							/>
						</frame>
					</Panel>
				);
			}}
		></Context.Consumer>
	);
};

export default new Hooks(Roact)(TitleScreen);
