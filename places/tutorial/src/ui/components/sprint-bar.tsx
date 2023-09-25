import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface SprintBarProps {
	staminaD: number;
}

const SprintBar: Hooks.FC<SprintBarProps> = (props, { useState }) => {
	const [isVisible, setIsVisible] = useState(props.staminaD < 50);

	useState(() => {
		if (props.staminaD === 100 && isVisible) {
			setIsVisible(false);
		} else if (props.staminaD < 100 && !isVisible) {
			setIsVisible(true);
		}
	});

	return (
		<textlabel
			Position={new UDim2(0.5, 0, 1, 0)}
			Size={new UDim2(0.5, 0, 0.02, 0)}
			AnchorPoint={new Vector2(0.5, 1)}
			BackgroundColor3={new Color3(1, 1, 1)}
			BackgroundTransparency={1}
			Text={""}
		>
			<textlabel
				Text={""}
				Size={new UDim2(props.staminaD / 100, 0, 1, 0)}
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

export default new Hooks(Roact)(SprintBar);
