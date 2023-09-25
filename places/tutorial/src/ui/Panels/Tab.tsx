import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";

interface TabProps {
	onClick: (page: string) => void;
	page: string;
	text: string;
	active: boolean;
}

// Tab component used for swapping tabs in pages
const Tab: Hooks.FC<TabProps> = (props, { useState }) => {
	return (
		<textbutton
			Key={"Tab"}
			Text={props.text}
			Size={UDim2.fromOffset(100, 40)}
			BackgroundColor3={props.active ? Color3.fromRGB(54, 54, 54) : Color3.fromRGB(107, 105, 105)}
			BorderSizePixel={0}
			TextSize={24}
			ZIndex={2}
			AutomaticSize={"X"}
			Font={Enum.Font.SourceSansBold}
			Event={{
				MouseButton1Click: () => {
					props.onClick(props.page);
					SoundSystemController.playSound(SoundKeys.UI_CLOSE);
				},
			}}
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
		</textbutton>
	);
};

export default new Hooks(Roact)(Tab);
