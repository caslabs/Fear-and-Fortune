import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface ThirstBarProps {
	thirst: number;
}

const ThirstBar: Hooks.FC<ThirstBarProps> = (props, { useState }) => {
	const [isVisible, setIsVisible] = useState(props.thirst < 50);

	useState(() => {
		if (props.thirst === 100 && isVisible) {
			setIsVisible(false);
		} else if (props.thirst < 100 && !isVisible) {
			setIsVisible(true);
		}
	});

	return (
		<textlabel
			Key={"ThirstBar"}
			Position={new UDim2(0.03, 0, 0.89, 0)}
			Size={new UDim2(0.02, 0, 0.5, 0)}
			AnchorPoint={new Vector2(0.5, 1)}
			BackgroundColor3={new Color3(1, 1, 1)}
			BackgroundTransparency={1}
			Text={""}
		>
			<textlabel
				Text={""}
				Size={new UDim2(1, 0, props.thirst / 100, 0)}
				BackgroundTransparency={0.8}
				Visible={true}
				BackgroundColor3={Color3.fromRGB(135, 206, 235)}
				BorderSizePixel={0}
				AnchorPoint={new Vector2(0.5, 1)}
				Position={new UDim2(0.5, 0, 1, 0)}
			/>
			<imagelabel
				Image="rbxassetid://418594604" // replace with your actual asset id
				AnchorPoint={new Vector2(0.5, 0)}
				Position={new UDim2(0.5, 0, 1, 0)}
				Size={new UDim2(1, 0, 0.1, 0)} // adjust size as per your need
				BackgroundTransparency={1}
				ImageTransparency={0.5}
			/>
		</textlabel>
	);
};

export default new Hooks(Roact)(ThirstBar);
