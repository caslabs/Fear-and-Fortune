import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

//TODO: Fix the naming convention and system structure
interface toggleState {}
interface ToggleProps {
	onClick: () => void;
	text: string;
	layout: number;
	image?: string;
	caption?: string;
	color?: Color3;
	size?: UDim2;
}

//TODO: Call Sound, rather than spawn sound
const sound = new Instance("Sound", game.Workspace);
sound.SoundId = "rbxassetid://6895079853";
sound.Volume = 1;

// A generic toggle on the side of the screen used to open an associated panel
const Toggle: Hooks.FC<ToggleProps> = (props, { useState }) => {
	return (
		<textbutton
			Key={"Toggle"}
			Text={props.caption}
			Size={props.size ?? UDim2.fromScale(1, 1)}
			BorderSizePixel={0}
			LayoutOrder={props.layout}
			BackgroundTransparency={0.7}
			BackgroundColor3={Color3.fromRGB(0, 0, 0)}
			TextColor3={Color3.fromRGB(255, 255, 255)}
			Event={{
				MouseButton1Click: () => {
					sound.Play();
					props.onClick();
				},
			}}
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
			<uipadding
				PaddingTop={new UDim(0, 6)}
				PaddingBottom={new UDim(0, 6)}
				PaddingLeft={new UDim(0, 6)}
				PaddingRight={new UDim(0, 6)}
			/>
			<imagelabel
				Key={"Icon"}
				Image={props.image}
				Size={UDim2.fromScale(1, 1)}
				AnchorPoint={new Vector2(0.5, 0.5)}
				Position={UDim2.fromScale(0.5, 0.5)}
				BackgroundTransparency={1}
			/>
		</textbutton>
	);
};

export default new Hooks(Roact)(Toggle);
