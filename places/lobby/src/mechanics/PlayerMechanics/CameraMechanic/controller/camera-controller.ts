import { Controller, OnStart, OnInit } from "@flamework/core";
import { Players, RunService, UserInputService, Workspace } from "@rbxts/services";
import CharacterMechanic from "mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller";
import CameraShaker from "@caslabs/roblox-modified-camera-shaker";

//This controls the VFX of the player's camera
const LOCAL_PLAYER = Players.LocalPlayer;
const camera = Workspace.CurrentCamera!;
const cursor = new Instance("ImageLabel");
const camShakeWalk = new CameraShaker(
	Enum.RenderPriority.Camera.Value,
	(shakeCFrame) => (camera.CFrame = camera.CFrame.mul(shakeCFrame)),
);

const camShakeRun = new CameraShaker(
	Enum.RenderPriority.Camera.Value,
	(shakeCFrame) => (camera.CFrame = camera.CFrame.mul(shakeCFrame)),
);

/*
Aggregated system of Camera sates. Enables the First Person, Head Bobbing, and
Zoom Mechanics

TODO: Modularize First, Spectator, and other Camera States.
TODO: Zoom Mechanic as an independent?

*/
@Controller({
	loadOrder: 3,
})
export default class CameraMechanic implements OnStart, OnInit {
	private headBobbingEnabled: boolean;
	private isZooming: boolean;
	private renderSteppedConnection: RBXScriptConnection | undefined; // Added this line
	private currentPlayerToSpectate: Player | undefined;

	//Test
	private desiredCameraCFrame: CFrame = new CFrame();
	private prevMousePos: Vector2 = new Vector2();
	constructor(private readonly characterController: CharacterMechanic) {
		this.headBobbingEnabled = true;
		this.isZooming = false;
	}

	public onInit(): void {
		this.prevMousePos = UserInputService.GetMouseLocation();
	}

	public onStart(): void {
		print("CameraMechanic Controller started");
	}

	//TODO: This needs to be verified if it is already exist
	public enableTitleCamera(): void {
		//Apparently, having this will always show the title, without it - its random.
		const character = LOCAL_PLAYER.Character || LOCAL_PLAYER.CharacterAdded.Wait()[0];
		const humanoid = character.WaitForChild("Humanoid") as Humanoid;
		const head = character.WaitForChild("Head") as BasePart;

		camera.CameraType = Enum.CameraType.Scriptable;

		//TODO: add typing Workspace.TutorialNode
		const TitlePartCamera = Workspace.WaitForChild("TutorialNode").WaitForChild("TitleCam") as Part;
		camera.CFrame = TitlePartCamera.CFrame;

		this.desiredCameraCFrame = TitlePartCamera.CFrame;
		// Disconnect previous connection, if it exists
		if (this.renderSteppedConnection !== undefined) {
			this.renderSteppedConnection.Disconnect();
		}

		// Save connection to RenderStepped event
		//this.renderSteppedConnection = RunService.RenderStepped.Connect((dt) => this.updateCamera(dt));
		print("Enabled Title Camera");
	}

	public enableLobbyCamera(): void {
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.FindFirstChild("Humanoid") as Humanoid;

		// Check if the character and humanoid are available
		if (!character || !humanoid) {
			print("Dev camera cannot be enabled because the character or humanoid is not available");
			return;
		}

		camera.CameraType = Enum.CameraType.Custom;
		camera.CameraSubject = humanoid;
		LOCAL_PLAYER.CameraMaxZoomDistance = math.huge; // No maximum zoom limit
		LOCAL_PLAYER.CameraMinZoomDistance = 20; // Minimum zoom limit

		// Set the mouse behavior back to default
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
		LOCAL_PLAYER.CameraMode = Enum.CameraMode.Classic; // Classic camera mode

		print("[DEBUG] Current mouse behavior: " + UserInputService.MouseBehavior.Name);
		print("[DEBUG] Current zoom level: " + UserInputService.MouseBehavior.Name);
		// Disconnect the RenderStepped connection if it exists
		if (this.renderSteppedConnection !== undefined) {
			this.renderSteppedConnection.Disconnect();
		}

		print("[INFO] Dev camera enabled");
	}

	//TODO: Intense Matrix Math is involved here for camera effects aesthetics
	private updateCamera(dt: number): void {}

	//TODO: Implement spectate camera
	public enableSpectateCamera(): void {
		print("Switching to Spectate Camera");

		// Get the list of players
		let players = Players.GetPlayers();

		// Remove the local player from the list
		players = players.filter((player) => player !== LOCAL_PLAYER);

		// Set the first player as the player to spectate
		this.currentPlayerToSpectate = players[0];

		// Change the camera view to the player
		this.changeCameraView(this.currentPlayerToSpectate);
	}

	// Function to change the camera view to the given player
	private changeCameraView(player: Player): void {
		// Get the character and humanoid
		const character = player.Character;
		const humanoid = character?.FindFirstChild("Humanoid") as Humanoid;

		// Check if the character and humanoid are available
		if (!character || !humanoid) {
			print("Spectate camera cannot be enabled because the character or humanoid is not available");
			return;
		}

		camera.CameraType = Enum.CameraType.Custom;
		camera.CameraSubject = humanoid;
		LOCAL_PLAYER.CameraMaxZoomDistance = 20; // Set max zoom distance for 3rd person view
		LOCAL_PLAYER.CameraMinZoomDistance = 10; // Set min zoom distance for 3rd person view

		// Disconnect the RenderStepped connection if it exists
		if (this.renderSteppedConnection !== undefined) {
			this.renderSteppedConnection.Disconnect();
		}

		print("Spectating " + player.Name);
	}

	public switchToNextPlayer(): void {
		let players = Players.GetPlayers();
		players = players.filter((player) => player !== LOCAL_PLAYER);

		const currentIndex = players.findIndex((player) => player === this.currentPlayerToSpectate);
		const nextPlayer = players[(currentIndex + 1) % players.size()];
		this.currentPlayerToSpectate = nextPlayer;

		this.changeCameraView(nextPlayer);
	}

	public switchToPreviousPlayer(): void {
		let players = Players.GetPlayers();
		players = players.filter((player) => player !== LOCAL_PLAYER);

		const currentIndex = players.findIndex((player) => player === this.currentPlayerToSpectate);
		const prevPlayer = players[(currentIndex - 1 + players.size()) % players.size()];
		this.currentPlayerToSpectate = prevPlayer;

		this.changeCameraView(prevPlayer);
	}

	public enableFirstPerson(): void {
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.FindFirstChild("Humanoid") as Humanoid;

		// check if the character and humanoid are available
		if (!character || !humanoid) {
			print("First person mode cannot be enabled because the character or humanoid is not available");
			return;
		}

		LOCAL_PLAYER.CameraMaxZoomDistance = 0.5; // No maximum zoom limit
		LOCAL_PLAYER.CameraMinZoomDistance = 0.5; // Minimum zoom limit

		//camera.CameraType = Enum.CameraType.Custom;
		//camera.CameraSubject = humanoid;
		LOCAL_PLAYER.CameraMode = Enum.CameraMode.LockFirstPerson;
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;

		print("[DEBUG] Setting mouse behavior to LockCenter");

		print("[DEBUG] Current mouse behavior: " + UserInputService.MouseBehavior.Name);

		if (this.renderSteppedConnection !== undefined) {
			this.renderSteppedConnection.Disconnect();
		}
		this.setupInputListeners();
		print("[INFO] First person enabled");
	}
	public enableShopCamera(): void {
		// Get the character and humanoid
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.FindFirstChild("Humanoid") as Humanoid;

		// Check if the character and humanoid are available
		if (!character || !humanoid) {
			print("Dev camera cannot be enabled because the character or humanoid is not available");
			return;
		}

		camera.CameraType = Enum.CameraType.Custom;
		camera.CameraSubject = humanoid;
		//TODO: quick hack, need to find solution
		// 1 is the min, but looks weird. 20 is good.
		LOCAL_PLAYER.CameraMaxZoomDistance = 20; // No maximum zoom limit
		LOCAL_PLAYER.CameraMinZoomDistance = 20; // Minimum zoom limit

		// Set the mouse behavior back to default
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
		LOCAL_PLAYER.CameraMode = Enum.CameraMode.Classic; // Classic camera mode

		print("[DEBUG] Current mouse behavior: " + UserInputService.MouseBehavior.Name);
		print("[DEBUG] Current zoom level: " + UserInputService.MouseBehavior.Name);
		// Disconnect the RenderStepped connection if it exists
		if (this.renderSteppedConnection !== undefined) {
			this.renderSteppedConnection.Disconnect();
		}

		print("[INFO] Dev camera enabled");
	}

	public enableHeadBobbing(): void {
		print("Head Bobbing called");
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.Humanoid;
		if (!humanoid) {
			print("head bobbing failed");
			return;
		}

		let isWalking = false;
		let isRunning = false;
		let shakeSustained = false;

		camShakeWalk.Start();
		camShakeWalk.ShakeSustain(CameraShaker.Presets.Walking);

		//TODO: Fix this spaghetti code. Implement FSM
		humanoid.GetPropertyChangedSignal("WalkSpeed").Connect(() => {
			// Character is idle.
			if (humanoid.MoveDirection.Magnitude === 0) {
				if (!isWalking) {
					isWalking = true;
					if (!shakeSustained) {
						shakeSustained = true;
						camShakeWalk.Start();
						camShakeWalk.ShakeSustain(CameraShaker.Presets.Walking);
						print("Started idle bobbing");
					}

					if (isRunning) {
						isRunning = false;
						camShakeRun.StopSustained(0.2);
						camShakeRun.Stop();
						shakeSustained = false;
					}
				}
			}
			// Character is walking.
			else if (this.headBobbingEnabled && humanoid.MoveDirection.Magnitude > 0 && humanoid.WalkSpeed < 17) {
				if (!isWalking) {
					isWalking = true;
					if (!shakeSustained) {
						shakeSustained = true;
						camShakeWalk.Start();
						camShakeWalk.ShakeSustain(CameraShaker.Presets.Walking);
						print("Started walking");
					}

					if (isRunning) {
						isRunning = false;
						camShakeRun.StopSustained(0.2);
						camShakeRun.Stop();
						shakeSustained = false;
					}
				}
			}
			// Character is running.
			else if (this.headBobbingEnabled) {
				if (!isRunning) {
					isRunning = true;
					if (!shakeSustained) {
						shakeSustained = true;
						camShakeRun.Start();
						camShakeRun.ShakeSustain(CameraShaker.Presets.Sprinting);
						print("Started running");
					}

					if (isWalking) {
						isWalking = false;
						camShakeWalk.StopSustained(0.2);
						camShakeWalk.Stop();
						shakeSustained = false;
					}
				}
			}
		});

		RunService.RenderStepped.Connect(() => {
			if (this.headBobbingEnabled && humanoid.MoveDirection.Magnitude > 0) {
				// Adjust camera position for head bobbing, but don't start/stop the shake effect.
				const headBobbingIntensity = 0.1;
				const time = tick();
				const verticalBob = math.sin(time * 10) * headBobbingIntensity;
				const newCFrame = camera.CFrame.mul(new CFrame(0, verticalBob, 0));
				camera.CFrame = newCFrame;
			}
		});
	}

	private setupInputListeners(): void {
		// Handle Zoom effect
		UserInputService.InputBegan.Connect((input, gameProcessed) => {
			if (input.KeyCode === Enum.KeyCode.Z && !gameProcessed) {
				this.isZooming = true;
				this.zoom();
			}
		});

		UserInputService.InputEnded.Connect((input, gameProcessed) => {
			if (input.KeyCode === Enum.KeyCode.Z && !gameProcessed) {
				this.isZooming = false;
			}
		});
	}

	// Zoom effect
	private zoom(): void {
		const zoomedFov = 40; // Value of the FOV when zoomed in
		const transitionDuration = 0.5; // Transition Duration

		// Update the FOV every frame with a heartbeat connection and clamp function
		const heartbeatConnection = RunService.Heartbeat.Connect((deltaTime) => {
			if (this.isZooming) {
				camera.FieldOfView = math.clamp(
					camera.FieldOfView - (deltaTime * (80 - zoomedFov)) / transitionDuration, // Go to the zoomed FOV
					zoomedFov,
					80,
				);
			} else {
				camera.FieldOfView = math.clamp(
					camera.FieldOfView + (deltaTime * (80 - zoomedFov)) / transitionDuration, // Go back to the default FOV
					zoomedFov,
					80,
				);
				if (camera.FieldOfView === 80) {
					heartbeatConnection.Disconnect(); // Stop updating the FOV when it reaches the default value
				}
			}
		});
	}

	//Default Roblox Camera
	public enableDevCamera(): void {
		// Get the character and humanoid
		const character = this.characterController.getCurrentCharacter();
		const humanoid = character?.FindFirstChild("Humanoid") as Humanoid;

		// Check if the character and humanoid are available
		if (!character || !humanoid) {
			print("Dev camera cannot be enabled because the character or humanoid is not available");
			return;
		}

		camera.CameraType = Enum.CameraType.Custom;
		camera.CameraSubject = humanoid;
		LOCAL_PLAYER.CameraMaxZoomDistance = math.huge; // No maximum zoom limit
		LOCAL_PLAYER.CameraMinZoomDistance = 20; // Minimum zoom limit

		// Set the mouse behavior back to default
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
		LOCAL_PLAYER.CameraMode = Enum.CameraMode.Classic; // Classic camera mode

		print("[DEBUG] Current mouse behavior: " + UserInputService.MouseBehavior.Name);
		print("[DEBUG] Current zoom level: " + UserInputService.MouseBehavior.Name);
		// Disconnect the RenderStepped connection if it exists
		if (this.renderSteppedConnection !== undefined) {
			this.renderSteppedConnection.Disconnect();
		}

		print("[INFO] Dev camera enabled");
	}
}
