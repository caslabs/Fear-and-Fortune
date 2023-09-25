import { Players, Workspace } from "@rbxts/services";
import { t } from "@rbxts/t";
import PlayerStates from "../character-states";
import { EventManager } from "shared/EventBus/EventManager";
import { GameEventType } from "shared/EventBus/eventTypes";
import PlayerStateController from "mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/character-states-controller";

enum AIState {
	Idle,
	Mockery,
	Violant,
	Choas,
}

export class AICorruptionManager {
	private static instance: AICorruptionManager;
	private playerStateController: PlayerStateController;
	private eventManager: EventManager;

	private constructor(playerStateController: PlayerStateController) {
		this.playerStateController = playerStateController;
		this.eventManager = EventManager.getInstance();
	}

	public static getInstance(playerStateController: PlayerStateController): AICorruptionManager {
		if (!this.instance) {
			this.instance = new AICorruptionManager(playerStateController);
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

	createCorruptionAgent(agent: Model) {
		print("Creating Corruption Agent");
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

		const currentState = AIState.Idle;
		let previousState: AIState | undefined;

		// Connect to RunService.Heartbeat
		const heartbeatConnection = game.GetService("RunService").Heartbeat.Connect((dt) => {
			const target = this.findNearestPlayer(agent);
			//TODO: Listens to current story progression and character states
		});
	}

	private findNearestPlayer(agent: Model, minDistanceToChase = 10): BasePart | undefined {
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
