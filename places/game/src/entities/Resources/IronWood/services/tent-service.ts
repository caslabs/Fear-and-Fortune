import { OnStart } from "@flamework/core";
import { Players, Workspace } from "@rbxts/services";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import Remotes from "shared/remotes";

interface Attributes {}

@Component({
	tag: "MakeshiftTentTool",
	instanceGuard: t.instanceIsA("Tool"),
})
export class MakeshiftTentComponent extends BaseComponent<Attributes> implements OnStart {
	onStart() {
		print("MakeshiftTent Tool Component Initiated");

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
					print("MakeshiftTent Interacted!");

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
						//let groundPosition = raycastResult?.Position ?? newPosition;

						// Create a new Model from the tool.
						const MakeshiftTentModel = Workspace.FindFirstChild("MakeshiftTent")?.Clone() as Model;
						if (!MakeshiftTentModel) {
							print("No 'MakeshiftTent' model found in Workspace.");
							return;
						}

						MakeshiftTentModel.Name = "MakeshiftTent";
						MakeshiftTentModel.Parent = Workspace;

						tool.GetChildren().forEach((child) => {
							if (child.IsA("BasePart")) {
								child.Parent = MakeshiftTentModel;
							}
						});

						const tentBase = (MakeshiftTentModel.FindFirstChild("MakeshiftTent") as Model)
							.PrimaryPart as BasePart;

						// Add half of the UnionOperation's size to the y-coordinate of the ground position.
						const unionSizeHalf = tentBase.Size.Y / 2;
						const groundPosition = (raycastResult?.Position ?? newPosition).add(
							new Vector3(0, unionSizeHalf, 0),
						);

						MakeshiftTentModel.SetPrimaryPartCFrame(new CFrame(groundPosition));
						//then add +5 to the y-coordinate of the ground position.

						print("MakeshiftTent Model Placed");

						// Weld the model to the Workspace to keep it in place.
						Make("WeldConstraint", {
							Part0: MakeshiftTentModel.PrimaryPart,
							Part1: Workspace.Terrain,
							Parent: MakeshiftTentModel,
						});

						this.attachTouchFunction(MakeshiftTentModel);

						// Remove the tool from the player's character.
						ToolRemovedEvent.SendToPlayer(player, player, tool);
						tool.Parent = undefined;
					}
				});
			}
		});
	}

	attachTouchFunction(model: Model) {
		print("Bear Trap Active Initiated");

		const primaryPart = model.PrimaryPart;
		if (primaryPart) {
			primaryPart.Touched.Connect((part) => {
				//TODO: Make it the teleport
			});
		}
	}
}
