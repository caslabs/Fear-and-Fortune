import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import RoactSpring from "@rbxts/roact-spring";

interface NotificationProps {
	title: string;
}

const Notification: Hooks.FC<NotificationProps> = (props, hooks) => {
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
				wait(3); // Duration of display before starting fade-out
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
			Key={"NotificationPopup"}
			Size={new UDim2(0.5, 0, 0.2, 0)}
			Position={new UDim2(0.5, 0, 0.4, 0)}
			AnchorPoint={new Vector2(0.5, 1)}
			BackgroundTransparency={1}
			LayoutOrder={-999}
		>
			<textlabel
				Key={"NotificationText"}
				TextSize={25}
				BackgroundTransparency={1}
				TextTransparency={styles.transparency as any}
				Size={new UDim2(1, 0, 0, 30)}
				Text={props.title}
				TextColor3={new Color3(1, 1, 1)}
				TextXAlignment={"Center"}
				TextYAlignment={"Bottom"}
				TextWrapped={true}
				TextScaled={true}
				Font={Enum.Font.Merriweather}
				ZIndex={-999}
			></textlabel>
		</frame>
	);
};

export = new Hooks(Roact)(Notification);
