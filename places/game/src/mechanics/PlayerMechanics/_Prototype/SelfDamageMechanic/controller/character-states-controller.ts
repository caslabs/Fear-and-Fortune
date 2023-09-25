import { Controller, OnStart, OnInit } from "@flamework/core";
import { ContextActionService, TweenService, Workspace } from "@rbxts/services";
import PlayerStates from "shared/AISystem/AIManager/character-states";
import CharacterMechanic from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";

const camera = Workspace.CurrentCamera!;
const tweenInfo = new TweenInfo(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In);

// PlayerStateProperties.ts
interface PlayerStateProperties {
	walkSpeed: number;
	fov: number;
	// Add any other properties you need for each state
}

@Controller({})
export default class PlayerStateController implements OnStart, OnInit {
	private currentState: PlayerStates;
	private stateProperties: Map<PlayerStates, PlayerStateProperties>;

	constructor(private readonly characterController: CharacterMechanic) {
		this.currentState = PlayerStates.Normal;

		// Initialize the state properties dictionary
		this.stateProperties = new Map<PlayerStates, PlayerStateProperties>();
		this.stateProperties.set(PlayerStates.Normal, {
			walkSpeed: 16,
			fov: 70,
		});

		this.stateProperties.set(PlayerStates.Sprinting, {
			walkSpeed: 16 * 1.45,
			fov: 85,
		});

		this.stateProperties.set(PlayerStates.Chasing, {
			walkSpeed: 16 * 2,
			fov: 90,
		});

		this.stateProperties.set(PlayerStates.Crouching, {
			walkSpeed: 8, // Define the walkSpeed for crouching, adjust as needed
			fov: 70, // Define the Field of View for crouching, adjust as needed
		});
	}

	public onInit(): void {}

	public onStart(): void {}

	public setState(newState: PlayerStates): void {
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.FindFirstChild("Humanoid") as Humanoid | undefined;
		if (!humanoid) {
			print("No humanoid found");
			return;
		}

		const properties = this.getProperties(newState);
		if (!properties) {
			print(`No properties found for state: ${newState}`);
			return;
		}

		humanoid.WalkSpeed = properties.walkSpeed;
		this.updateFov(properties.fov);
		this.currentState = newState;
		print(`Set state to ${newState}, walkSpeed: ${properties.walkSpeed}, fov: ${properties.fov}`);
	}

	public getProperties(state: PlayerStates): PlayerStateProperties | undefined {
		return this.stateProperties.get(state);
	}

	public updateFov(newFov: number) {
		TweenService.Create(camera, tweenInfo, { FieldOfView: newFov }).Play();
	}
}
