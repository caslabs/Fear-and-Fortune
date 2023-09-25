// segmentHandlers.ts
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { UserInputService, ReplicatedStorage, Lighting, Workspace, Players } from "@rbxts/services";
import CameraShaker from "@caslabs/roblox-modified-camera-shaker";

import Roact from "@rbxts/roact";
import DialogueBox from "systems/NarrartiveSystem/DialogueSystem/manager/dialogue-box";
const camera = Workspace.CurrentCamera!;
const camShake = new CameraShaker(
	Enum.RenderPriority.Camera.Value,
	(shakeCFrame) => (camera.CFrame = camera.CFrame.mul(shakeCFrame)),
);
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import Notification from "mechanics/PlayerMechanics/UIMechanic/manager/notification";
import { landmarks } from "systems/NarrartiveSystem/WorldBuildingSystem/WorldData/landmarks";

type Segment = {
	model: Model;
	regionPart: BasePart;
	players: Player[];
};
// Auxilary
async function transitionAtmosphereDensity(targetDensity: number): Promise<void> {
	const atmosphere = Lighting.WaitForChild("Atmosphere") as Atmosphere;

	const transitionDuration = 3; // It takes 3 seconds to transition from one density to another

	// Smooth transition between the current density and the target density
	const step = (targetDensity - atmosphere.Density) / (transitionDuration * 60); // 60 for 60 frames per second in Roblox
	while (math.abs(atmosphere.Density - targetDensity) > math.abs(step)) {
		atmosphere.Density += step;
		await Promise.delay(1 / 60); // Wait for one frame
	}
	atmosphere.Density = targetDensity; // Set the density to the target density
}

// Events
export const handleLevelSegment1Enter = async (): Promise<void> => {
	print("[INFO] Player is in LevelSegment1");
	camShake.Start();

	//TODO: temporarily hack - cannot access SoundSystem, must use remote events.
	const sound = new Instance("Sound");
	sound.SoundId = "rbxassetid://" + 9114224721;
	sound.Parent = game.GetService("SoundService");
	sound.Volume = 10;
	sound.Play();

	//TODO: Should use the NotificationManager
	//?!?! Dialogue
	const handle: Roact.Tree = Roact.mount(
		<screengui Key={"DialogueBoxScreen"} IgnoreGuiInset={true} ResetOnSpawn={false}>
			<DialogueBox title={""} description={"?!?!"} image={""} />
		</screengui>,
		PlayerGui,
	);

	camShake.Shake(CameraShaker.Presets.Explosion);
	await Promise.delay(5);
	camShake.Stop();
	Roact.unmount(handle);
};

export const handleFogEnter = async (): Promise<void> => {
	print("Player is in Fog");
	await transitionAtmosphereDensity(0.96);
};

export const handleFogExit = async (): Promise<void> => {
	print("Player is out of Fog");
	await transitionAtmosphereDensity(0.694);
};

export const handleCutscene = async (): Promise<void> => {
	// Step 1: Fade in
	//await fadeSceneIn();
	// Step 2: Play dialogue
	//await playDialogue("Welcome to our world!");
	// Step 3: Move camera
	//await moveCameraToPosition(new Vector3(10, 10, 10));
	// Step 4: Fade out
	//await fadeSceneOut();
	print("Hello World!");
};

export const handleAIChase = async (): Promise<void> => {
	// 305024085
	//TODO: temporarily hack - cannot access SoundSystem, must use remote events.
	print("AI is chasing player");
};

export const handleAISpawn = async (segmentModel: Segment): Promise<void> => {
	// Define the type of AI you want to spawn
	const aiType = "Zombie";

	const RequestSpawnAI = Remotes.Client.Get("RequestSpawnAI");

	// Get spawn location from segmentModel. Replace 'Coords' with the actual property name.
	const spawnLocation = segmentModel.model.GetPrimaryPartCFrame().Position;

	// Request the server to spawn an AI at the spawn location
	RequestSpawnAI.SendToServer(aiType, spawnLocation);
	print("AI is spawned");
};

export const handleCutsceneEnter = async (): Promise<void> => {
	print("Player is in Cutscene");
	Signals.switchToCutsceneHUD.Fire();
};

export const handleCutsceneExit = async (): Promise<void> => {
	print("Player is out of Cutscene");
	Signals.switchToPlayHUD.Fire();
};

export const handleEeryMusicEnter = async (): Promise<void> => {
	//TODO: temporarily hack - cannot access SoundSystem, must use remote events.
	const sound = new Instance("Sound");
	sound.SoundId = "rbxassetid://" + 13833382738;
	sound.Parent = game.GetService("SoundService");
	sound.Volume = 2;
	sound.Play();
};

export const handleTutorialNode = async (): Promise<void> => {
	print("Player sees the beauty of the mountains");
};

export const handleBaseCampNode = async (): Promise<void> => {
	const handle: Roact.Tree = Roact.mount(
		<screengui Key={"LandMarkNotification"} IgnoreGuiInset={true} ResetOnSpawn={false} DisplayOrder={-999}>
			<Notification title={landmarks.BASE_CAMP} />
		</screengui>,
		PlayerGui,
	);

	wait(8);
	Roact.unmount(handle);
};

// segmentHandlers.ts

export const handlers: Array<() => Promise<void>> = [
	handleCutscene,
	handleLevelSegment1Enter,
	handleFogEnter,
	handleFogExit,
	// ... any other handlers you have
];
