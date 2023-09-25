import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import CurrencyItem from "./currency-item";

interface CurrencyShopProps {}

// Currency Shop that lists all currency products
const CurrencyShop: Hooks.FC<CurrencyShopProps> = (props, { useState }) => {
	return (
		<frame
			Key="CurrencyShop"
			BorderSizePixel={0}
			BackgroundColor3={Color3.fromRGB(70, 70, 70)}
			Size={UDim2.fromOffset(200, 360)}
		>
			<uilistlayout Padding={new UDim(0, 10)} HorizontalAlignment={"Center"}></uilistlayout>
			<textlabel
				TextColor3={Color3.fromRGB(255, 255, 255)}
				Size={new UDim2(1, 0, 0, 50)}
				BackgroundTransparency={1}
				Text="Currency Shop"
				TextSize={20}
			/>
			<CurrencyItem amount={100} />
			<CurrencyItem amount={500} />
			<CurrencyItem amount={1000} />
			<CurrencyItem amount={5000} />
		</frame>
	);
};

export default new Hooks(Roact)(CurrencyShop);
