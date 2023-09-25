import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Theme from "ui/theme";

interface ItemProps {
	title: string;
	desc?: string;
	color?: Color3;
	layoutOrder?: number;
}

// Empty Functional Hook Component for development purposes
const PurchaseItem: Hooks.FC<ItemProps> = (props, { useState }) => {
	const [promptVisible, setPromptVisible] = useState(false);

	return (
		<textbutton
			Key={"Item"}
			Text={""}
			BackgroundColor3={Color3.fromRGB(107, 105, 105)}
			LayoutOrder={props.layoutOrder ?? 1}
			Event={{
				MouseEnter: () => setPromptVisible(true),
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
				Font={Theme.FontPrimary}
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
				Font={Theme.FontNormal}
				TextSize={18}
				AutomaticSize={"Y"}
				TextWrapped={true}
				Visible={promptVisible}
			></textlabel>
			<textbutton Position={UDim2.fromOffset(0, 100)} Size={UDim2.fromScale(1, 0.2)} Text={"Purchase"}>
				<uicorner CornerRadius={new UDim(0, 6)} />
			</textbutton>
		</textbutton>
	);
};

export default new Hooks(Roact)(PurchaseItem);
