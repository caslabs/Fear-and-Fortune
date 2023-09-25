import { Lighting, Players, Workspace } from "@rbxts/services";

export interface PostProcessingState {
	apply(): void;
}

export class BlackoutState implements PostProcessingState {
	apply(): void {
		// Set up the post-processing properties for a blackout effect
		Lighting.Ambient = new Color3(0, 0, 0);
		Lighting.OutdoorAmbient = new Color3(0, 0, 0);
		Lighting.Brightness = 0;

		const colorCorrection = new Instance("ColorCorrectionEffect");
		colorCorrection.Saturation = -1;
		colorCorrection.Parent = Lighting;
	}
}

export class DefaultState implements PostProcessingState {
	// Default state
	apply(): void {}
}

export class JumpscareState implements PostProcessingState {
	apply(): void {
		// Set up the post-processing properties for a jumpscare effect
		Lighting.Brightness = 1;

		const colorCorrection = new Instance("ColorCorrectionEffect");
		colorCorrection.Saturation = 0;
		colorCorrection.TintColor = new Color3(1, 0.5, 0.5); // Adds a red tint
		colorCorrection.Parent = Lighting;

		const bloom = new Instance("BloomEffect");
		bloom.Intensity = 1.5;
		bloom.Size = 48;
		bloom.Parent = Lighting;

		Promise.delay(1.5).then(() => {
			// Adjust the delay to match the jumpscare duration
			colorCorrection.Destroy();
		});
	}
}

export class ZoomState implements PostProcessingState {
	apply(): void {
		const player = Players.LocalPlayer;
		const camera = Workspace.CurrentCamera;

		// Set up the post-processing properties for a jumpscare effect with zoom
		if (player && camera) {
			// Save the original FieldOfView
			// Zoom in slightly
			camera.FieldOfView = 120; // Adjust this value to control the zoom level
		}
	}
}

export class JumpscareZoomState implements PostProcessingState {
	apply(): void {
		const player = Players.LocalPlayer;
		const camera = Workspace.CurrentCamera;
		const character = player.Character;
		const humanoid = character?.FindFirstChild("Humanoid");
		//TODO: Temporarily Player Heatlh Damage
		// Set up the post-processing properties for a jumpscare effect with zoom and red tint
		Lighting.Brightness = 1;

		const colorCorrection = new Instance("ColorCorrectionEffect");
		colorCorrection.Saturation = 0;
		colorCorrection.TintColor = new Color3(1, 0.5, 0.5); // Adds a red tint
		colorCorrection.Parent = Lighting;

		const bloom = new Instance("BloomEffect");
		bloom.Intensity = 1.5;
		bloom.Size = 48;
		bloom.Parent = Lighting;

		if (humanoid && humanoid.IsA("Humanoid")) {
			// It's a player! Subtract health.
			print("SPOOKED Player!");
			humanoid.Health -= 10;

			// Find the Player instance associated with the character model
			const player = Players.GetPlayerFromCharacter(character);

			//Guard - if player is alive, prevent error of fidning attribute of a non-existent player
			// If the player was found, set the attribute
			if (player) {
				// Make sure the player instance is still valid
				if (player.IsA("Player")) {
					player.SetAttribute("LastDamageByBanshee", true);
				}

				// Save the original FieldOfView
				const originalFOV = 70;

				// Zoom in slightly
				camera!.FieldOfView = 30; // Adjust this value to control the zoom level

				Promise.delay(1).then(() => {
					camera!.FieldOfView = originalFOV;
				});
			}
		}

		Promise.delay(1).then(() => {
			colorCorrection.Destroy();
			bloom.Destroy();
		});

		print("[POST PROCESSING] JUMPSCARE");
	}
}

export class NormalState implements PostProcessingState {
	apply(): void {
		// Set up the post-processing properties for a jumpscare effect
		Lighting.Brightness = 0;

		const colorCorrection = new Instance("ColorCorrectionEffect");
		colorCorrection.Saturation = 0;
		colorCorrection.Name = "ColorCorrectionEffect";
		colorCorrection.Parent = Lighting;

		const bloom = new Instance("BloomEffect");
		bloom.Intensity = 0;
		bloom.Size = 0;
		bloom.Parent = Lighting;
	}
}
