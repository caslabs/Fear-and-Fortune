import { Players } from "@rbxts/services";
import { DiscordWebhook, DiscordEmbed } from "@rbxts/discord-webhook";
import { OnStart, Service } from "@flamework/core";

const webhookUrl =
	"https://hooks.hyra.io/api/webhooks/872426946057867275/gawsTvbbVyCwMXqtVU_b5bzc0QuIcvVSRmLFtMjFSaA_UJotl9J5waEfMSMaLiYWZnzD";
const webhook = new DiscordWebhook(webhookUrl);

@Service({})
export default class DiscordService implements OnStart {
	public onStart() {
		print("DiscordService Service Started");

		Players.PlayerAdded.Connect((player) => {
			const embed = new DiscordEmbed()
				.setTitle("Player Joined")
				.setDescription(player.Name + " has joined the game")
				.addField(
					"Investigate",
					"https://www.roblox.com/games/13733616492/PLAYTEST-The-Yeti-of-Mount-Everest",
					true,
				)
				.setColor(new Color3(46, 204, 113));

			print(webhook.send(embed));
		});

		Players.PlayerRemoving.Connect((player) => {
			const embed = new DiscordEmbed()
				.setTitle("Player Left")
				.setDescription(player.Name + " has left the game")
				.addField(
					"Investigate",
					"https://www.roblox.com/games/13733616492/PLAYTEST-The-Yeti-of-Mount-Everest",
					true,
				)
				.setColor(new Color3(46, 204, 113));

			print(webhook.send(embed));
		});
	}
}
