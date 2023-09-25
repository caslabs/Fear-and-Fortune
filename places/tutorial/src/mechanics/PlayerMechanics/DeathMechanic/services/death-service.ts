import { OnStart, Service } from "@flamework/core";
import { Players, Workspace, RunService } from "@rbxts/services";
import Remotes from "shared/remotes";

const baseplate = Workspace.WaitForChild("TutorialNode").WaitForChild("Baseplate") as BasePart;

interface DeathRule {
	condition: (lastPosition: Vector3, player: Player) => boolean;
	message: string;
	hint: string;
}

const deathRules: DeathRule[] = [
	{
		condition: (lastPosition) => lastPosition.Y < baseplate.Position.Y,
		message: "You fell to your death",
		hint: "Try not to fall next time...",
	},
	{
		condition: (lastPosition, player) => player.GetAttribute("JustReset") as boolean,
		message: "Another soul claimed...",
		hint: "You took the easy way out",
	},

	{
		condition: (lastPosition, player) => player.GetAttribute("LastDamagedByAI") as boolean,
		message: "You died to the Eyeless",
		hint: "Try not to look at it again... ",
	},
	// Add more rules here...
	// TODO: Add the entities here
];

const PlayerDeathEvent = Remotes.Server.Get("PlayerDeathEvent");

@Service({})
export default class DeathMechanic implements OnStart {
	onStart(): void {
		print("DeathMechanic Service started");
		Players.PlayerAdded.Connect((player) => {
			player.SetAttribute("JustReset", false);

			player.CharacterAdded.Connect((character) => {
				const humanoid = character.WaitForChild("Humanoid") as Humanoid;

				// Record the last known health of the character.
				let lastHealth: number = humanoid.Health;

				// Record the last known position of the character every second.
				let lastPosition: Vector3;
				const recording = RunService.Heartbeat.Connect(() => {
					if (character.PrimaryPart) {
						lastPosition = character.PrimaryPart.Position;
						lastHealth = humanoid.Health;
					}
				});

				humanoid.Died.Connect(() => {
					recording.Disconnect();

					// If the player's health dropped rapidly (e.g., within a single frame), they probably reset their character.
					if (lastHealth === humanoid.MaxHealth) {
						player.SetAttribute("JustReset", true);
					}

					for (const rule of deathRules) {
						if (rule.condition(lastPosition, player)) {
							print(`${player.Name} ${rule.message}.`);
							print(`hint: ${rule.hint}`);

							// Ping to Client to show the death screen
							PlayerDeathEvent.SendToPlayer(player, player, rule.message, rule.hint);
							break; // Stop checking other rules once we find one that applies
						}
					}

					player.SetAttribute("JustReset", false); // Reset attribute after death is processed
					player.SetAttribute("LastDamagedByAI", false); // Reset attribute after death is processed
				});
			});
		});
	}
}
