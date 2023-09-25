import { Players } from "@rbxts/services";
import { DiscordWebhook, DiscordEmbed } from "@rbxts/discord-webhook";
import { OnStart, Service } from "@flamework/core";

const webhookUrl =
	"https://hooks.hyra.io/api/webhooks/872426946057867275/gawsTvbbVyCwMXqtVU_b5bzc0QuIcvVSRmLFtMjFSaA_UJotl9J5waEfMSMaLiYWZnzD";
const webhook = new DiscordWebhook(webhookUrl);

// Mapping of game IDs to Discord messages
const gameMessages: Record<number, string> = {
	13123: "Player has successfully joined Lobby",
	45456: "Player has successfully joined Game Session",
	// ... add more game IDs and messages as needed
};

/*
Discord Service 


*/
@Service({})
export default class DiscordService implements OnStart {
	public onStart() {
		print("DiscordService Service Started");

		Players.PlayerAdded.Connect((player) => this.handlePlayerEvent(player, "joined"));
		Players.PlayerRemoving.Connect((player) => this.handlePlayerEvent(player, "left"));
	}

	private handlePlayerEvent(player: Player, eventType: "joined" | "left") {
		const currentGameId = game.PlaceId;
		const discordMessage = gameMessages[currentGameId];

		// Ensure there's a message to send for this game ID
		// eslint-disable-next-line roblox-ts/lua-truthiness
		if (!discordMessage) {
			print(`No Discord message found for game ID: ${currentGameId}`);
			return;
		}

		const title = `Player ${eventType}`;
		const description = `${player.Name} has ${eventType} the game with game ID: ${currentGameId}`;
		const embed = new DiscordEmbed()
			.setTitle(title)
			.setDescription(description)
			.addField("Investigate", `https://www.roblox.com/games/${currentGameId}`, true)
			.setColor(new Color3(46, 204, 113));

		print(webhook.send(embed));
	}
}
