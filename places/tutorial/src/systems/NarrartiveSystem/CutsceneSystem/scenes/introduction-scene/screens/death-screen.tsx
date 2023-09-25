import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import RoactSpring from "@rbxts/roact-spring";
import { RunService } from "@rbxts/services";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { Signals } from "shared/signals";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";

interface DeathProp {
	description: string;
}

const DeathScreen: Hooks.FC<DeathProp> = (props, hooks) => {
	let isMounted = true;
	const [text, setText] = hooks.useState("");
	const [fullText, setFullText] = hooks.useState(props.description);
	const speed = 0.21;
	const waitTime = speed * fullText.size() + 1;

	const warningStyle = RoactSpring.useSpring(hooks, {
		from: { transparency: 0 } as any,
		to: { transparency: 0 } as any,
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

	return (
		<frame Key={"DeathScene"} Size={UDim2.fromScale(1, 1)} BackgroundTransparency={1} LayoutOrder={99999}>
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
					TextTransparency={warningStyle.transparency as any}
					BackgroundColor3={Color3.fromRGB(0, 0, 0)}
					ZIndex={11}
				/>
			</frame>
		</frame>
	);
};

export = new Hooks(Roact)(DeathScreen);
