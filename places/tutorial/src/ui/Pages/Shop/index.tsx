import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Pages } from "../../Context";
import CloseShop from "../../Panels/Close-Shop";
import Items from "./items-shop";
import Pets from "./pets-shop";
import Gamepasses from "./gamepass-shop";
import Currencyshop from "./currency-shop";
import { setCurrentTab, getCurrentTab, getPageVisible, setPageVisibleGlob } from "./shop-manager";
import { ItemsList } from "./data/items-list";
import { GamepassesList } from "./data/gamepasses-list";
import { Panel } from "ui/Panels/Panel";
import Tab from "ui/Panels/Tab";
import Inventory from "./inventory";
export interface Data {
	name: string;
	color: Color3;
	desc?: string;
}
interface ShopProps {
	visible?: boolean;
}

const Shop: Hooks.FC<ShopProps> = (props, { useState }) => {
	const [tabChosen, setTabChosen] = useState(getCurrentTab());
	const [pageVisible, setPageVisible] = useState(getPageVisible());
	return (
		<Panel Key={"Shop"} index={Pages.merchant} visible={props.visible}>
			<uilistlayout
				FillDirection={"Horizontal"}
				HorizontalAlignment={"Center"}
				SortOrder={"LayoutOrder"}
				VerticalAlignment={"Center"}
			/>
			<frame
				Key={"Shop"}
				BorderSizePixel={0}
				Size={UDim2.fromOffset(504, 360)}
				AnchorPoint={new Vector2(0.5, 0.5)}
				Position={UDim2.fromScale(0.5, 0.5)}
				BackgroundColor3={Color3.fromRGB(70, 70, 70)}
			>
				<uicorner CornerRadius={new UDim(0, 6)} />
				<uipadding
					PaddingTop={new UDim(0, 12)}
					PaddingBottom={new UDim(0, 12)}
					PaddingLeft={new UDim(0, 12)}
					PaddingRight={new UDim(0, 12)}
				/>
				<CloseShop />
				<frame Key={"Tabs"} Size={new UDim2(1, -46, 0, 40)} BorderSizePixel={0} BackgroundTransparency={1}>
					<uilistlayout FillDirection={"Horizontal"} Padding={new UDim(0, 6)} />
					<Tab
						text="Inventory"
						page="inventory"
						active={"inventory" === tabChosen}
						onClick={(page) => {
							setTabChosen("Inventory");
							setCurrentTab("Inventory");
							setPageVisible(page);
							setPageVisibleGlob(page);
						}}
					/>
					<Tab
						text="Gamepass"
						page="gamepasses"
						active={"Gamepass" === tabChosen}
						onClick={(page) => {
							setTabChosen("Gamepass");
							setCurrentTab("Gamepass");
							setPageVisible(page);
							setPageVisibleGlob(page);
						}}
					/>
				</frame>
				<Inventory visible={pageVisible} data={ItemsList} />
				<Gamepasses visible={pageVisible} data={GamepassesList} />
			</frame>
		</Panel>
	);
};

export default new Hooks(Roact)(Shop);
