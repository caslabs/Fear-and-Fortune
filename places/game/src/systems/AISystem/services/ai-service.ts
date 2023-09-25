import { OnStart, Service } from "@flamework/core";
import { Workspace } from "@rbxts/services/";
import Remotes from "shared/remotes";

/*
AI System Configuration

*/
@Service({})
export default class AISystemService implements OnStart {
	public onStart() {
		print("AISystem Service Started");

		const RequestSpawnAI = Remotes.Server.Get("RequestSpawnAI");
		const SpawnAI = Remotes.Server.Get("SpawnAI");
		// Listen for a request to spawn an AI
		RequestSpawnAI.Connect((player, aiType, spawnLocation) => {
			this.spawnAI(aiType, spawnLocation, player);
			print("spawned a AI");
		});
	}

	private spawnAI(aiType: string, spawnLocation: Vector3, player: Player): string {
		const newAI = new Instance("Part");
		newAI.Name = aiType;
		newAI.Position = spawnLocation;
		newAI.Parent = Workspace;

		newAI.Touched.Connect((part) => {
			if (part.Parent?.FindFirstChild("Humanoid")) {
				const humanoid = part.Parent.FindFirstChild("Humanoid") as Humanoid;
				humanoid.TakeDamage(humanoid.MaxHealth);
				player.SetAttribute("LastDamagedByAI", true);
			}
		});

		return newAI.Name;
	}
}
