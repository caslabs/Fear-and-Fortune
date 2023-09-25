// client/controller/elevation-mechanic-controller.ts
import { Players, RunService } from "@rbxts/services";
import { Controller, OnInit, OnStart } from "@flamework/core";
import { Signals } from "shared/signals";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import { CharacterRigR15 } from "@rbxts/yield-for-character";

@Controller({
	loadOrder: 3,
})
export default class ElevationMechanicController implements OnInit, OnStart {
	private humanoid?: BasePart;
	constructor(private readonly characterController: CharacterController) {}

	public getElevationChanged() {
		return Signals.playerElevationChanged;
	}

	public onInit(): void {}

	public onStart(): void {
		print("ElevationMechanic Controller started");

		const player = Players.LocalPlayer;
		if (player) {
			// Deploy Character Controller
			wait(5);

			this.setCharacter(this.characterController.getCurrentCharacter());

			this.characterController.onCharacterAdded.Connect((character) => this.setCharacter(character));

			// Run every frame
			RunService.RenderStepped.Connect(() => {
				if (this.humanoid) {
					const elevation = this.humanoid.Position.Y;
					Signals.playerElevationChanged.Fire(player, elevation);
				}
			});
		}
	}

	private setCharacter(character?: CharacterRigR15) {
		this.humanoid = character?.HumanoidRootPart;
		if (!this.humanoid) {
			print("Humanoid not found");
			return;
		}
	}
}
