import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import Theme from "ui/theme";

interface ContextHotbarMenuProps {
	visible: boolean;
	position: UDim2;
	item: string;
	onClose: () => void;
}

const DropItemFromInventoryEvent = Remotes.Client.Get("DropItemFromInventory");
const EquipItemFromInventoryEvent = Remotes.Client.Get("EquipItemFromInventory");

const ContextHotbarMenu: Hooks.FC<ContextHotbarMenuProps> = (props) => {
	return (
		<frame BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
			{props.visible && (
				<frame
					Key={"ContextHotbarMenu"}
					Size={new UDim2(0, 150, 0, 100)}
					Position={props.position}
					BackgroundColor3={Color3.fromRGB(60, 60, 60)}
					ZIndex={10}
				>
					<textbutton
						Key={"Drop"}
						Size={new UDim2(1, 0, 0.5, 0)}
						BackgroundColor3={Color3.fromRGB(60, 60, 60)}
						TextColor3={Color3.fromRGB(200, 200, 200)}
						Text={"Drop"}
						ZIndex={11}
						Event={{
							MouseButton1Click: () => {
								print("Drop");
								Signals.DropTool.Fire(props.item);

								props.onClose();
							},
						}}
					/>
				</frame>
			)}
		</frame>
	);
};

export default new Hooks(Roact)(ContextHotbarMenu);
