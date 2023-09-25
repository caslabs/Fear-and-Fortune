import { ReplicatedStorage } from "@rbxts/services";
import { params } from "./parameters";
import Remotes from "shared/remotes";

const sendMessage = Remotes.Server.Get("SendMessage");

//TODO: Might be useful for Boss System
export class TaskManager {
	private currentObjective: number;

	constructor() {
		this.currentObjective = 1;
	}

	completeObjective(): void {
		// Get the objective for the current day
		const objective = params.objectives[this.currentObjective];
		sendMessage.SendToAllPlayers(`Next Objective: ${objective}`);
	}

	startNextObjective(): void {
		// Check if there are more objectives
		if (this.currentObjective < params.objectives.size()) {
			this.completeObjective();
			this.currentObjective++;
		} else {
			sendMessage.SendToAllPlayers("Congratulations, you've completed all objectives and won the game!");
		}
	}

	failObjective(): void {
		sendMessage.SendToAllPlayers("You failed to complete the objective and lost the game.");
	}
}
