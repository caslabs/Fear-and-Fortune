import { Controller, OnInit, OnStart } from "@flamework/core";
import { AnimationData, AnimationKeys } from "../manager/AnimationData";
import CharacterController from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import { Signals } from "shared/signals";
import { UserInputService } from "@rbxts/services";

@Controller({})
export default class AnimationSystemController implements OnStart, OnInit {
	constructor(private readonly characterController: CharacterController) {}
	private static animationInstances: Map<AnimationKeys, Animation> = new Map();
	private animator?: Animator;

	public onInit(): void {
		for (const [animationKey, animationId] of AnimationData) {
			const animation = new Instance("Animation");
			animation.AnimationId = `rbxassetid://${animationId}`;
			AnimationSystemController.animationInstances.set(animationKey, animation);
		}
		print("AnimationSystemController initialized");
	}

	public onStart(): void {
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.Humanoid;
		if (!humanoid) return;

		this.animator = humanoid.FindFirstChildOfClass("Animator") as Animator;
		if (!this.animator) {
			print("No Animator found for character");
			return;
		}

		print("Animator set up");

		UserInputService.InputBegan.Connect((input) => this._handleInput(input));
		print("AnimationSystemController started");
	}

	private _handleInput(input: InputObject) {
		// Check if the input was the 'F' key
		/*
		if (input.KeyCode === Enum.KeyCode.U) {
			// If so, trigger the POINT animation
			this.playAnimation(AnimationKeys.POINT);
			print("AnimationSystemController: Playing animation");
		}
		*/
	}

	public playAnimation(id: AnimationKeys) {
		print("[INFO] playAnimation", id);
		const animation = AnimationSystemController.animationInstances.get(id);
		if (animation && this.animator) {
			const animationTrack = this.animator.LoadAnimation(animation);
			animationTrack.Play();
			print("Animation should be playing");
		}
	}

	public stopAnimation(id: AnimationKeys) {
		print("[INFO] stopAnimation", id);
		const animation = AnimationSystemController.animationInstances.get(id);
		if (animation && this.animator) {
			const animationTrack = this.animator.LoadAnimation(animation);
			animationTrack.Stop();
		}
	}
}
