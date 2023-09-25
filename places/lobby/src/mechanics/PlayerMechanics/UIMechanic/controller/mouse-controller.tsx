import Roact from "@rbxts/roact";
import { Players, UserInputService, RunService } from "@rbxts/services";
import { Controller, OnStart } from "@flamework/core";
import CharacterMechanic from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import { Signals } from "shared/signals";
import CustomMouse from "ui/components/custom-mouse";
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

@Controller({
	loadOrder: 5, // Try to make MouseController run last
})
export class MouseController implements OnStart {
	public mouseIconVisiblity: boolean;

	constructor(private readonly characterController: CharacterMechanic) {
		this.mouseIconVisiblity = true;
	}

	onStart(): void {
		print("MouseController started");

		// Hide Mouse
		UserInputService.MouseIconEnabled = false;
	}

	//For DEV purposes
	iniateCustomCursor(): void {
		const mouse = Player.GetMouse();
		mouse.Icon = "rbxassetid://5992580992";
	}

	public initiateDynamicCustomCursor(): void {
		// Mount Component
		const handle: Roact.Tree = Roact.mount(
			<screengui Key={"DynamicCustomMouseIcon"} IgnoreGuiInset={true} ResetOnSpawn={false}>
				<CustomMouse />
			</screengui>,
			PlayerGui,
		);
	}

	//TODO: This is deprecated, as we are not using button to play the game. It's any buttons.
	// Button State Handling
	public handleButton(button: GuiButton): void {
		button.MouseEnter.Connect(() => {
			Signals.mouseColor.Fire(new Color3(0.81, 0.74, 0.74));
		});

		button.MouseLeave.Connect(() => {
			Signals.mouseColor.Fire(new Color3(1, 1, 1));
		});
	}

	// Hook up all the buttons to our custom cursor observer
	public readButtons(): void {
		const allGuiObjects = PlayerGui.GetDescendants();

		for (let i = 0; i < allGuiObjects.size(); i++) {
			const guiObject = allGuiObjects[i];
			if (guiObject.IsA("GuiButton")) {
				const obj = allGuiObjects[i];
				if (obj.IsA("GuiButton")) {
					this.handleButton(obj as GuiButton); // TODO: bit of a hack, but we know it's a GuiButton
				}
			}
		}
	}
}
