import { Players, Workspace } from "@rbxts/services";
import { t } from "@rbxts/t";
import PlayerStates from "../character-states";
import { EventManager } from "shared/EventBus/EventManager";
import { GameEventType } from "shared/EventBus/eventTypes";
import PlayerStateController from "mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/character-states-controller";

enum AIState {
	Idle,
	Interacting,
}

export class AINPCManager {
	private static instance: AINPCManager;
	private playerStateController: PlayerStateController;
	private eventManager: EventManager;

	private constructor(playerStateController: PlayerStateController) {
		this.playerStateController = playerStateController;
		this.eventManager = EventManager.getInstance();
	}

	public static getInstance(playerStateController: PlayerStateController): AINPCManager {
		if (!this.instance) {
			this.instance = new AINPCManager(playerStateController);
		}
		return this.instance;
	}

	createNPCAgent(agent: Model, interactionData: any) {
		// ...validate agent and set up initial state...
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
	}

	// ...other methods...
}
