import { OnStart, Service } from "@flamework/core";

import Remotes from "shared/remotes";
import { TaskManager } from "../manager/TaskManager";
const CompleteObjectiveEvent = Remotes.Server.Get("CompleteObjectiveEvent");

@Service({})
export default class TaskSystemService implements OnStart {
	taskManager: TaskManager;

	constructor() {
		this.taskManager = new TaskManager();
	}

	public onStart() {
		print("TaskSystem Service Started");

		//Complete Objective
		CompleteObjectiveEvent.SetCallback((player: Player) => {
			this.taskManager.completeObjective();
		});
	}

	public completeObjective() {
		this.taskManager.completeObjective();
	}
}
