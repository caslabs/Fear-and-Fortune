import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Theme from "ui/theme";
import { Players, UserInputService } from "@rbxts/services";
import ContextMenu from "./context-menu";
import ContextHotbarMenu from "./context-hotbar-menu";
// HotBarInventoryItem.ts

interface HotBarInventoryItemProps {
	name: string;
	color?: Color3;
	desc?: string;
	quantity: number;
	LayoutOrder: number;
}

const HotBarInventoryItem: Hooks.FC<HotBarInventoryItemProps> = (props, { useState, useEffect }) => {
	const [highlighted, setHighlighted] = useState(false);

	// Inside the HotBarInventoryItem component
	const [contextMenuVisible, setContextMenuVisible] = useState(false);
	const [contextMenuPosition, setContextMenuPosition] = useState(UDim2.fromScale(0, 0));

	// Add useEffect hook to listen for tab key press
	useEffect(() => {
		const connection = UserInputService.InputBegan.Connect((input) => {
			if (input.KeyCode === Enum.KeyCode.Tab) {
				setContextMenuVisible(false);
			}
		});
		return () => connection.Disconnect();
	}, []);

	return (
		<frame Size={UDim2.fromScale(1, 1)}>
			<textbutton
				Size={UDim2.fromScale(1, 1)}
				Key={props.name}
				Text={props.name}
				TextColor3={Color3.fromRGB(222, 222, 222)}
				BackgroundColor3={highlighted ? props.color ?? Color3.fromRGB(26, 26, 26) : Color3.fromRGB(60, 60, 60)}
				Event={{
					MouseEnter: () => setHighlighted(true),
					MouseLeave: () => setHighlighted(false),
					MouseButton2Click: (rbx) => {
						const mouse = Players.LocalPlayer.GetMouse();
						const guiObject = rbx as GuiObject;
						const panelPosition = guiObject.AbsolutePosition;
						const position = new UDim2(0, mouse.X - panelPosition.X, 0, mouse.Y - panelPosition.Y);
						setContextMenuPosition(position);
						setContextMenuVisible(true);
					},
				}}
				LayoutOrder={props.LayoutOrder}
				TextScaled={true}
			>
				<uicorner CornerRadius={new UDim(0, 6)} />
				<uipadding
					PaddingTop={new UDim(0, 6)}
					PaddingBottom={new UDim(0, 6)}
					PaddingLeft={new UDim(0, 6)}
					PaddingRight={new UDim(0, 6)}
				/>

				{/* Display the item description when the button is highlighted */}
				{highlighted && (
					<textlabel
						Text={props.desc ?? ""}
						BackgroundTransparency={1}
						TextColor3={Color3.fromRGB(255, 255, 255)}
						Font={Theme.FontNormal}
						TextSize={18}
						AutomaticSize={"Y"}
						TextWrapped={true}
					/>
				)}

				<ContextHotbarMenu
					visible={contextMenuVisible}
					position={contextMenuPosition}
					onClose={() => setContextMenuVisible(false)}
					item={props.name}
				/>
			</textbutton>

			{/* Add a transparent button to close the context menu on left click outside */}
			{contextMenuVisible && (
				<textbutton
					Size={UDim2.fromScale(1, 1)}
					BackgroundTransparency={1}
					Text=""
					TextColor3={Color3.fromRGB(0, 0, 0)}
					BorderSizePixel={0}
					Event={{
						MouseButton1Click: () => setContextMenuVisible(false),
					}}
				/>
			)}
		</frame>
	);
};

export default new Hooks(Roact)(HotBarInventoryItem);
