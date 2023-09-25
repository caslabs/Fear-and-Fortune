import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface SectionProps {
	title: string;
	description: string;
	LayoutOrder?: number;
}

const Section: Hooks.FC<SectionProps> = (props, { useState }) => {
	return (
		<frame
			LayoutOrder={props.LayoutOrder}
			Key={"Section"}
			//TODO: Fix Size
			Size={UDim2.fromScale(1, 1.2)}
			BackgroundTransparency={1}
		>
			<uilistlayout
				VerticalAlignment={"Top"}
				FillDirection={"Vertical"}
				HorizontalAlignment={"Center"}
				SortOrder={"LayoutOrder"}
			></uilistlayout>
			<textlabel
				TextSize={36}
				TextColor3={Color3.fromRGB(255, 255, 255)}
				BackgroundTransparency={1}
				Size={UDim2.fromScale(0.2, 0.2)}
				Text={props.title}
				LayoutOrder={1}
			></textlabel>
			<textlabel
				TextSize={12}
				BackgroundTransparency={1}
				Size={UDim2.fromScale(0.2, 0.1)}
				Text={props.description}
				LayoutOrder={2}
				TextYAlignment={"Top"}
			></textlabel>
			{props[Roact.Children]}
		</frame>
	);
};

export default new Hooks(Roact)(Section);
