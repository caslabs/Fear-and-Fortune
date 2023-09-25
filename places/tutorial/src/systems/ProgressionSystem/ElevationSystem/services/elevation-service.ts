import { Players } from "@rbxts/services";
import { Service } from "@flamework/core";
import { OnStart } from "@flamework/core";
import Remotes from "shared/remotes";

const UpdateElevationEvent = Remotes.Server.Get("UpdateElevationEvent");
@Service({})
export class ElevationSystem implements OnStart {
	private playerElevation: Map<Player, number>;

	constructor() {
		this.playerElevation = new Map<Player, number>();
	}

	onStart() {
		print("ElevationSystem Service started");
		Players.PlayerAdded.Connect((player) => this.initializePlayer(player));
	}

	async initializePlayer(player: Player) {
		//TODO: This is a hack, need to use character-controller to get the player's elevation
		let character: Model;
		if (player.Character) {
			character = player.Character;
		} else {
			character = (await player.CharacterAdded.Wait())[0];
		}
		const humanoidRootPart = character.WaitForChild("HumanoidRootPart") as BasePart;

		// Keep sending elevation data to the server
		//TODO: Still need to figure out how elevation is going to be used in our game system
		while (character) {
			wait(60);

			// Get the player's current elevation
			const elevation = humanoidRootPart.Position.Y;
			this.playerElevation.set(player, elevation);

			// Send the player's current elevation to the client
			UpdateElevationEvent.SendToPlayer(player, player, elevation);
		}
	}
}
