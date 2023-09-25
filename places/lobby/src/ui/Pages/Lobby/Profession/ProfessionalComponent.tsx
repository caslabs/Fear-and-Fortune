import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface ProfessionalComponentProps {
	title: string;
	active: boolean;
	desc?: string;
	color?: Color3;
	layoutOrder?: number;
	audio?: string;
	onClick: () => void;
}

// // Generic item component that gets reused in all of the pages
const ProfessionComponent: Hooks.FC<ProfessionalComponentProps> = (props, { useState }) => {
	const [promptVisible, setPromptVisible] = useState(false);
	return (
		<textbutton
			Key={"Item"}
			Text={""}
			BackgroundColor3={props.active ? Color3.fromRGB(235, 79, 18) : Color3.fromRGB(107, 105, 105)}
			LayoutOrder={props.layoutOrder ?? 1}
			Event={{
				MouseEnter: () => setPromptVisible(true),
				MouseButton1Click: () => {
					//TODO: Make a System - also 7 second audio with stop between clicks
					const sound = new Instance("Sound");
					sound.SoundId = "rbxassetid://" + props.audio;
					sound.Parent = game.GetService("SoundService");
					sound.Volume = 0.5;
					sound.Play();
					props.onClick();
				},
				MouseLeave: () => setPromptVisible(false),
			}}
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
			<uipadding
				PaddingTop={new UDim(0, 6)}
				PaddingBottom={new UDim(0, 6)}
				PaddingLeft={new UDim(0, 6)}
				PaddingRight={new UDim(0, 6)}
			/>
			<textlabel
				Key={"Title"}
				Text={props.title}
				Size={new UDim2(1, 0, 0, 30)}
				BackgroundTransparency={0.9}
				TextColor3={Color3.fromRGB(255, 255, 255)}
				TextSize={24}
				AutomaticSize={"Y"}
				TextWrapped={true}
			/>
			<textlabel
				Key={"Desc"}
				Size={new UDim2(1, 0, 1, -74)}
				Text={props.desc ?? ""}
				Position={UDim2.fromScale(0, 0.5)}
				AnchorPoint={new Vector2(0, 0.5)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				TextColor3={Color3.fromRGB(255, 255, 255)}
				TextSize={18}
				TextWrapped={true}
				Visible={promptVisible}
				AutomaticSize={"Y"}
			></textlabel>
		</textbutton>
	);
};

export default new Hooks(Roact)(ProfessionComponent);
