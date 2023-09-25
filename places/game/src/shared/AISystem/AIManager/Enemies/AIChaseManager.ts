import { Players } from "@rbxts/services";
import { t } from "@rbxts/t";
import PlayerStates from "../character-states";
import { EventManager } from "shared/EventBus/EventManager";
import { GameEventType } from "shared/EventBus/eventTypes";
import { AIEventTypes } from "shared/EventBus/AIEventTypes";
import PlayerStateController from "mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/character-states-controller";

enum AIState {
	Idle,
	Chase,
}

interface State {
	enter(): void;
	execute(dt: number): void;
	exit(): void;
}

class IdleState implements State {
	constructor(private aiChaserManager: AIChaserManager) {}

	enter() {
		print("Player State: Normal");
		this.aiChaserManager.playerStateController.setState(PlayerStates.Normal);
	}

	execute(dt: number) {
		const target = this.aiChaserManager.findNearestPlayer();
		if (target) {
			this.aiChaserManager.changeState(AIState.Chase);
		}
	}

	exit() {}
}

class ChaseState implements State {
	constructor(private aiChaserManager: AIChaserManager) {}

	enter() {
		print("Player State: Chasing");
		this.aiChaserManager.playerStateController.setState(PlayerStates.Chasing);
	}

	execute(dt: number) {
		const target = this.aiChaserManager.findNearestPlayer();
		if (target) {
			const distance = target.Position.sub(this.aiChaserManager.agentRootPart.Position).Magnitude;
			this.aiChaserManager.humanoid.MoveTo(target.Position);
		} else {
			this.aiChaserManager.changeState(AIState.Idle);
		}
		this.aiChaserManager.playerStateController.setState(PlayerStates.Normal);
	}

	exit() {}
}

class StalkingState implements State {
	constructor(private aiChaserManager: AIChaserManager) {}
	/// Stalks the player
	enter() {
		print("Player State: Stalking");
		this.aiChaserManager.playerStateController.setState(PlayerStates.Normal);
		print("Player State:");
	}

	execute(dt: number): void {}

	exit(): void {}
}

export class AIChaserManager {
	private static instance: AIChaserManager;
	public playerStateController: PlayerStateController;
	public eventManager: EventManager;
	public agent: Model;
	public agentRootPart: BasePart;
	public humanoid: Humanoid;

	private currentState: State;

	private constructor(playerStateController: PlayerStateController) {
		this.playerStateController = playerStateController;
		this.eventManager = EventManager.getInstance();

		// Initialize the properties with dummy instances
		this.agent = new Instance("Model");
		this.agentRootPart = new Instance("Part");
		this.humanoid = new Instance("Humanoid");
		this.currentState = new IdleState(this);
	}

	public static getInstance(playerStateController: PlayerStateController): AIChaserManager {
		if (!this.instance) {
			this.instance = new AIChaserManager(playerStateController);
		}
		return this.instance;
	}

	createChaser(agent: Model) {
		assert(agent !== undefined && agent !== undefined, "Invalid MODEL!");
		this.agent = agent;
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

		this.agentRootPart = rootPart;
		this.humanoid = humanoid;

		this.changeState(AIState.Idle);

		// Connect to RunService.Heartbeat
		const heartbeatConnection = game.GetService("RunService").Heartbeat.Connect((dt) => {
			this.currentState.execute(dt);
		});
	}

	public changeState(newState: AIState): void {
		if (this.currentState) {
			this.currentState.exit();
		}

		switch (newState) {
			case AIState.Idle:
				this.currentState = new IdleState(this);
				break;
			case AIState.Chase:
				this.currentState = new ChaseState(this);
				break;
			default:
				warn("Invalid state");
		}

		this.currentState.enter();
	}

	public findNearestPlayer(minDistanceToChase = 10): BasePart | undefined {
		let nearestPlayer: Player | undefined;
		let nearestDistance = minDistanceToChase;

		for (const player of Players.GetPlayers()) {
			const character = player.Character;
			if (!character) continue;

			const rootPart = character.FindFirstChild("HumanoidRootPart");
			if (!rootPart || !t.instanceIsA("BasePart")(rootPart)) continue;

			const distance = rootPart.Position.sub(this.agentRootPart.Position).Magnitude;
			if (distance < nearestDistance) {
				nearestDistance = distance;
				nearestPlayer = player;
			}
		}

		return nearestPlayer?.Character?.FindFirstChild("HumanoidRootPart") as BasePart | undefined;
	}
}
