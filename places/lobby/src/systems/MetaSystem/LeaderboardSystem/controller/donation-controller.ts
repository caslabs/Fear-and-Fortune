import { Controller, OnInit, OnStart } from "@flamework/core";

@Controller({})
export default class DonationSystemController implements OnStart, OnInit {
	public onInit(): void {
		print("DonationSystem Controller initialized");
	}

	public onStart(): void {
		print("DonationSystem Controller started");
	}
}
