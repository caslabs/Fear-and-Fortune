import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface CurrencyItemProps {
	amount: number;
}

const CurrencyItem: Hooks.FC<CurrencyItemProps> = (props, { useState }) => {
	return (
		<textbutton
			Key={"CurrencyItem"}
			Text={"+ " + tostring(props.amount)}
			Size={UDim2.fromScale(0.9, 0.1)}
			BorderSizePixel={0}
			TextSize={24}
			Font={Enum.Font.SourceSansBold}
			Event={{
				MouseButton1Click: () => {
					print("Bought");
				},
			}}
		>
			<uicorner CornerRadius={new UDim(0, 6)} />
		</textbutton>
	);
};

export default new Hooks(Roact)(CurrencyItem);
