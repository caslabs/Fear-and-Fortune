import { Controller, OnInit, OnStart } from "@flamework/core";
import { Workspace, Players, ReplicatedStorage, RunService } from "@rbxts/services";
import { CharacterRigR15 } from "@rbxts/yield-for-character";
import CharacterMechanic from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";

@Controller({
	loadOrder: 3,
})
export default class WeatherSystemController implements OnInit, OnStart {
	constructor(public readonly characterController: CharacterMechanic) {}
	private humanoid?: BasePart;
	onInit(): void {}

	onStart(): void {
		print("WeatherSystem Controller started");

		const player = Players.LocalPlayer;
		if (player) {
			// Deploy Character Controller
			wait(5); //TODO: Do we need this wait?
			this.setCharacter(this.characterController.getCurrentCharacter());
			this.characterController.onCharacterAdded.Connect((character) => this.setCharacter(character));
			this.characterController.onCharacterRemoved.Connect(() => this.setCharacter(undefined)); // Listen for character removal
			this.initializeWeather();
		}
	}

	initializeWeather() {
		const weather = ReplicatedStorage.FindFirstChild("Weather") as Model;
		if (!weather) {
			warn("Weather not found");
			return;
		}

		let weatherInstance = weather.Clone() as Model;

		// Access the ParticleEmitter
		const basePart = weatherInstance.FindFirstChild("Weather") as BasePart;
		const snowEmitter = basePart.FindFirstChildOfClass("ParticleEmitter");

		// Check if we found the emitter
		if (!snowEmitter) {
			warn("ParticleEmitter not found");
			return;
		}

		// Set properties for the ParticleEmitter
		snowEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds";
		snowEmitter.Size = new NumberSequence(0.5, 2);
		snowEmitter.Lifetime = new NumberRange(5, 50);
		snowEmitter.Rate = 500;
		snowEmitter.Speed = new NumberRange(15, 300);
		snowEmitter.Rotation = new NumberRange(0, 360);
		snowEmitter.Transparency = new NumberSequence(0, 0.5);
		snowEmitter.Color = new ColorSequence([
			new ColorSequenceKeypoint(0, new Color3(1, 1, 1)),
			new ColorSequenceKeypoint(1, new Color3(1, 1, 1)),
		]);
		// ...
		snowEmitter.LightEmission = 0.5;
		snowEmitter.LightInfluence = 0;
		snowEmitter.SpreadAngle = new Vector2(-180, 180);

		print("ParticleEmitter properties set");

		// Keeps the weather following the player
		RunService.RenderStepped.Connect(() => {
			if (!this.humanoid) return;
			const HumanoidRootPart = this.humanoid as BasePart;

			if (HumanoidRootPart) {
				if (weatherInstance.Parent !== Workspace) {
					weatherInstance = weather.Clone() as Model;
					weatherInstance.Parent = Workspace;
				}
				weatherInstance.SetPrimaryPartCFrame(
					new CFrame(
						new Vector3(
							HumanoidRootPart.Position.X,
							HumanoidRootPart.Position.Y + 88.204,
							HumanoidRootPart.Position.Z,
						),
					),
				);
			} else {
				weatherInstance.Parent = undefined;
			}
		});

		print("Weather initialized");
	}

	private setCharacter(character?: CharacterRigR15) {
		if (character) {
			this.humanoid = character.HumanoidRootPart;
			if (!this.humanoid) {
				print("Humanoid not found");
				return;
			}
		} else {
			this.humanoid = undefined;
		}
	}
}
