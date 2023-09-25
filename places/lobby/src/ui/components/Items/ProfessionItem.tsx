import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Theme from "ui/theme";

interface ItemProps {
	title: string;
	desc?: string;
	color?: Color3;
	layoutOrder?: number;
	active: boolean; // Add active state
	onClick: () => void; // Add an onClick event
	isLocked: boolean;
}

const ProfessionItem: Hooks.FC<ItemProps> = (props, { useState }) => {
	const [promptVisible, setPromptVisible] = useState(false);

	return (
		<textbutton
			Key={"Item"}
			Text={props.title} // Show the title on the button
			BackgroundColor3={props.active ? Color3.fromRGB(60, 60, 60) : Color3.fromRGB(45, 45, 45)} // Change color if active
			LayoutOrder={props.layoutOrder ?? 1}
			Event={{
				MouseButton1Click: props.onClick, // Use the passed onClick function
			}}
			TextColor3={props.active ? Color3.fromRGB(255, 255, 255) : Color3.fromRGB(200, 200, 200)} // Change text color if active
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
			<uipadding
				PaddingTop={new UDim(0, 6)}
				PaddingBottom={new UDim(0, 6)}
				PaddingLeft={new UDim(0, 6)}
				PaddingRight={new UDim(0, 6)}
			/>
			<textlabel
				Key={"Desc"}
				Size={UDim2.fromScale(1, 1)} // Change to scale, so it fills the entire button
				Text={props.desc ?? ""}
				BorderSizePixel={0}
				BackgroundTransparency={1}
				TextColor3={Color3.fromRGB(255, 255, 255)}
				Font={Theme.FontNormal}
				TextSize={18}
				AutomaticSize={"Y"}
				TextWrapped={true}
				Visible={promptVisible}
			/>
		</textbutton>
	);
};

export default new Hooks(Roact)(ProfessionItem);
