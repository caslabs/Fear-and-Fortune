import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Theme from "ui/theme";
import { Players, UserInputService, ReplicatedStorage, RunService } from "@rbxts/services";
import ContextMenu from "./context-menu";
// InventoryItem.ts

interface InventoryItemProps {
	name: string;
	color?: Color3;
	desc?: string;
	quantity: number;
	LayoutOrder: number;
}

const InventoryItem: Hooks.FC<InventoryItemProps> = (props, { useState, useEffect }) => {
	const [highlighted, setHighlighted] = useState(false);

	// Inside the InventoryItem component
	const [contextMenuVisible, setContextMenuVisible] = useState(false);
	const [contextMenuPosition, setContextMenuPosition] = useState(UDim2.fromScale(0, 0));

	const [charModel, setCharModel] = useState<Model | undefined>(undefined);

	const camera = new Instance("Camera") as Camera;
	const position = new Vector3(871.947, 5.953, -155.032);
	const orientation = new Vector3(math.rad(1.222), math.rad(177.586), math.rad(0));

	camera.CFrame = new CFrame(position).mul(CFrame.fromOrientation(orientation.X, orientation.Y, orientation.Z));
	const CameraRef = Roact.createRef<Camera>();
	const ViewportRef = Roact.createRef<ViewportFrame>();

	useEffect(() => {
		let isMounted = true; // To ensure we don't update state on unmounted component
		// eslint-disable-next-line prefer-const
		let characterChecker: RBXScriptConnection;

		const checkForCharacter = () => {
			const luffy = ReplicatedStorage.FindFirstChild("AxeTest") as Model | undefined;
			if (luffy && isMounted) {
				const charClone = luffy.Clone() as Model;
				setCharModel(charClone);
				print("Axe found");
				characterChecker.Disconnect(); // Stop the connection once 'luffy' is found
			} else {
				print("Axe not found");
			}
		};

		characterChecker = RunService.Heartbeat.Connect(checkForCharacter);

		return () => {
			isMounted = false; // To flag the component as unmounted
			characterChecker.Disconnect();
		};
	}, []);

	useEffect(() => {
		const viewport = ViewportRef.getValue()!;
		if (charModel) {
			(charModel as Model).Parent = viewport;
			camera.Parent = viewport;
			viewport.CurrentCamera = camera;
			print("Setting camera", viewport.CurrentCamera);
			(charModel as Model).Name = "AxeTest";
		}
	}, [charModel]);

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
				Text={""}
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
				<viewportframe
					Size={new UDim2(0.9, 0, 0.9, 0)}
					Position={new UDim2(0, 15, 0, 13)}
					BackgroundColor3={Color3.fromRGB(60, 60, 60)}
					BorderColor3={Color3.fromRGB(170, 150, 127)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
					CurrentCamera={camera}
					Ref={ViewportRef}
				></viewportframe>
				<uicorner CornerRadius={new UDim(0, 6)} />
				<uipadding
					PaddingTop={new UDim(0, 6)}
					PaddingBottom={new UDim(0, 6)}
					PaddingLeft={new UDim(0, 6)}
					PaddingRight={new UDim(0, 6)}
				/>
				<textlabel
					Text={"x" + tostring(props.quantity)}
					BackgroundTransparency={1}
					TextColor3={Color3.fromRGB(200, 200, 200)}
					Font={Theme.FontNormal}
					TextSize={18}
					AutomaticSize={"Y"}
					TextScaled={false}
					TextWrapped={true}
					Size={new UDim2(1, 0, 0, 0)}
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

				<ContextMenu
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

export default new Hooks(Roact)(InventoryItem);
