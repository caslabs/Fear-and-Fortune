import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import { Players, ReplicatedStorage, TeleportService } from "@rbxts/services";
import { RunService } from "@rbxts/services";
import Make from "@rbxts/make";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";

interface Attributes {}

//TODO: Refactor this to be a generic door component
const ToggleRespawn = Remotes.Client.Get("ToggleRespawn");
const IsExtractedEvent = Remotes.Client.Get("IsExtracted");
const UpdateExpeditionCountEvent = Remotes.Client.Get("UpdateExpeditionCount");

const animationInstance = new Instance("Animation");
animationInstance.AnimationId = "rbxassetid://14308122728";

@Component({
	tag: "ExitPortalTrigger",
	instanceGuard: t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
})
export class ExitPortalComponent extends BaseComponent<Attributes> implements OnStart {
	private animation: AnimationTrack | undefined;
	private charShirtID: string | undefined;
	private charPantsID: string | undefined;
	private armParts: BasePart[] = []; // add this line

	constructor() {
		super();
		this.animation = undefined;
		this.charPantsID = undefined;
		this.charShirtID = undefined;
	}
	onStart() {
		print("ExitPortal Component Initiated");
		if (this.instance.IsA("Model") && !this.instance.PrimaryPart) {
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart");
			return;
		}
		const prompt = this.attachProximityPrompt();
		this.maid.GiveTask(
			prompt.Triggered.Connect((player) => {
				IsExtractedEvent.SendToServer(player);
				print("[PORTAL] Called IsExtractedEvent");
				SoundSystemController.playSound(SoundKeys.SFX_PORTAL_EXIT, 3);
				this.TeleportToLobby(player);

				//TODO: EXTRACTION PING
				UpdateExpeditionCountEvent.SendToServer(player);
			}),
		);
		this.maid.GiveTask(
			prompt.PromptButtonHoldBegan.Connect((player) => {
				this.startGlowing(player);
			}),
		);
		this.maid.GiveTask(
			prompt.PromptButtonHoldEnded.Connect((player) => {
				this.stopGlowing(player);
			}),
		);

		const player = Players.LocalPlayer;
		const char = player.Character;
		//Save the Character pants and shirts
		this.charPantsID = char?.FindFirstChildOfClass("Pants")?.PantsTemplate;
		this.charShirtID = char?.FindFirstChildOfClass("Shirt")?.ShirtTemplate;
		if (char !== undefined) {
			this.armParts = this.getArmParts(char); // add this line
		}

		const humanoid = player.Character?.FindFirstChildOfClass("Humanoid");
		if (humanoid) {
			const animator = humanoid.FindFirstChildOfClass("Animator");
			if (animator) {
				this.animation = animator.LoadAnimation(animationInstance);
				print("animation loaded");
			}
		}
	}

	private getArmParts(character: Model): BasePart[] {
		const armPartNames = [
			"LeftUpperArm",
			"LeftLowerArm",
			"LeftHand",
			"RightUpperArm",
			"RightLowerArm",
			"RightHand",
			"Left Arm",
			"Right Arm",
		];

		const armParts: BasePart[] = [];
		for (const partName of armPartNames) {
			const part = character.FindFirstChild(partName);
			if (part !== undefined && part.IsA("BasePart")) {
				armParts.push(part);
			}
		}

		return armParts;
	}

	attachProximityPrompt() {
		return Make("ProximityPrompt", {
			ObjectText: "ExitPortal",
			ActionText: "Exit",
			HoldDuration: 3,
			Parent: this.instance.IsA("Model") ? this.instance.PrimaryPart : this.instance,
		});
	}

	TeleportToLobby(player: Player) {
		// Make player temporarily immune + immunity effect
		// Switch to spectate camera
		// Show option to return to lobby or keep spectating
		// If option is true, return to lobby
		ToggleRespawn.SendToServer(false);
		Signals.ExitPortalTouched.Fire();

		const character = player.Character;
		if (character !== undefined) {
			player.Character = undefined;
			character.ClearAllChildren();
			character.Destroy();
		}

		/*
		print("[INFO] Attempting to Teleport Lobby...");
		const placeId = 13733616492; // Replace with your main game's place ID
		TeleportService.TeleportAsync(placeId, [player]);
		*/
	}

	startGlowing(player: Player) {
		print("[INFO] GLOWING");
		const character = player.Character;
		// DEFINSIVE PROGRAMMIGN -
		// Only remove pants if they exist
		const pants = character?.FindFirstChild("Pants") as Pants;
		if (pants) {
			pants.PantsTemplate = "";
		}
		// Only remove shirt if it exists
		const shirt = character?.FindFirstChild("Shirt") as Shirt;
		if (shirt) {
			shirt.ShirtTemplate = "";
		}
		for (const part of this.armParts) {
			part.Material = Enum.Material.Neon;
			print("Material set to " + part.Material);
		}

		if (this.animation !== undefined) {
			this.animation.Play();
		} else {
			print("ERROR: No animation");
		}

		//14308122728
	}

	stopGlowing(player: Player) {
		print("[INFO] STOP GLOWING");
		const character = player.Character;
		if (this.charPantsID === undefined || this.charShirtID === undefined) {
			print("ERROR: No charPantsID or charShirtID");
		} else {
			// Only give back pants if they exist
			const pants = character?.FindFirstChild("Pants") as Pants;
			if (pants) {
				pants.PantsTemplate = this.charPantsID;
			}
			// Only give back shirt if it exists
			const shirt = character?.FindFirstChild("Shirt") as Shirt;
			if (shirt) {
				shirt.ShirtTemplate = this.charShirtID;
			}
		}

		for (const part of this.armParts) {
			part.Material = Enum.Material.Plastic;
		}

		if (this.animation !== undefined) {
			this.animation.Stop();
		} else {
			print("ERROR: No animation");
		}
	}
}
