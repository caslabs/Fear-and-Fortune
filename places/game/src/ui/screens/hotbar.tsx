import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { UserInputService, Players } from "@rbxts/services";
import { Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";
import InventoryItem from "ui/components/inventory-component";
import EmptyInventoryItem from "ui/components/empty-inventory-component";
import { InventoryItemData } from "./_inventoryData";
import HotbarSlot from "ui/components/slot-component";
import Remotes from "shared/remotes";
import GunScreen from "./gun-screen";
import { Signals } from "shared/signals";

/*
Hotbar is basically acts two function
- Overlay the tool hotbar of particular tools [Still need to create a system for this]
- Overlay the inventory system in hand
*/

interface InventoryProps {
	visible?: boolean;
	data: Array<InventoryItemData>; // Add this line to declare the data prop
}

const ToolPickupEvent = Remotes.Client.Get("ToolPickupEvent");
const ToolRemovedEvent = Remotes.Client.Get("ToolRemovedEvent");
const UpdateAmmoEvent = Remotes.Client.Get("UpdateAmmoEvent");
const DropItemFromInventoryEvent = Remotes.Client.Get("DropItemFromInventory");

const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

const Hotbar: Hooks.FC<InventoryProps> = (props, { useState, useEffect }) => {
	const emptySlot: InventoryItemData = { name: "", quantity: 0 };
	const initialData: Array<InventoryItemData> = [emptySlot, emptySlot, emptySlot, emptySlot, emptySlot];
	const [data, setData] = useState<Array<InventoryItemData>>(initialData);
	const [selectedSlot, setSelectedSlot] = useState<number>(0);
	const [equippedTool, setEquippedTool] = useState<string>("");
	const [handle, setHandle] = useState<Roact.Tree | undefined>(undefined);
	const [toolData, setToolData] = useState<{ ammo: number; maxAmmo: number } | undefined>(undefined);
	const [ammo, setAmmo] = useState<number>(0);
	const [hasGun, setHasGun] = useState<boolean>(false);

	//TODO: Research Gun System
	useEffect(() => {
		const connection = UpdateAmmoEvent.Connect((newAmmoCount: number) => {
			setAmmo(newAmmoCount);
			print("Ammo updated", newAmmoCount);
			if (hasGun) {
				// Check if an instance is already mounted and unmount it
				if (handle) {
					Roact.unmount(handle);
				}
				// Then mount the new instance
				const newHandle = Roact.mount(
					<screengui Key={"GunScreen"} IgnoreGuiInset={true} ResetOnSpawn={false}>
						<GunScreen ammo={newAmmoCount} maxAmmo={8} />
					</screengui>,
					PlayerGui,
				);
				setHandle(newHandle);
			}
		});

		return () => connection.Disconnect();
	}, [hasGun, handle]); // Add handle as a dependency

	useEffect(() => {
		const connection = ToolPickupEvent.Connect((player, tool, toolData) => {
			print("Tool picked up: " + tool);
			setToolData(toolData); // set the state
			// Check if the tool is already in the hotbar.
			const toolInHotbar = data.some((item) => item.name === tool.Name);
			if (toolInHotbar) {
				print(`Tool ${tool.Name} is already in the hotbar.`);
				return;
			}

			// Test
			if (tool.Name === "HuntingRifle") {
				if (toolData === undefined) {
					return;
				}
				setHasGun(true);
			}

			// If the tool is not in the hotbar, find the first empty slot and add it there.
			// eslint-disable-next-line roblox-ts/lua-truthiness
			const index = data.findIndex((item) => !item.name);
			if (index !== -1) {
				const newData = [...data];
				newData[index] = { name: tool.Name, quantity: 1, tool: tool };
				setData(newData);
				print("Tool added to hotbar");
				print("Equipped tool: " + tool?.Name);
				const id = tool?.Name;

				print("Adding tool to equippedTool");
				setEquippedTool(id);
			}
		});

		const removalConnection = ToolRemovedEvent.Connect((player, tool) => {
			const index = data.findIndex((item) => item.name === tool.Name);
			if (index !== -1) {
				const newData = [...data];
				newData[index] = { name: "", quantity: 0 };
				setData(newData);
				setEquippedTool("");
				if (handle && equippedTool === tool.Name) {
					Roact.unmount(handle);
					setHandle(undefined); // Reset handle
				} else if (handle === undefined) {
					print("Handle is undefined, skipping unmount");
				} else {
					print("Tool is not equipped, skipping unmount");
				}
				if (tool.Name === "HuntingRifle") {
					setHasGun(false); // Update hasGun to false when the HuntingRifle is removed
				}
			}
		});

		return () => {
			connection.Disconnect();
			removalConnection.Disconnect();
		};
	}, [data, handle, equippedTool, ammo]);

	//apparently handle must be a dependency for useEffect to work, as handle is a state variable
	useEffect(() => {
		print("Equipped tool: " + equippedTool);
		const connection = UserInputService.InputBegan.Connect(handleUserInput);
		return () => connection.Disconnect();
	}, [data, handle, equippedTool, ammo]);

	useEffect(() => {
		Signals.DropTool.Connect((toolName: string) => {
			print("Drop key pressed.");
			// find the tool in the hotbar
			const index = data.findIndex((item) => item.name === equippedTool);
			// if found, remove it from the hotbar
			if (index !== -1) {
				const newData = [...data];
				newData[index] = { name: "", quantity: 0 }; // replace the slot with an empty slot
				setData(newData);
				if (equippedTool !== "") {
					DropItemFromInventoryEvent.SendToServer(equippedTool);
				}

				//Find the tool in the character

				const character = Players.LocalPlayer.Character;
				const tool = character?.FindFirstChild(equippedTool) as Tool;
				// if found, remove it from the character
				if (tool) {
					tool.Parent = undefined;
				}

				setEquippedTool("");
			}
		});
	}, [data, equippedTool]);

	const handleUserInput = (input: InputObject | number) => {
		let selectedSlotIndex: number;
		if (typeIs(input, "number")) {
			selectedSlotIndex = input - 1; // If input is a slot number, adjust it to match array indices
		} else {
			if (input.KeyCode === Enum.KeyCode.B) {
				print("Drop key pressed.");
				/*
				// find the tool in the hotbar
				const index = data.findIndex((item) => item.name === equippedTool);
				// if found, remove it from the hotbar
				if (index !== -1) {
					const newData = [...data];
					newData[index] = { name: "", quantity: 0 }; // replace the slot with an empty slot
					setData(newData);
					if (equippedTool !== "") {
						DropItemFromInventoryEvent.SendToServer(equippedTool);
					}

					//Find the tool in the character

					const character = Players.LocalPlayer.Character;
					const tool = character?.FindFirstChild(equippedTool) as Tool;
					// if found, remove it from the character
					if (tool) {
						tool.Parent = undefined;
					}

					setEquippedTool("");
				}
				*/
				return;
			}

			selectedSlotIndex = input.KeyCode.Value - Enum.KeyCode.One.Value; // Otherwise, continue as before
		}

		print(`Selected slot index: ${selectedSlotIndex}`);
		if (data[selectedSlotIndex]) {
			print(`Data in selected slot: ${data[selectedSlotIndex].name}`);
			setSelectedSlot(selectedSlotIndex + 1);
			const tool = data[selectedSlotIndex].tool;
			const character = Players.LocalPlayer.Character;

			if (tool) {
				const character = Players.LocalPlayer.Character;
				const backpack = Players.LocalPlayer.FindFirstChild("Backpack");
				const humanoid = character?.FindFirstChildOfClass("Humanoid") as Humanoid;
				print("Tool found in selected slot, " + tool.Name + ", " + equippedTool);
				humanoid.UnequipTools();

				if (humanoid) {
					if (equippedTool === tool.Name) {
						// Unequip
						print("Equipped tool is the same as the selected tool. Unequipping...");

						setEquippedTool("");
						if (backpack) {
							tool.Parent = backpack;
							print("Tool parented to backpack");
						}

						if (handle && equippedTool === tool.Name) {
							Roact.unmount(handle);
							setHandle(undefined); // Reset handle
						} else if (handle === undefined) {
							print("Handle is undefined, skipping unmount");
						} else {
							print("Tool is not equipped, skipping unmount");
						}
					} else {
						// Equip
						print(`Equipped tool is different from the selected tool. Equipping ${tool.Name}...`);
						print(`Equipped tool: ${equippedTool}`);
						print(`Selected tool: ${tool.Name}`);
						setEquippedTool(tool.Name);
						if (character) {
							tool.Parent = character;
						}

						if (tool.Name === "HuntingRifle") {
							if (toolData === undefined) {
								return;
							}
							setHasGun(true);
						}
					}
				}
			} else {
				print("Tool not found in selected slot");

				return;
			}
		}
	};

	return (
		<frame
			Key={"Hotbar"}
			Size={new UDim2(0.3, 0, 0.1, 0)}
			Position={UDim2.fromScale(0.5, 0.94)}
			AnchorPoint={new Vector2(0.5, 0.5)}
			BackgroundTransparency={1}
			BorderSizePixel={0}
			BackgroundColor3={Color3.fromRGB(26, 26, 26)}
		>
			<uigridlayout
				CellPadding={UDim2.fromOffset(6, 6)}
				CellSize={UDim2.fromScale(0.15, 1)}
				SortOrder={Enum.SortOrder.LayoutOrder}
				HorizontalAlignment={Enum.HorizontalAlignment.Center}
			/>

			{data.map((item, index) => (
				<HotbarSlot
					Key={"Slot_" + (index + 1)}
					slotNumber={index + 1}
					// eslint-disable-next-line roblox-ts/lua-truthiness
					item={item.name ? item : undefined}
					LayoutOrder={index}
					selected={index + 1 === selectedSlot && equippedTool === item.name} // Pass selected state
					onUserInput={() => handleUserInput(index + 1)} // Pass slot number to handleUserInput
				/>
			))}
		</frame>
	);
};

export default new Hooks(Roact)(Hotbar);
