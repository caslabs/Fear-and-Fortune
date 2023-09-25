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
	let isMounted = true;
	const [text, setText] = hooks.useState("");
	const [fullText, setFullText] = hooks.useState(props.description);
	const speed = 0.17;
	const waitTime = speed * fullText.size() + 1;

	const warningStyle = RoactSpring.useSpring(hooks, {
		from: { transparency: 0 } as any,
		to: { transparency: 1 } as any,
		delay: waitTime as any,
		config: { mass: 1, tension: 280, friction: 60 } as any,
	});

	//TODO: Polish text animation
	hooks.useEffect(() => {
		let tempText = "";
		const textAnimCoroutine = coroutine.wrap(() => {
			for (const char of fullText) {
				tempText += char;
				if (isMounted) {
					setText(tempText);
				}
				SoundSystemController.playSound(SoundKeys.SFX_TYPEWRITER);
				task.wait(speed);
			}
		});
		textAnimCoroutine();

		return () => {
			isMounted = false;
		};
	}, [fullText]);

	hooks.useEffect(() => {
		// Temporary hack? Hides the mouse for the duration of the animation
		const startTime = tick(); // Get the current time
		let connection: RBXScriptConnection; // Declare a variable for the connection

		// Create a connection to the Stepped event
		connection = RunService.Stepped.Connect(() => {
			if (tick() - startTime >= waitTime) {
				// If waitTime seconds have passed
				Signals.finishedIntroduction.Fire();
				connection.Disconnect(); // Disconnect the connection to the Stepped event
			}
		});

		// Clean up function to disconnect the Stepped event if the component unmounts before it fires
		return () => connection.Disconnect();
	}, []);
	return (
		<frame Key={"IntroScene"} Size={UDim2.fromScale(1, 1)} BackgroundTransparency={1} LayoutOrder={99999}>
			<frame
				Key="WarningFrame"
				Size={UDim2.fromScale(1, 1)}
				BackgroundTransparency={warningStyle.transparency as any}
				ZIndex={10}
			>
				<textlabel
					Key="WarningText"
					Size={UDim2.fromScale(1, 1)}
					BackgroundTransparency={warningStyle.transparency as any}
					Text={text}
					TextColor3={new Color3(1, 1, 1)}
					TextWrapped={true}
					FontSize={Enum.FontSize.Size12}
					TextTransparency={warningStyle.transparency as any}
					BackgroundColor3={Color3.fromRGB(0, 0, 0)}
					ZIndex={11}
				/>
			</frame>
		</frame>
	);
};

export = new Hooks(Roact)(IntroScreen);
