import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Players } from "@rbxts/services";
import { Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";
import InventoryItem from "ui/components/inventory-component";
import { InventoryItemData } from "./_inventoryData";
import Remotes from "shared/remotes";

interface InventoryProps {
	visible?: boolean;
	data: Array<InventoryItemData>; // Add this line to declare the data prop
}

const UpdateInventoryEvent = Remotes.Client.Get("UpdateInventory");
print("Inventory loaded");
const Inventory: Hooks.FC<InventoryProps> = (props, { useState, useEffect }) => {
	const [data, setData] = useState<Array<InventoryItemData>>([]);

	useEffect(() => {
		const connection = UpdateInventoryEvent.Connect((player, item, action) => {
			if (player === Players.LocalPlayer) {
				if (action === "add") {
					setData((prevData) => [...prevData, { name: item }]);
				} else if (action === "remove") {
					setData((prevData) => prevData.filter((data) => data.name !== item));
				}
			}
		});

		return () => connection.Disconnect();
	}, []);

	return (
		<Panel Key={"Inventory"} index={Pages.inventory} visible={props.visible}>
			<frame Size={new UDim2(1, 0, 1, 0)} BackgroundColor3={Color3.fromRGB(0, 0, 0)} BackgroundTransparency={0.5}>
				<frame
					Size={new UDim2(0.5, 0, 0.5, 0)}
					Position={new UDim2(0.5, 0, 0.5, 0)}
					AnchorPoint={new Vector2(0.5, 0.5)}
					BackgroundTransparency={1}
				>
					<scrollingframe
						Size={new UDim2(1, 0, 1, 0)}
						BackgroundColor3={Color3.fromRGB(0, 0, 0)}
						BackgroundTransparency={0}
						CanvasSize={new UDim2(2, 0, 2, 0)}
						ScrollBarThickness={6}
					>
						<uigridlayout
							CellSize={new UDim2(0.2, 0, 0.2, 0)}
							FillDirectionMaxCells={4}
							StartCorner={"TopLeft"}
						/>

						{data.map((item) => (
							<InventoryItem Key={item.name} name={item.name} />
						))}
					</scrollingframe>
				</frame>
			</frame>
		</Panel>
	);
};

export default new Hooks(Roact)(Inventory);
