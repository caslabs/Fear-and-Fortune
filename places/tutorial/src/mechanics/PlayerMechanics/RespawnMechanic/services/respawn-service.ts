import { OnStart, Service } from "@flamework/core";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";

@Service({})
export default class RespawnMechanic implements OnStart {
	onStart(): void {
		print("RespawnMechanic Service started");
		const ToggleRespawn = Remotes.Server.Get("ToggleRespawn");

		// Listen for ToggleRespawn event from server, and disable respawning if it's enabled
		ToggleRespawn.Connect((respawnEnabled) => {
			if (respawnEnabled) {
				// Don't respawn player
				print("[INFO] Disabling respawn...");

				//Set Player's CharacterAutoLoads to false, apparantly this is the only way to disable respawning
				// only in the server...
				Players.CharacterAutoLoads = false;
			}
		});
	}
}
