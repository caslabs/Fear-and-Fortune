import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Counter from "./counter";

interface CurrencyProps {}

// Currency Component
const Currency: Hooks.FC<CurrencyProps> = (props, { useState }) => {
	const [coinCurrency, setCoinCurrency] = useState(0);
	const [diamondCurrency, setDiamondCurrency] = useState(0);
	return (
		<frame
			Key={"Currency"}
			Size={UDim2.fromOffset(160, 40)}
			Position={new UDim2(0.99, 0, 0.9, 1)}
			AnchorPoint={new Vector2(1, 0.5)}
			BackgroundTransparency={1}
			ZIndex={0}
		>
			<uilistlayout
				Key={"Layout"}
				Padding={new UDim(0, 5)}
				FillDirection={"Vertical"}
				VerticalAlignment={"Center"}
				SortOrder={"LayoutOrder"}
			/>
			<Counter img={"http://www.roblox.com/asset/?id=4743559705"} amount={coinCurrency} />
			<Counter img={"http://www.roblox.com/asset/?id=3073836306"} amount={diamondCurrency} />
		</frame>
	);
};

export default new Hooks(Roact)(Currency);
