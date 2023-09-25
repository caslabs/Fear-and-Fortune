/* eslint-disable @typescript-eslint/no-explicit-any */
import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import RoactSpring from "@rbxts/roact-spring";

interface ItemPopupProps {
	title: string;
	description: string;
	image: string;
}

// TODO connect to remote event listener: triggers function code onClick`
const DialogBox: Hooks.FC<ItemPopupProps> = (props, hooks) => {
	const [isClosing, setClosing] = hooks.useState(false);

	const styles = RoactSpring.useSpring(hooks, {
		to: { transparency: isClosing ? 1 : 0 } as any,
		config: { mass: 1, tension: 280, friction: 60 } as any,
	});

	let isMounted = true;

	hooks.useEffect(() => {
		const closingTask = spawn(function () {
			wait(4);
			if (isMounted) {
				setClosing(true);
			}
		});

		return () => {
			isMounted = false;
		};
	}, []);

	const [text, setText] = hooks.useState("");
	const [fullText, setFullText] = hooks.useState(props.description);
	print("DialogBox initialized");

	//TODO: Polish text animation
	hooks.useEffect(() => {
		let tempText = "";
		const textAnimCoroutine = coroutine.wrap(() => {
			for (const char of fullText) {
				tempText += char;
				if (isMounted) {
					setText(tempText);
				}
				task.wait(0.02);
			}
		});
		textAnimCoroutine();

		return () => {
			isMounted = false;
		};
	}, [fullText]);

	return (
		<frame
			Key={"DialogueBox"}
			Size={new UDim2(0.5, 0, 0.2, 0)}
			Position={new UDim2(0.25, 0, 0.75, 0)}
			AnchorPoint={new Vector2(0, 0)}
			BackgroundTransparency={1}
		>
			<textlabel
				TextSize={15}
				BackgroundTransparency={1}
				TextTransparency={styles.transparency as any}
				Size={new UDim2(1, 0, 0.8, 0)} // Adjusted size
				TextColor3={new Color3(1, 1, 1)}
				Text={text}
				TextXAlignment={"Left"}
				TextYAlignment={"Top"} // Adjusted alignment
				TextWrapped={true}
				TextScaled={false}
				Font={Enum.Font.JosefinSans}
			></textlabel>
		</frame>
	);
};

export = new Hooks(Roact)(DialogBox);
