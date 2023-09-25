import { Controller, OnInit, OnStart } from "@flamework/core";
import { Workspace, Players, ReplicatedStorage, RunService, UserInputService } from "@rbxts/services";
import { CharacterRigR15 } from "@rbxts/yield-for-character";
import CharacterMechanic from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import { Signals } from "shared/signals";

const camera = Workspace.CurrentCamera;
@Controller({
	loadOrder: 3,
})
export default class FollowAgentSystemController implements OnInit, OnStart {
	constructor(public readonly characterController: CharacterMechanic) {}
	private humanoid?: BasePart;
	private isAgentVisible = false;
	private jumpscareTriggered = false;
	private followAgentInstance?: Model;
	private isAgentFrozen = false;

	onInit(): void {}

	onStart(): void {
		print("FollowAgent Controller started");

		Signals.enableJumpScareEvent.Connect(() => {
			this.toggleAgentVisibility(true);
			this.isAgentFrozen = true;
			print("Jumpscare enabled");
		});

		const player = Players.LocalPlayer;
		if (player) {
			// Deploy Character Controller
			wait(5);
			this.setCharacter(this.characterController.getCurrentCharacter());
			this.characterController.onCharacterAdded.Connect((character) => this.setCharacter(character));
			this.characterController.onCharacterRemoved.Connect(() => this.setCharacter(undefined));
			this.initializeFollowAgent();
		}
	}

	initializeFollowAgent() {
		const followAgent = ReplicatedStorage.FindFirstChild("FollowAgent") as Model;
		if (!followAgent) {
			warn("FollowAgent not found");
			return;
		}

		this.followAgentInstance = followAgent.Clone() as Model;
		this.followAgentInstance.Parent = Workspace;

		RunService.RenderStepped.Connect(() => {
			if (!this.followAgentInstance) return; // Exit if FollowAgent instance is not ready

			const HumanoidRootPart = this.humanoid as BasePart;

			if (HumanoidRootPart && this.isAgentVisible) {
				this.setAgentTransparency();

				// Only update the agent's position if it's not frozen
				if (!this.isAgentFrozen) {
					const lookVector = HumanoidRootPart.CFrame.LookVector.mul(-1); // change to humanoid root part's LookVector
					const offsetVector = new Vector3(lookVector.X, 0, lookVector.Z).mul(30);
					const agentPosition = HumanoidRootPart.Position.add(offsetVector);

					if (this.followAgentInstance!.PrimaryPart) {
						this.followAgentInstance!.SetPrimaryPartCFrame(new CFrame(agentPosition));
					} else {
						warn("FollowAgent does not have a PrimaryPart defined");
					}
				}

				this.performJumpscare();
			}
		});

		print("FollowAgent initialized");
	}

	setAgentTransparency() {
		if (!this.followAgentInstance) return;

		for (const child of this.followAgentInstance.GetChildren()) {
			if (child.IsA("BasePart")) {
				child.CanCollide = false;
				child.Transparency = this.isAgentVisible || this.isAgentFrozen ? 0 : 1;
			}
		}
	}

	toggleAgentVisibility(visible: boolean) {
		this.isAgentVisible = visible;
		this.jumpscareTriggered = false;
		this.setAgentTransparency();

		if (visible) {
			this.performJumpscare();
		}
	}

	performJumpscare() {
		if (this.humanoid && this.followAgentInstance && !this.jumpscareTriggered && this.isAgentFrozen) {
			// Get the player's look direction from the camera
			const lookVector = camera!.CFrame.LookVector;

			// Get the direction from the player to the agent
			const agentDirection = this.followAgentInstance.PrimaryPart!.Position.sub(this.humanoid.Position).Unit;

			// Calculate the cosine of the angle between the look vector and the agent direction
			const cosAngle = lookVector.Dot(agentDirection);

			// Check if the player is looking at the agent
			// Cosine is close to 1 for small angles (allowing for a slight deviation due to the perspective)
			if (cosAngle > 0.95) {
				print("Jumpscare!");
				this.jumpscareTriggered = true;
			}
		}
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
			this.followAgentInstance!.Parent = undefined;
		}
	}
}
