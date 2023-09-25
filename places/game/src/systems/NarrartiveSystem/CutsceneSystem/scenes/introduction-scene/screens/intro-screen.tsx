import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import RoactSpring from "@rbxts/roact-spring";
import { RunService } from "@rbxts/services";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { Signals } from "shared/signals";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";

interface IntroProp {
	description: string;
}

const IntroScreen: Hooks.FC<IntroProp> = (props, hooks) => {
	const [isLoading, setIsLoading] = hooks.useState("Awaiting Players");

	hooks.useEffect(() => {
		const isRunning = true;
		let loadingCounter = 0;
		const updateLoading = async () => {
			while (isRunning) {
				loadingCounter = (loadingCounter + 1) % 4; // Make loadingCounter cycle from 0 to 3
				let dots = "";
				for (let i = 0; i < loadingCounter; i++) {
					dots += ".";
				}
				const loadingText = "Awaiting Players" + dots;
				setIsLoading(loadingText);
				await Promise.delay(0.5); // update every 500ms
			}
		};

		const handleEffect = async () => {
			// Start animation
			updateLoading();
		};

		handleEffect();
	}, []); // <-- Pass an empty array here to ensure this code runs only once

	hooks.useEffect(() => {
		// Temporary hack? Hides the mouse for the duration of the animation
		const startTime = tick(); // Get the current time
		let connection: RBXScriptConnection; // Declare a variable for the connection

		// Create a connection to the Stepped event
		connection = RunService.Stepped.Connect(() => {
			if (tick() - startTime >= 7) {
				// If waitTime seconds have passed
				Signals.finishedIntroduction.Fire();
				connection.Disconnect(); // Disconnect the connection to the Stepped event
			}
		});

		// Clean up function to disconnect the Stepped event if the component unmounts before it fires
		return () => connection.Disconnect();
	}, []);
	return (
		<frame Key={"IntroScene"} Size={UDim2.fromScale(1, 1)} BackgroundTransparency={0} LayoutOrder={99999}>
			<frame
				Key="WarningFrame"
				Size={UDim2.fromScale(1, 1)}
				BackgroundTransparency={0}
				ZIndex={10}
				BackgroundColor3={Color3.fromRGB(0, 0, 0)}
			>
				<textlabel
					Key="WarningText"
					Size={UDim2.fromScale(1, 1)}
					BackgroundTransparency={0}
					Text={isLoading}
					TextColor3={new Color3(1, 1, 1)}
					TextWrapped={true}
					FontSize={Enum.FontSize.Size12}
					BackgroundColor3={Color3.fromRGB(0, 0, 0)}
					ZIndex={11}
				/>
			</frame>
		</frame>
	);
};

export = new Hooks(Roact)(IntroScreen);
