import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { Players } from "@rbxts/services";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import Remotes from "shared/remotes";

interface Attributes {}

const GetPlayerEvent = Remotes.Server.Get("GetPlayer");
@Component({
	tag: "AppearanceTrigger",
	instanceGuard: t.instanceIsA("Model"),
})
export class AppearanceComponent extends BaseComponent<Attributes> implements OnStart {
	onStart() {
		print("Appearance Object Component Initiated");

		// Get the user ID of the player

		//Get Character Appearance
		GetPlayerEvent.Connect((player) => {
			print("Player added, ID: ", player.UserId);
			//get the player's humanoid appearance
			const humanoidDescription = Players.GetHumanoidDescriptionFromUserId(player.UserId);
			print("Humanoid description: ", humanoidDescription);
			// Apply the humanoid description to the instance
			(this.instance.WaitForChild("Humanoid") as Humanoid).ApplyDescription(humanoidDescription);
			print("Humanoid description applied");
		});
	}
}
