import { Controller, OnInit, OnStart } from "@flamework/core";
import LifeMechanic from "../../LifeMechanic/controller/life-controller";

@Controller()
export default class RespawnMechanic implements OnStart, OnInit {
	constructor(private readonly lifeMechanic: LifeMechanic) {}

	onInit(): void {}

	onStart(): void {
		print("RespawnMechanic Controller started");
	}
}
