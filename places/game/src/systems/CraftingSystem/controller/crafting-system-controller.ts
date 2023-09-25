import { Controller, OnInit, OnStart } from "@flamework/core";

@Controller({})
export default class CraftSystemController implements OnStart, OnInit {
	public onInit(): void {
		print("CraftSystemController initialized");
	}

	public onStart(): void {
		print("CraftSystemController started");
	}
}
