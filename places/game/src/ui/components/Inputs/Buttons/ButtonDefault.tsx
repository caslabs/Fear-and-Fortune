import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Theme from "ui/theme";

interface DefaultButtonProps {
	onClick: () => void;
	text: string;
	layout: number;
	Size?: UDim2;
}

// A generic Default Button
const DefaultButton: Hooks.FC<DefaultButtonProps> = (props, { useState }) => {
	return (
		<textbutton
			Key={"Button"}
			Text={props.text}
			FontSize={Enum.FontSize.Size24}
			Font={Theme.FontPrimary}
			Size={props.Size ?? new UDim2(0.5, 0, 0.2, 0)}
			Position={new UDim2(0.25, 0, 0.7, 0)}
			BorderSizePixel={0}
			LayoutOrder={props.layout}
			Event={{
				MouseButton1Click: () => props.onClick(),
			}}
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
			<uipadding
				PaddingTop={new UDim(0, 6)}
				PaddingBottom={new UDim(0, 6)}
				PaddingLeft={new UDim(0, 6)}
				PaddingRight={new UDim(0, 6)}
			/>
		</textbutton>
	);
};

export default new Hooks(Roact)(DefaultButton);
