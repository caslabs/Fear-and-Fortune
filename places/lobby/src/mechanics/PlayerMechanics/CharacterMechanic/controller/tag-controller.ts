import { TextChatService, Players } from "@rbxts/services";
import { Controller, OnInit, OnStart } from "@flamework/core";

/*
Social Feature: Enables Roles Identification for each player.

*/
const roles: { [key: string]: number[] } = {
	"The Boys": [
		11697914, // qwerty
		710641889, // kenneth
		682379885, // laron
		1024253883, // david
		661351256, // tim
		1032860613, // manny
		1683893477, // keaka
	],
	"Senior Beta Tester": [
		1805616465, //Umderstood,
		3530383896, // El Golbino
		1341618742, // OGMurasaki
	],
};

@Controller({
	loadOrder: 99999, // Try to make this run last
})
export class TagMechanicController implements OnInit, OnStart {
	constructor() {}

	onInit(): void {}

	onStart(): void {
		// Mock-up, replace with actual TextChatService API when available
		TextChatService.OnIncomingMessage = (message: TextChatMessage) => this.onIncomingMessage(message);
		print("TagMechanicController started");
	}

	private onIncomingMessage(message: TextChatMessage): TextChatMessageProperties {
		const properties = new Instance("TextChatMessageProperties"); // Mock-up, replace with actual API when available

		if (message.TextSource) {
			const player = Players.GetPlayerByUserId(message.TextSource.UserId);

			if (player) {
				// Default role
				let roleName = "Beta Tester";
				properties.PrefixText = `[${roleName}] ${message.PrefixText}`; // Mock-up, replace with actual API when available

				// Check for specific roles
				for (const [role, userIds] of pairs(roles)) {
					if (userIds.includes(player.UserId)) {
						roleName = role as string;
						properties.PrefixText = `[${roleName}] ${message.PrefixText}`; // Mock-up, replace with actual API when available
						break;
					}
				}
			}
		}

		return properties;
	}
}
