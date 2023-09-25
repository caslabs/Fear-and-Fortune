import { Players, Workspace } from "@rbxts/services";

interface FXTemplate {
	assetIds: Array<number>;
	duration: number;
}

const fxTemplates: Map<string, FXTemplate> = new Map([
	[
		"glitch",
		{
			assetIds: [434633166, 434633194, 434633220, 434633258, 434639717], // Replace with your own asset IDs
			duration: 0.1, // Replace with your desired duration between frames
		},
	],
	[
		"dark",
		{
			assetIds: [987654, 321098, 765432], // Replace with your own asset IDs
			duration: 0.8, // Replace with your desired duration between frames
		},
	],
	// Add more templates as desired
]);

interface FXEventData {
	templateId: string;
}

export class FXManager {
	private static instance: FXManager;

	private constructor() {}

	public static getInstance(): FXManager {
		if (!FXManager.instance) {
			FXManager.instance = new FXManager();
		}
		return FXManager.instance;
	}

	public playFX(eventData: FXEventData): void {
		const template = fxTemplates.get(eventData.templateId);
		if (!template) {
			warn(`FX template with ID "${eventData.templateId}" not found.`);
			return;
		}

		const player = Players.LocalPlayer;
		const playerGui = player.WaitForChild("PlayerGui");

		// Create a new ScreenGui to display the images
		const screenGui = new Instance("ScreenGui");
		screenGui.Parent = playerGui;
		screenGui.ResetOnSpawn = false;

		// Create a series of ImageLabels to display the assets
		const imageLabels = template.assetIds.map((assetId) => {
			const imageLabel = new Instance("ImageLabel");
			imageLabel.Parent = screenGui;
			imageLabel.BackgroundTransparency = 1;
			imageLabel.Size = new UDim2(1, 0, 1, 0);
			imageLabel.Position = new UDim2(0, 0, 0, 0);
			imageLabel.AnchorPoint = new Vector2(0.5, 0.5);
			imageLabel.Image = `rbxassetid://${assetId}`;
			imageLabel.Visible = false;
			return imageLabel;
		});

		// Play the sequence of images with the given duration between frames
		let currentIndex = 0;
		const playNextImage = () => {
			if (currentIndex < imageLabels.size()) {
				// Hide the previous image and show the next one
				if (currentIndex > 0) {
					imageLabels[currentIndex - 1].Visible = false;
				}
				imageLabels[currentIndex].Visible = true;

				// Schedule the next image to be shown after the specified duration
				currentIndex++;
				wait(template.duration);
				playNextImage();
			} else {
				// All images have been shown, clean up and exit
				screenGui.Destroy();
			}
		};

		// Start the sequence with the first image
		imageLabels[0].Visible = true;
		playNextImage();
		print("FX played");
	}
}
