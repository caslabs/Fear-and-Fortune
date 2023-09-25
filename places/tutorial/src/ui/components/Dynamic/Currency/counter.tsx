import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { AutoTextLabel } from "../TextLabel";

interface CounterProps {
	img: string;
	amount: number;
}

const Counter: Hooks.FC<CounterProps> = (props, { useState }) => {
	return (
		<frame
			Key={"Diamond"}
			Size={UDim2.fromOffset(160, 40)}
			Position={new UDim2(0.98, 0, 0.9, 1)}
			AnchorPoint={new Vector2(1, 0.5)}
			BackgroundTransparency={0.9}
			BackgroundColor3={Color3.fromRGB(0, 0, 0)}
			ZIndex={0}
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
			<uipadding
				PaddingTop={new UDim(0, 6)}
				PaddingBottom={new UDim(0, 6)}
				PaddingLeft={new UDim(0, 6)}
				PaddingRight={new UDim(0, 6)}
			/>
			<uilistlayout
				SortOrder={Enum.SortOrder.LayoutOrder}
				FillDirection={"Horizontal"}
				Padding={new UDim(0, 6)}
				HorizontalAlignment={"Center"}
			/>
			<imagelabel
				Key={"Icon"}
				Image={props.img}
				Size={UDim2.fromScale(1, 1)}
				BackgroundTransparency={1}
				LayoutOrder={1}
				ZIndex={0}
			>
				<uiaspectratioconstraint AspectRatio={1} />
			</imagelabel>
			<AutoTextLabel
				Size={UDim2.fromScale(1, 1)}
				TextSize={36}
				Font={Enum.Font.SourceSansSemibold}
				BackgroundTransparency={1}
				Text={tostring(props.amount)}
				LayoutOrder={2}
				TextColor3={Color3.fromRGB(255, 255, 255)}
				ZIndex={0}
			/>
		</frame>
	);
};

export default new Hooks(Roact)(Counter);
