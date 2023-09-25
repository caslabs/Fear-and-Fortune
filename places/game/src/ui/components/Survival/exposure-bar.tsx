import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface ExposureBarProps {
	exposure: number;
}

const ExposureBar: Hooks.FC<ExposureBarProps> = (props, { useState }) => {
	const [isVisible, setIsVisible] = useState(props.exposure < 50);

	useState(() => {
		if (props.exposure === 100 && isVisible) {
			setIsVisible(false);
		} else if (props.exposure < 100 && !isVisible) {
			setIsVisible(true);
		}
	});

	return (
		<textlabel
			Key={"ExposureBar"}
			Position={new UDim2(0.95, 0, 0.05, 0)}
			Size={new UDim2(0.25, 0, 0.02, 0)}
			AnchorPoint={new Vector2(1, 1)}
			BackgroundColor3={new Color3(1, 1, 1)}
			BackgroundTransparency={1}
			Text={""}
		>
			<textlabel
				Text={""}
				Size={new UDim2(props.exposure / 100, 0, 1, 0)}
				BackgroundTransparency={0.8}
				Visible={true}
				BackgroundColor3={Color3.fromRGB(173, 216, 230)}
				BorderSizePixel={0}
				AnchorPoint={new Vector2(1, 1)}
				Position={new UDim2(1, 0, 0.7, 0)}
			/>
			<imagelabel
				Image="rbxassetid://11793738396" // replace with your actual asset id
				AnchorPoint={new Vector2(1, 0.4)}
				Position={new UDim2(1, 0, 0, 0)}
				Size={new UDim2(0.1, 0, 2, 0)} // adjust size as per your need
				BackgroundTransparency={1}
				ImageTransparency={0.5}
			/>
		</textlabel>
	);
};

export default new Hooks(Roact)(ExposureBar);
