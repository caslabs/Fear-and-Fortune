import { OnStart } from "@flamework/core";
import { Players, Workspace } from "@rbxts/services";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import Remotes from "shared/remotes";

interface Attributes {}

@Component({
	tag: "BansheeTrapTool",
	instanceGuard: t.instanceIsA("Tool"),
})
export class BansheeTrapComponent extends BaseComponent<Attributes> implements OnStart {
	onStart() {
		print("Banshee Trap Tool Component Initiated");

		const tool = this.instance as Tool;
		const ToolPickupEvent = Remotes.Server.Get("ToolPickupEvent");
		const ToolRemovedEvent = Remotes.Server.Get("ToolRemovedEvent");
		tool.CanBeDropped = true;

		tool.GetPropertyChangedSignal("Parent").Connect(() => {
			// If the tool is picked up by a player.
			if (tool.Parent?.IsA("Model") && Players.GetPlayerFromCharacter(tool.Parent as Model)) {
				const player = Players.GetPlayerFromCharacter(tool.Parent as Model);
				if (!player) {
					error("Player not found!");
				}

				// Check if the tool is already in the player's backpack.
				const playerBackpack = player.FindFirstChild("Backpack");
				if (playerBackpack && !playerBackpack.FindFirstChild(tool.Name)) {
					print("Tool is not in the player's backpack.");
					print(playerBackpack?.FindFirstChild(tool.Name));
					// Only send the ToolPickupEvent if the tool is not already in the backpack.
					ToolPickupEvent.SendToPlayer(player, player, tool);
				} else {
					print(playerBackpack?.FindFirstChild(tool.Name));
					print("Tool is already in the player's backpack.");
				}

				tool.Activated.Connect(() => {
					print("Banshee Trap Interacted!");

					// Place the model (bear trap) on the ground in front of the player.
					const playerCharacter = Players.GetPlayerFromCharacter(tool.Parent as Model)?.Character;
					if (playerCharacter && playerCharacter.PrimaryPart) {
						const forwardDirection = playerCharacter.PrimaryPart.CFrame.LookVector;
						const newPosition = playerCharacter.PrimaryPart.Position.add(forwardDirection.mul(5));

						// Raycast down to find the position on the ground.
						const raycastParams = new RaycastParams();
						raycastParams.FilterType = Enum.RaycastFilterType.Blacklist;
						raycastParams.FilterDescendantsInstances = [playerCharacter];
						const raycastResult = Workspace.Raycast(newPosition, new Vector3(0, -1000, 0), raycastParams);
						const groundPosition = raycastResult?.Position ?? newPosition;

						// Create a new Model from the tool.
						const bansheeTrapModel = Workspace.FindFirstChild("BansheeTrap")?.Clone() as Model;
						if (!bansheeTrapModel) {
							print("No 'BansheeTrap' model found in Workspace.");
							return;
						}

						bansheeTrapModel.Name = "BansheeTrap";
						bansheeTrapModel.Parent = Workspace;

						const trapUnion = bansheeTrapModel.FindFirstChild("BansheeTrap") as BasePart;

						if (trapUnion) {
							bansheeTrapModel.PrimaryPart = trapUnion;

							// Add half of the UnionOperation's size to the y-coordinate of the ground position.
							const unionSizeHalf = trapUnion.Size.Y / 2;
							const groundPosition = (raycastResult?.Position ?? newPosition).add(
								new Vector3(0, unionSizeHalf, 0),
							);

							bansheeTrapModel.SetPrimaryPartCFrame(new CFrame(groundPosition));

							// Weld the model to the Workspace to keep it in place.
							Make("WeldConstraint", {
								Part0: bansheeTrapModel.PrimaryPart,
								Part1: Workspace.Terrain,
								Parent: bansheeTrapModel,
							});

							this.attachTouchFunction(bansheeTrapModel);

							// Remove the tool from the player's character.
							ToolRemovedEvent.SendToPlayer(player, player, tool);
							tool.Parent = undefined;
						} else {
							print("No 'Union' found inside the model.");
						}
					}
				});
			}
		});
	}

	attachTouchFunction(model: Model) {
		print("Banshee Trap Active Initiated");

		const primaryPart = model.PrimaryPart;
		if (primaryPart) {
			primaryPart.Touched.Connect((part) => {
				print("Touched event triggered!");

				// Check if the touched part belongs to a model named "Banshee"
				if (part.Parent?.Name === "Banshee") {
					print("Banshee touched!");

					if (part.Parent?.FindFirstChild("Humanoid")) {
						const humanoid = part.Parent.FindFirstChild("Humanoid") as Humanoid;
						humanoid.TakeDamage(humanoid.MaxHealth);
					}
				} else {
					print("Non-Banshee model touched, ignoring...");
				}
			});
		}
	}
}
