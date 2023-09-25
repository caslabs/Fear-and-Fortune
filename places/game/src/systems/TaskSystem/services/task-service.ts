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
	}

	public startNextObjective() {
		this.taskManager.startNextObjective();
	}
}
