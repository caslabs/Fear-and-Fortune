import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface HungerBarProps {
	hunger: number;
}

const HungerBar: Hooks.FC<HungerBarProps> = (props, { useState }) => {
	const [isVisible, setIsVisible] = useState(props.hunger < 50);

	useState(() => {
		if (props.hunger === 100 && isVisible) {
			setIsVisible(false);
		} else if (props.hunger < 100 && !isVisible) {
			setIsVisible(true);
		}
	});

	return (
		<textlabel
			Key={"HungerBar"}
			Position={new UDim2(0.06, 0, 0.89, 0)}
			Size={new UDim2(0.02, 0, 0.5, 0)}
			AnchorPoint={new Vector2(0.5, 1)}
			BackgroundColor3={new Color3(1, 1, 1)}
			BackgroundTransparency={1}
			Text={""}
		>
			<textlabel
				Text={""}
				Size={new UDim2(1, 0, props.hunger / 100, 0)}
				BackgroundTransparency={0.8}
				Visible={true}
				BackgroundColor3={Color3.fromRGB(205, 133, 63)}
				BorderSizePixel={0}
				AnchorPoint={new Vector2(0.5, 1)}
				Position={new UDim2(0.5, 0, 1, 0)}
			/>
			<imagelabel
				Image="rbxassetid://9432891155" // replace with your actual asset id
				AnchorPoint={new Vector2(0.5, 0)}
				Position={new UDim2(0.5, 0, 1, 0)}
				Size={new UDim2(1, 0, 0.1, 0)} // adjust size as per your need
				BackgroundTransparency={1}
				ImageTransparency={0.5}
			/>
		</textlabel>
	);
};

export default new Hooks(Roact)(HungerBar);
