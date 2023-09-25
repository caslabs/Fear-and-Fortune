import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Signals } from "shared/signals";
import { RunService, Players } from "@rbxts/services";

interface GunScreenProps {
	ammo: number;
	maxAmmo: number;
}

const Player = Players.LocalPlayer;

export const GunScreen: Hooks.FC<GunScreenProps> = (props, { useState }) => {
	const { ammo, maxAmmo } = props;
	return (
		<screengui Key={"GunScreen"} DisplayOrder={9999999}>
			<textlabel
				Key={"AmmoIndicator"}
				Size={new UDim2(0.2, 0, 0.1, 0)}
				Position={new UDim2(0, 20, 1, -50)} // Adjust the position as needed
				TextScaled={true}
				Font={Enum.Font.SourceSansBold}
				TextColor3={Color3.fromRGB(255, 255, 255)}
				BackgroundTransparency={1}
				Text={`${ammo}/${maxAmmo}`}
				AnchorPoint={new Vector2(0, 1)}
			/>
		</screengui>
	);
};

export default new Hooks(Roact)(GunScreen);
