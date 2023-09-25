import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import RoactSpring from "@rbxts/roact-spring";

interface DayIndicatorProps {
	title: string;
}

const DayIndicator: Hooks.FC<DayIndicatorProps> = (props, hooks) => {
	const [isClosing, setClosing] = hooks.useState(false);
	const [isOpening, setOpening] = hooks.useState(true);

	const styles = RoactSpring.useSpring(hooks, {
		to: {
			transparency: isClosing ? 1 : isOpening ? 1 : 0,
		} as any,
		config: { mass: 1, tension: 280, friction: 60 } as any,
	});

	hooks.useEffect(() => {
		let isMounted = true;

		spawn(function () {
			wait(1); // Duration of fade-in
			if (isMounted) {
				setOpening(false);
			}
		});

		return () => {
			isMounted = false;
		};
	}, []);

	hooks.useEffect(() => {
		let isMounted = true;

		if (!isOpening) {
			spawn(function () {
				wait(100); // Duration of display before starting fade-out
				if (isMounted) {
					setClosing(true);
				}
			});
		}

		return () => {
			isMounted = false;
		};
	}, [isOpening]);

	return (
		<frame
			Key={"DayIndicatorPopup"}
			Size={new UDim2(1, 0, 1, 0)}
			Position={new UDim2(0, 0, 0, 0)}
			AnchorPoint={new Vector2(0, 0)}
			BackgroundTransparency={0}
			BackgroundColor3={new Color3(0, 0, 0)}
			LayoutOrder={999}
		>
			<textlabel
				Key={"DayIndicatorText"}
				TextSize={25}
				BackgroundTransparency={1}
				TextTransparency={styles.transparency as any}
				AnchorPoint={new Vector2(0.5, 0.5)}
				Size={new UDim2(1, 0, 0, 30)}
				Position={new UDim2(0.5, 0, 0.5, 0)}
				Text={props.title}
				TextColor3={new Color3(1, 1, 1)}
				TextXAlignment={"Center"}
				TextYAlignment={"Center"}
				TextWrapped={true}
				TextScaled={true}
				Font={Enum.Font.Merriweather}
				ZIndex={9999999}
			></textlabel>
		</frame>
	);
};

export = new Hooks(Roact)(DayIndicator);
