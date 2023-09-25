import { OnStart, Service } from "@flamework/core";
import { Players, StarterPlayer, UserInputService } from "@rbxts/services";
import Remotes from "shared/remotes";

const GetHumanoidDescriptionFromUserIdEvent = Remotes.Server.Get("GetHumanoidDescriptionFromUserId");
@Service({
	loadOrder: 9999,
})
export default class GameFlowServices implements OnStart {
	public onStart() {
		const disablePlayerControls = Remotes.Server.Get("disablePlayerControls");

		disablePlayerControls.Connect((player) => {
			player.DevTouchMovementMode = Enum.DevTouchMovementMode.Scriptable;
		});

		UserInputService.JumpRequest.Connect(() => {
			Players.LocalPlayer.Character?.FindFirstChildOfClass("Humanoid")?.ChangeState(
				Enum.HumanoidStateType.Jumping,
			);
		});

		GetHumanoidDescriptionFromUserIdEvent.SetCallback((player) => {
			print("Player: ", player);
			if (!player) {
				error("Player not found!");
			}
			const desc = Players.GetHumanoidDescriptionFromUserId(player.UserId);
			print("Returning description: ", desc);
			return "bruh"; // directly return the description
		});

		Players.PlayerAdded.Connect(async (player) => {
			// Wait for the character to load
			player.CharacterAdded.Connect((character) => {
				const humanoid = character.FindFirstChildOfClass("Humanoid");
				if (humanoid) {
					humanoid.WalkSpeed = 0;
					humanoid.JumpPower = 0;
					humanoid.JumpHeight = 0;
					humanoid.AutoJumpEnabled = false;
					humanoid.AutoRotate = false;
				}
			});
		});

		print("GameFlowSystem Service Started");
	}
}
