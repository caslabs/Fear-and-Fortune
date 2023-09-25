import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface VerticalFeatureProps {
	title: string;
	description?: string;
	image?: string;
	imageAlt?: string;
	reverse?: boolean;
	LayoutOrder?: number;
	fontsize?: number;
	yalign?: string;
}

const VerticalFeature: Hooks.FC<VerticalFeatureProps> = (props, { useState }) => {
	return (
		<textlabel
			TextSize={props.fontsize ?? 15}
			TextColor3={Color3.fromRGB(255, 255, 255)}
			BackgroundTransparency={1}
			Size={UDim2.fromScale(0.2, 0.2)}
			Text={props.title}
			LayoutOrder={props.LayoutOrder}
			TextYAlignment={Enum.TextYAlignment.Top}
		></textlabel>
	);
};

export default new Hooks(Roact)(VerticalFeature);
