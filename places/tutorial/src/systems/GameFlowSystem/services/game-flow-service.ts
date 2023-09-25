import { OnStart, Service } from "@flamework/core";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";

const GetHumanoidDescriptionFromUserIdEvent = Remotes.Server.Get("GetHumanoidDescriptionFromUserId");
@Service({})
export default class GameFlowSystemService implements OnStart {
	public onStart() {
		print("GameFlowSystem Service Started");
	}
}
