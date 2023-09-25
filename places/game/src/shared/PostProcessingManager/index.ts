import { TweenService } from "@rbxts/services";
import { PostProcessingState } from "./postProcessingStates";

interface PostProcessingTemplate {
	state: PostProcessingState;
	properties: Map<string, number>;
}

type TransitionType = "instant" | "smooth";

export class PostProcessingManager {
	private static instance: PostProcessingManager;
	private templates: Map<string, PostProcessingTemplate>;

	constructor() {
		this.templates = new Map();
	}

	public static getInstance(): PostProcessingManager {
		if (!PostProcessingManager.instance) {
			PostProcessingManager.instance = new PostProcessingManager();
		}
		return PostProcessingManager.instance;
	}

	createTemplate(templateName: string, state: PostProcessingState, properties: Map<string, number>) {
		this.templates.set(templateName, { state, properties });
	}

	updateState(templateName: string, transitionType: TransitionType = "instant") {
		const template = this.templates.get(templateName);

		if (!template) {
			print("Unknown post-processing template:", templateName);
			return;
		}

		template.state.apply();

		if (transitionType === "instant") {
			this.applyInstant(template.properties);
		} else if (transitionType === "smooth") {
			this.applySmooth(template.properties);
		} else {
			print("Unknown transition type:", transitionType);
		}
	}

	private applyInstant(properties: Map<string, number>) {
		properties.forEach((value, key) => {
			if (key === "Brightness") {
				game.GetService("Lighting").Brightness = value;
			}
			// Add more properties here as needed
		});
	}

	private applySmooth(properties: Map<string, number>) {
		print("Applying smooth transition");
		properties.forEach((value, key) => {
			if (key === "Brightness") {
				const lighting = game.GetService("Lighting");
				const currentValue = lighting.Brightness;
				const transitionTime = 5; // You can adjust the transition time as needed
				TweenService.Create(
					lighting,
					new TweenInfo(transitionTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
					{ Brightness: value },
				).Play();
			}
			// Add more properties here as needed
		});
	}
}
