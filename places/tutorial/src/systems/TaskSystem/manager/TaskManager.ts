import { ReplicatedStorage } from "@rbxts/services";
import { params } from "./parameters";
import Remotes from "shared/remotes";

const sendMessage = Remotes.Server.Get("SendMessage");

//TODO: Might be useful for Boss System
export class TaskManager {
	private currentDay: number;

	constructor() {
		this.currentDay = 1;
	}

	startDay(): void {
		// Get the objective for the current day
		const objective = params.objectives[this.currentDay - 1];
		sendMessage.SendToAllPlayers(`Day ${this.currentDay}: ${objective}`);
	}

	completeObjective(): void {
		// Check if there are more objectives
		if (this.currentDay < params.objectives.size()) {
			this.startDay();
			this.currentDay++;
		} else {
			sendMessage.SendToAllPlayers("Congratulations, you've completed all objectives and won the game!");
		}
	}

	failObjective(): void {
		sendMessage.SendToAllPlayers("You failed to complete the objective and lost the game.");
	}
}
