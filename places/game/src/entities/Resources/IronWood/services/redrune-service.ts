import { OnStart } from "@flamework/core";
import { Players, Workspace } from "@rbxts/services";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import Remotes from "shared/remotes";

interface Attributes {}

@Component({
	tag: "RedRuneToolTrigger",
	instanceGuard: t.instanceIsA("Tool"),
})
export class RedRuneComponent extends BaseComponent<Attributes> implements OnStart {
	onStart() {
		print("Red Rune Tool Component Initiated");

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
					print("Bear Trap Interacted!");

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
						const redRuneModel = Workspace.FindFirstChild("ExitPortal")?.Clone() as Model;
						if (!redRuneModel) {
							print("No 'ExitPortal' model found in Workspace.");
							return;
						}

						redRuneModel.Name = "RedRuneExitPortal";
						redRuneModel.Parent = Workspace;

						tool.GetChildren().forEach((child) => {
							if (child.IsA("BasePart")) {
								child.Parent = redRuneModel;
							}
						});

						const trapUnion = redRuneModel.FindFirstChild("ExitPortal") as BasePart;

						if (trapUnion) {
							redRuneModel.PrimaryPart = trapUnion;

							// Add half of the UnionOperation's size to the y-coordinate of the ground position.
							const unionSizeHalf = trapUnion.Size.Y / 2;
							let groundPosition = (raycastResult?.Position ?? newPosition).add(
								new Vector3(0, unionSizeHalf, 0),
							);

							groundPosition = (raycastResult?.Position ?? newPosition).add(new Vector3(0, 6, 0));

							redRuneModel.SetPrimaryPartCFrame(new CFrame(groundPosition));
							//then add +5 to the y-coordinate of the ground position.

							print("Red Rune Model Placed");
							// TODO: is this good? Play 3D Spatial Sound
							// Broken, only plays once and then never again...
							const soundID = "13983704227";
							const sound = `rbxassetid://${soundID}`;
							const soundInstance = new Instance("Sound");
							soundInstance.SoundId = sound;
							soundInstance.Parent = redRuneModel;
							soundInstance.Volume = 7;
							soundInstance.MaxDistance = 10;
							soundInstance.Play();

							// Weld the model to the Workspace to keep it in place.
							Make("WeldConstraint", {
								Part0: redRuneModel.PrimaryPart,
								Part1: Workspace.Terrain,
								Parent: redRuneModel,
							});

							this.attachTouchFunction(redRuneModel);

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
		print("Bear Trap Active Initiated");

		const primaryPart = model.PrimaryPart;
		if (primaryPart) {
			primaryPart.Touched.Connect((part) => {
				//TODO: Make it the teleport
			});
		}
	}
}
