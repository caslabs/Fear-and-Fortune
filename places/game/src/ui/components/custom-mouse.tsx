import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Signals } from "shared/signals";
import { RunService, Players } from "@rbxts/services";
interface CustomMouseProps {}
const Player = Players.LocalPlayer;

export const CustomMouse: Hooks.FC<CustomMouseProps> = (props, { useState }) => {
	const mouse = Player.GetMouse();
	const [isVisible, setIsVisible] = useState(true);
	const [position, setPosition] = useState(new UDim2(0, mouse.X, 0, mouse.Y));
	const [color, setColor] = useState(new Color3(1, 1, 1));
	useState(() => {
		Signals.hideMouse.Connect(() => {
			setIsVisible(false);
		});

		Signals.showMouse.Connect(() => {
			setIsVisible(true);
		});

		RunService.Stepped.Connect(() => {
			setPosition(new UDim2(0, mouse.X, 0, mouse.Y));
		});
	});

	return (
		<screengui Key={"CustomCursorGui"} DisplayOrder={9999999}>
			<imagelabel
				Key={"CustomCursorIcon"}
				Image={"rbxassetid://5992580992"}
				Size={new UDim2(0, 50, 0, 50)}
				BackgroundTransparency={1}
				ZIndex={9999999}
				AnchorPoint={new Vector2(0.5, 0.5)}
				ImageColor3={color}
				Visible={isVisible}
				Position={position}
			></imagelabel>
		</screengui>
	);
};

export default new Hooks(Roact)(CustomMouse);
