import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface FooterProps {
	title: string;
	LayoutOrder?: number;
}

const Footer: Hooks.FC<FooterProps> = (props, { useState }) => {
	return (
		<textlabel
			TextSize={9}
			TextColor3={Color3.fromRGB(255, 255, 255)}
			BackgroundTransparency={1}
			Size={UDim2.fromScale(0.2, 0.2)}
			Text={props.title}
			LayoutOrder={props.LayoutOrder}
			TextYAlignment={"Bottom"}
		></textlabel>
	);
};

export default new Hooks(Roact)(Footer);
