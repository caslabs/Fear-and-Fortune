import { OnStart } from "@flamework/core";
import { Players, Workspace, UserInputService, ContextActionService } from "@rbxts/services";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";
import Remotes from "shared/remotes";

interface Attributes {}
// Define ToolData for the Rifle
//TODO: Prototype
type ToolData = {
	ammo: number;
	maxAmmo: number;
};
const rifleData: ToolData = {
	ammo: 8, // Change these values as per your needs
	maxAmmo: 8,
};

const PlayGunShakeEvent = Remotes.Server.Get("PlayGunShake");
const ToolPickupEvent = Remotes.Server.Get("ToolPickupEvent");
const ToolRemovedEvent = Remotes.Server.Get("ToolRemovedEvent");
const UpdateAmmoEvent = Remotes.Server.Get("UpdateAmmoEvent");

// TODO: is this good? Play 3D Spatial Sound
// Broken, only plays once and then never again...
const soundID = "7935556153";
const sound = `rbxassetid://${soundID}`;
const soundInstance = new Instance("Sound");
soundInstance.SoundId = sound;

@Component({
	tag: "RifleTool",
	instanceGuard: t.instanceIsA("Tool"),
})
export class RifleComponent extends BaseComponent<Attributes> implements OnStart {
	rifleData: ToolData; // Make rifleData a member variable
	fireConnected: boolean;

	constructor() {
		super();

		this.rifleData = {
			ammo: 8, // Change these values as per your needs
			maxAmmo: 8,
		};

		this.fireConnected = false;
	}

	onStart() {
		print("Rifle Tool Component Initiated");
		const tool = this.instance as Tool;

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
					ToolPickupEvent.SendToPlayer(player, player, tool, this.rifleData);
					UpdateAmmoEvent.SendToPlayer(player, this.rifleData.ammo);
				} else {
					print(playerBackpack?.FindFirstChild(tool.Name));
					print("Tool is already in the player's backpack.");
				}

				// Bind to mouse button 1 for PC users
				if (!this.fireConnected) {
					tool.Activated.Connect(() => {
						this.fire(player);
					});
					this.fireConnected = true;
				}
			}
		});
	}

	fire(player: Player) {
		if (this.rifleData.ammo > 0) {
			this.rifleData.ammo -= 1; // Reduce ammo by 1
			print("FIRE!");
			PlayGunShakeEvent.SendToPlayer(player);
			UpdateAmmoEvent.SendToPlayer(player, this.rifleData.ammo);
			print("Ammo: ", this.rifleData.ammo);

			soundInstance.Parent = player.Character;
			soundInstance.Volume = 15;
			soundInstance.MaxDistance = 10;
			soundInstance.Play();

			const character = player.Character;
			if (!character) {
				error("Character not found!");
			}

			const humanoid = character.WaitForChild("Humanoid") as Humanoid;
			humanoid.BreakJointsOnDeath = false;
			const humanoidRootPart = character.FindFirstChild("HumanoidRootPart") as Part; // here, we set instance

			const cameraDirection = Workspace.CurrentCamera?.CFrame.LookVector;
			if (!cameraDirection) {
				error("Camera direction not found!");
			}

			if (t.instanceIsA("Part")(humanoidRootPart)) {
				const bullet = new Instance("Part");
				bullet.BrickColor = new BrickColor("Black");
				bullet.Shape = Enum.PartType.Ball;
				bullet.Size = new Vector3(0.5, 0.5, 0.5);

				const lookVector = humanoidRootPart.CFrame.LookVector;

				bullet.Position = humanoidRootPart.Position.add(lookVector.mul(2));

				const antiGravity = new Instance("BodyForce");
				antiGravity.Force = new Vector3(0, Workspace.Gravity * bullet.GetMass(), 0);
				antiGravity.Parent = bullet;

				bullet.Parent = Workspace;

				const bulletVelocity = new Instance("BodyVelocity");
				bulletVelocity.Velocity = lookVector.mul(100); // Use the LookVector directly for the bullet's velocity
				bulletVelocity.Parent = bullet;

				print("Bullet Velocity: ", bulletVelocity.Velocity);

				bullet.Touched.Connect(() => {
					antiGravity.Destroy();
					print("Touched event triggered!");
					bullet.Destroy();
				});
			} else {
				error("HumanoidRootPart not found!");
			}
		} else {
			print("No ammo left!");
		}
	}

	attachTouchFunction(model: Model) {
		print("Rifle Active Initiated");

		const primaryPart = model.PrimaryPart;
		if (primaryPart) {
			primaryPart.Touched.Connect((part) => {
				print("Touched event triggered!");
				if (part.Parent?.FindFirstChild("Humanoid")) {
					const humanoid = part.Parent.FindFirstChild("Humanoid") as Humanoid;
					humanoid.TakeDamage(humanoid.MaxHealth);
				}
			});
		}
	}
}
