import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Signals } from "shared/signals";

interface DrinkBarProps {
	durationD: number;
	isVisible: boolean;
}

const DrinkBar: Hooks.FC<DrinkBarProps> = (props, { useState, useEffect }) => {
	const [isVisible, setIsVisible] = useState(false);
	const [duration, setDuration] = useState(0);

	useEffect(() => {
		// listen to drink bar events
		const showDrinkBarConnection = Signals.showDrinkBar.Connect((isVisible: boolean) => {
			setIsVisible(isVisible);
		});

		const updateDrinkBar = Signals.updateDrinkBar.Connect((duration: number) => {
			if (duration === 100) {
				setDuration(0);
			} else {
				setDuration(duration);
			}
		});

		return () => {
			showDrinkBarConnection.Disconnect();
			updateDrinkBar.Disconnect();
		};
	}, []);

	return (
		<textlabel
			Position={new UDim2(0.5, 0, 0.85, 0)}
			Size={new UDim2(0.5, 0, 0.02, 0)}
			AnchorPoint={new Vector2(0.5, 1)}
			BackgroundColor3={new Color3(1, 1, 1)}
			BackgroundTransparency={1}
			Text={""}
			Visible={isVisible}
		>
			<textlabel
				Text={""}
				Size={new UDim2(duration / 100, 0, 1, 0)}
				BackgroundTransparency={0.8}
				Visible={true}
				BackgroundColor3={new Color3(0.8, 0.84, 0.8)}
				BorderSizePixel={0}
				AnchorPoint={new Vector2(0.5, 0.5)}
				Position={new UDim2(0.5, 0, 0, 0)}
			/>
		</textlabel>
	);
};

export default new Hooks(Roact)(DrinkBar);
