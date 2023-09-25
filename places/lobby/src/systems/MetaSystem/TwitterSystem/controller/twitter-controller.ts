import { Controller, OnInit, OnStart } from "@flamework/core";

@Controller({})
export default class TwitterSystemController implements OnStart, OnInit {
	public onInit(): void {
		print("TwitterSystem Controller initialized");
	}

	public onStart(): void {
		print("TwitterSystem Controller started");
	}
}
