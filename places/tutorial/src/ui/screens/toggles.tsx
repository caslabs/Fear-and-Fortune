import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { StarterGui } from "@rbxts/services";
import Toggle from "../components/toggles";
import { ContextActionService } from "@rbxts/services";
import { Context, Pages } from "ui/Context";

interface TogglesProps {}

const startInventoryState = Enum.UserInputState.Begin;
StarterGui.SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);

// Toggles Between PlayHUD and Inventory
const Toggles: Hooks.FC<TogglesProps> = (props, { useState }) => {
	ContextActionService.UnbindAction("RbxPlayerListToggle");

	return (
		<Context.Consumer
			render={(value: { viewIndex: number; setPage: (index: number) => void }) => {
				ContextActionService.BindAction("OpenInventory", (_, s) => handleInput(s), true, Enum.KeyCode.Tab);
				function handleInput(state: Enum.UserInputState) {
					if (state === startInventoryState) {
						const index = Pages.inventory;
						if (value.viewIndex === index) {
							value.setPage(Pages.play);
						} else {
							value.setPage(index);
						}
					}
				}

				return (
					<frame
						Key={"InventoryToggle"}
						Size={UDim2.fromOffset(150, 35)}
						Position={new UDim2(0, 250, 0, 2)}
						AnchorPoint={new Vector2(1, 0)}
						BackgroundTransparency={1}
					>
						<uilistlayout
							SortOrder={"LayoutOrder"}
							FillDirection={"Horizontal"}
							HorizontalAlignment={"Left"}
							Padding={new UDim(0, 10)}
						/>
						<Toggle
							Key={"InventoryToggleComponent"}
							onClick={() => {
								const index = Pages.inventory;
								if (value.viewIndex === index) {
									value.setPage(1);
								} else {
									value.setPage(index);
								}
							}}
							text={"[Tab] Inventory"}
							caption={"[Tab] Inventory"}
							layout={1}
						/>

						<Toggle
							Key={"CraftingToggleComponent"}
							onClick={() => {
								const index = Pages.craft;
								if (value.viewIndex === index) {
									value.setPage(1);
								} else {
									value.setPage(index);
								}
							}}
							text={"[K] Craft"}
							caption={"[K] Craft"}
							layout={1}
						/>
					</frame>
				);
			}}
		></Context.Consumer>
	);
};

export default new Hooks(Roact)(Toggles);
