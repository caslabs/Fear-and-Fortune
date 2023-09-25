import { Controller, OnInit, OnStart } from "@flamework/core";
import { UserInputService, ReplicatedStorage } from "@rbxts/services";
import Remotes from "shared/remotes";

@Controller()
export default class TaskSystemController implements OnInit, OnStart {
	constructor() {}

	onInit(): void {}

	onStart(): void {
		const completeObjective = Remotes.Client.Get("CompleteObjectiveEvent");
		const sendMessage = Remotes.Client.Get("SendMessage");

		print("TaskSystem Controller started");

		/*
		UserInputService.InputBegan.Connect((input) => {
			if (input.KeyCode === Enum.KeyCode.T) {
				completeObjective.CallServerAsync().then(() => {});
			}
		});
		/*

		sendMessage.Connect((message: string) => {
			print(message);
		});
	}
}
