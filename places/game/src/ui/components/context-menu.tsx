import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Remotes from "shared/remotes";
import Theme from "ui/theme";

interface ContextMenuProps {
	visible: boolean;
	position: UDim2;
	item: string;
	onClose: () => void;
}

const DropItemFromInventoryEvent = Remotes.Client.Get("DropItemFromInventory");
const EquipItemFromInventoryEvent = Remotes.Client.Get("EquipItemFromInventory");

const ContextMenu: Hooks.FC<ContextMenuProps> = (props) => {
	return (
		<frame BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
			{props.visible && (
				<frame
					Key={"ContextMenu"}
					Size={new UDim2(0, 150, 0, 100)}
					Position={props.position}
					BackgroundColor3={Color3.fromRGB(60, 60, 60)}
					ZIndex={10}
				>
					<textbutton
						Key={"Equip"}
						Size={new UDim2(1, 0, 0.5, 0)}
						BackgroundColor3={Color3.fromRGB(60, 60, 60)}
						TextColor3={Color3.fromRGB(200, 200, 200)}
						Text={"Equip"}
						ZIndex={11}
						Event={{
							MouseButton1Click: () => {
								print("Equipped");
								EquipItemFromInventoryEvent.SendToServer(props.item);
								props.onClose();
							},
						}}
					/>
					<textbutton
						Key={"Drop"}
						Size={new UDim2(1, 0, 0.5, 0)}
						Position={new UDim2(0, 0, 0.5, 0)}
						BackgroundColor3={Color3.fromRGB(60, 60, 60)}
						TextColor3={Color3.fromRGB(200, 200, 200)}
						Text={"Drop"}
						ZIndex={11}
						Event={{
							MouseButton1Click: () => {
								print("Dropped");
								DropItemFromInventoryEvent.SendToServer(props.item);
								// Delete itself

								props.onClose();
							},
						}}
					/>
				</frame>
			)}
		</frame>
	);
};

export default new Hooks(Roact)(ContextMenu);
