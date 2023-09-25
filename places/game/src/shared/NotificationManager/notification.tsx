/* eslint-disable @typescript-eslint/no-explicit-any */
import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import RoactSpring from "@rbxts/roact-spring";

interface NotificationProps {
	title: string;
	description: string;
	image: string;
}

// TODO connect to remote event listener: triggers function code onClick`
const Notification: Hooks.FC<NotificationProps> = (props, hooks) => {
	const [isClosing, setClosing] = hooks.useState(false);

	const styles = RoactSpring.useSpring(hooks, {
		to: { transparency: isClosing ? 1 : 0 } as any,
		config: { mass: 1, tension: 280, friction: 60 } as any,
	});

	hooks.useEffect(() => {
		let isMounted = true; // Add this line

		spawn(function () {
			wait(4);
			if (isMounted) {
				// Check if component is still mounted
				setClosing(true);
			}
		});

		return () => {
			isMounted = false; // Set isMounted to false when component is unmounted
		};
	});

	return (
		<frame
			Key={"ItemPopupText"}
			Size={new UDim2(0.5, 0, 0.2, 0)}
			Position={new UDim2(0.25, 0, 0.6, 0)}
			AnchorPoint={new Vector2(0, 0)}
			BackgroundColor3={Color3.fromRGB(0, 0, 0)}
			BackgroundTransparency={styles.transparency as any}
		>
			<uilistlayout
				SortOrder={"LayoutOrder"}
				FillDirection={"Horizontal"}
				HorizontalAlignment={"Left"}
			></uilistlayout>
			<uipadding PaddingTop={new UDim(0, 10)}></uipadding>
			<imagelabel
				Key={"ItemPopupImage"}
				BackgroundTransparency={1}
				Image={props.image}
				Size={UDim2.fromScale(0.2, 1)}
				LayoutOrder={-1}
				ImageTransparency={styles.transparency as any}
			/>
			<frame BackgroundTransparency={1} Size={new UDim2(0.8, 0, 1, 0)}>
				<uilistlayout FillDirection={"Vertical"} HorizontalAlignment={"Left"}></uilistlayout>
				<textlabel
					TextSize={25}
					BackgroundTransparency={1}
					TextTransparency={styles.transparency as any}
					Size={new UDim2(1, 0, 0, 30)}
					Text={props.title}
					TextColor3={new Color3(1, 1, 1)}
					TextXAlignment={"Left"}
					TextYAlignment={"Bottom"}
					TextWrapped={true}
					TextScaled={true}
				></textlabel>
				<textlabel
					TextSize={15}
					BackgroundTransparency={1}
					TextTransparency={styles.transparency as any}
					Size={new UDim2(1, 0, 0.7, 0)}
					TextColor3={new Color3(1, 1, 1)}
					Text={props.description}
					TextXAlignment={"Left"}
					TextYAlignment={"Center"}
					TextWrapped={true}
					TextScaled={true}
				></textlabel>
			</frame>
		</frame>
	);
};

export = new Hooks(Roact)(Notification);
