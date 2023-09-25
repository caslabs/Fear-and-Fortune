import { Players, Workspace } from "@rbxts/services";
import { t } from "@rbxts/t";

import PlayerStates from "../character-states";
import { EventManager } from "shared/EventBus/EventManager";
import { GameEventType } from "shared/EventBus/eventTypes";
import PlayerStateController from "mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/character-states-controller";

enum AIState {
	Idle,
	TriggerJumpscare,
}

export class AIPsychologicalScareManager {
	private static instance: AIPsychologicalScareManager;
	private playerStateController: PlayerStateController;
	private eventManager: EventManager;

	private constructor(playerStateController: PlayerStateController) {
		this.playerStateController = playerStateController;
		this.eventManager = EventManager.getInstance();
	}

	public static getInstance(playerStateController: PlayerStateController): AIPsychologicalScareManager {
		if (!this.instance) {
			this.instance = new AIPsychologicalScareManager(playerStateController);
		}
		return this.instance;
	}

	private isFirstPerson(playerCamera: Camera): boolean {
		const character = Players.LocalPlayer.Character;
		if (character) {
			const head = character.FindFirstChild("Head");
			if (head) {
				const distance = playerCamera.CFrame.Position.sub((head as BasePart).Position).Magnitude;

				return distance <= 1;
			}
		}
		return false;
	}

	createJumpscareAgent(agent: Model) {
		assert(agent !== undefined && agent !== undefined, "Invalid MODEL!");
		const humanoid = agent.FindFirstChildOfClass("Humanoid");
		const rootPart = agent.FindFirstChild("HumanoidRootPart");

		// Check if the root is a valid agent
		if (!t.instanceIsA("BasePart")(rootPart)) {
			return;
		}

		// Check if the humanoid is a valid agent
		if (!t.instanceIsA("Humanoid")(humanoid)) {
			return;
		}

		let currentState = AIState.Idle;
		let previousState: AIState | undefined;

		const minDistanceToTrigger = 30; // Set your preferred trigger distance
		const angleThreshold = math.cos(math.rad(30)); // Set your preferred angle threshold, 30 degrees in this example
		let isJumped = false;
		// Connect to RunService.Heartbeat
		const heartbeatConnection = game.GetService("RunService").Heartbeat.Connect((dt) => {
			const target = this.findNearestPlayer(agent);

			if (target) {
				const distance = target.Position.sub(rootPart.Position).Magnitude;
				if (distance <= minDistanceToTrigger) {
					const character = Players.LocalPlayer.Character;
					if (!character) return;
					const head = character.FindFirstChild("Head") as BasePart;
					if (!head) return;
					const playerLookVector = head.CFrame.LookVector;

					const enemyToPlayer = rootPart.Position.sub(target.Position).Unit;
					const dotProduct = enemyToPlayer.Dot(playerLookVector);

					if (dotProduct > angleThreshold && !isJumped) {
						currentState = AIState.TriggerJumpscare;
						isJumped = true;
					} else {
						currentState = AIState.Idle;
					}
				} else {
					currentState = AIState.Idle;
				}
			} else {
				currentState = AIState.Idle;
			}

			// Only update the player state if it has changed
			if (currentState !== previousState) {
				if (currentState === AIState.TriggerJumpscare) {
					this.eventManager.dispatchEvent(GameEventType.JumpScare, {
						jumpscare: "", // Replace this with the desired jumpscare ID from your jumpscare script
					});
					this.eventManager.dispatchEvent(GameEventType.PostProcessing, {
						state: "jumpscarezoom", // Use the new jumpscare
					});
					print("Player State: Jumpscared");

					// Make the enemy disappear
					agent.Parent = undefined;

					// Set a delay before the enemy reappears
					Promise.delay(5).then(() => {
						this.playerStateController.setState(PlayerStates.Normal);
						this.eventManager.dispatchEvent(GameEventType.PostProcessing, {
							state: "default", // Use the new jumpscare
						});
						print("Player State: Normal");
					});

					// Set a delay before the enemy reappears
					Promise.delay(20).then(() => {
						isJumped = false;
						if (humanoid.Health > 0) {
							agent.Parent = Workspace; // Make the enemy reappear in the Workspace
						}
					});
				} else if (currentState === AIState.Idle) {
					this.playerStateController.setState(PlayerStates.Normal);
					this.eventManager.dispatchEvent(GameEventType.PostProcessing, {
						state: "default", // Use the new jumpscare
					});
					print("Player State: Normal");
				}
				previousState = currentState;
			}
		});
	}

	private findNearestPlayer(agent: Model, minDistanceToChase = 100): BasePart | undefined {
		const players = Players.GetPlayers();
		let nearestPlayer: Player | undefined;
		let minDistance = math.huge;

		for (const player of players) {
			const character = player.Character;
			if (character) {
				const rootPart = character.FindFirstChild("HumanoidRootPart") as BasePart;
				if (rootPart) {
					const agentPart = agent.FindFirstChild("HumanoidRootPart") as BasePart;
					if (agentPart) {
						const distance = rootPart.Position.sub(agentPart.Position).Magnitude;
						if (distance < minDistance) {
							nearestPlayer = player;
							minDistance = distance;
						}
					}
				}
			}
		}

		if (nearestPlayer) {
			const nearestPlayerRootPart = nearestPlayer.Character?.FindFirstChild("HumanoidRootPart") as BasePart;
			const agentPart = agent.FindFirstChild("HumanoidRootPart") as BasePart;

			if (nearestPlayerRootPart && agentPart) {
				const distance = nearestPlayerRootPart.Position.sub(agentPart.Position).Magnitude;
				if (distance < minDistanceToChase) {
					return nearestPlayerRootPart;
				}
			}
		}
		return undefined;
	}
}
