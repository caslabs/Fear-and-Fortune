import { Players } from "@rbxts/services";
import { t } from "@rbxts/t";
import PlayerStates from "../character-states";
import { EventManager } from "shared/EventBus/EventManager";
import { GameEventType } from "shared/EventBus/eventTypes";
import { AIEventTypes } from "shared/EventBus/AIEventTypes";
import PlayerStateController from "mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/character-states-controller";

enum AIState {
	Idle,
	IdentityFraud,
	Chase,
}

interface State {
	enter(): void;
	execute(dt: number): void;
	exit(): void;
}

class IdleState implements State {
	constructor(private aiIdentityManager: AIIdentityManager) {}

	enter() {
		print("Player State: Normal");
		this.aiIdentityManager.playerStateController.setState(PlayerStates.Normal);
	}

	execute(dt: number) {
		const target = this.aiIdentityManager.findNearestPlayer();
		if (target) {
			this.aiIdentityManager.changeState(AIState.Chase);
		}
	}

	exit() {}
}

class IdentityFraudState implements State {
	constructor(private aiIdentityManager: AIIdentityManager) {}

	enter() {
		print("Identiy Fraud Initialization");
		this.aiIdentityManager.playerStateController.setState(PlayerStates.Normal);
	}

	execute(dt: number) {
		print("Executing Identity Fraud");
	}

	exit() {}
}

class ChaseState implements State {
	constructor(private aiIdentityManager: AIIdentityManager) {}

	enter() {
		print("Player State: Chasing");
		this.aiIdentityManager.playerStateController.setState(PlayerStates.Chasing);
	}

	execute(dt: number) {
		const target = this.aiIdentityManager.findNearestPlayer();
		if (target) {
			const distance = target.Position.sub(this.aiIdentityManager.agentRootPart.Position).Magnitude;
			this.aiIdentityManager.humanoid.MoveTo(target.Position);
		} else {
			this.aiIdentityManager.changeState(AIState.Idle);
		}
		this.aiIdentityManager.playerStateController.setState(PlayerStates.Normal);
	}

	exit() {}
}

class StalkingState implements State {
	constructor(private aiIdentityManager: AIIdentityManager) {}
	/// Stalks the player
	enter() {
		print("Player State: Stalking");
		this.aiIdentityManager.playerStateController.setState(PlayerStates.Normal);
		print("Player State:");
	}

	execute(dt: number): void {}

	exit(): void {}
}

export class AIIdentityManager {
	private static instance: AIIdentityManager;
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

	public static getInstance(playerStateController: PlayerStateController): AIIdentityManager {
		if (!this.instance) {
			this.instance = new AIIdentityManager(playerStateController);
		}
		return this.instance;
	}

	async applyCharacterAppearanceToAgent(player: Player, agent: Model) {
		// Get the player's character appearance
		const characterAppearance = await Players.GetCharacterAppearanceAsync(player.UserId);

		// Clone the character appearance
		const clonedCharacter = characterAppearance.Clone();

		// Remove unnecessary parts or scripts from the cloned character
		// You can customize this part depending on what you want to keep or remove
		for (const child of clonedCharacter.GetChildren()) {
			if (child.IsA("Script") || child.IsA("LocalScript")) {
				child.Destroy();
			}
		}

		// Apply the cloned appearance to the AI agent
		// You can customize this part to apply the appearance to the agent in a specific way
		clonedCharacter.Parent = agent;
	}

	async createChaser(agent: Model) {
		assert(agent !== undefined && agent !== undefined, "Invalid MODEL!");

		const targetPlayer = Players.GetPlayers()[0]; // Replace this with the desired target player
		await this.applyCharacterAppearanceToAgent(targetPlayer, this.agent);

		const rootPart = agent.FindFirstChild("HumanoidRootPart");
		const humanoid = agent.FindFirstChildOfClass("Humanoid");

		// Check if the Model has a Humanoid
		if (!humanoid) {
			warn("Unable to find Model with Humanoid");
			return;
		}

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
