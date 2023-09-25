-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- segmentHandlers.ts
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Lighting = _services.Lighting
local Workspace = _services.Workspace
local Players = _services.Players
local CameraShaker = TS.import(script, TS.getModule(script, "@caslabs", "roblox-modified-camera-shaker").CameraShaker)
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local DialogueBox = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "DialogueSystem", "dialogue-box")
local camera = Workspace.CurrentCamera
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame = camera.CFrame * shakeCFrame
	return camera.CFrame
end)
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local Notification = TS.import(script, game:GetService("ReplicatedStorage"), "MechanicsManager", "NotificationsManager", "notification")
local landmarks = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "WorldBuildingSystem", "landmarks").landmarks
-- Auxilary
local transitionAtmosphereDensity = TS.async(function(targetDensity)
	local atmosphere = Lighting:WaitForChild("Atmosphere")
	local transitionDuration = 3
	-- Smooth transition between the current density and the target density
	local step = (targetDensity - atmosphere.Density) / (transitionDuration * 60)
	while math.abs(atmosphere.Density - targetDensity) > math.abs(step) do
		atmosphere.Density += step
		TS.await(TS.Promise.delay(1 / 60))
	end
	atmosphere.Density = targetDensity
end)
-- Events
local handleLevelSegment1Enter = TS.async(function()
	print("[INFO] Player is in LevelSegment1")
	camShake:Start()
	-- TODO: temporarily hack - cannot access SoundSystem, must use remote events.
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. tostring(9114224721)
	sound.Parent = game:GetService("SoundService")
	sound.Volume = 10
	sound:Play()
	-- TODO: Should use the NotificationManager
	-- ?!?! Dialogue
	local handle = Roact.mount(Roact.createFragment({
		DialogueBoxScreen = Roact.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
		}, {
			Roact.createElement(DialogueBox, {
				title = "",
				description = "?!?!",
				image = "",
			}),
		}),
	}), PlayerGui)
	camShake:Shake(CameraShaker.Presets.Explosion)
	TS.await(TS.Promise.delay(5))
	camShake:Stop()
	Roact.unmount(handle)
end)
local handleFogEnter = TS.async(function()
	print("Player is in Fog")
	TS.await(transitionAtmosphereDensity(0.96))
end)
local handleFogExit = TS.async(function()
	print("Player is out of Fog")
	TS.await(transitionAtmosphereDensity(0.694))
end)
local handleCutscene = TS.async(function()
	-- Step 1: Fade in
	-- await fadeSceneIn();
	-- Step 2: Play dialogue
	-- await playDialogue("Welcome to our world!");
	-- Step 3: Move camera
	-- await moveCameraToPosition(new Vector3(10, 10, 10));
	-- Step 4: Fade out
	-- await fadeSceneOut();
	print("Hello World!")
end)
local handleAIChase = TS.async(function()
	-- 305024085
	-- TODO: temporarily hack - cannot access SoundSystem, must use remote events.
	print("AI is chasing player")
end)
local handleAISpawn = TS.async(function(segmentModel)
	-- Define the type of AI you want to spawn
	local aiType = "Zombie"
	local RequestSpawnAI = Remotes.Client:Get("RequestSpawnAI")
	-- Get spawn location from segmentModel. Replace 'Coords' with the actual property name.
	local spawnLocation = segmentModel.model:GetPrimaryPartCFrame().Position
	-- Request the server to spawn an AI at the spawn location
	RequestSpawnAI:SendToServer(aiType, spawnLocation)
	print("AI is spawned")
end)
local handleCutsceneEnter = TS.async(function()
	print("Player is in Cutscene")
	Signals.switchToCutsceneHUD:Fire()
end)
local handleCutsceneExit = TS.async(function()
	print("Player is out of Cutscene")
	Signals.switchToPlayHUD:Fire()
end)
local handleEeryMusicEnter = TS.async(function()
	-- TODO: temporarily hack - cannot access SoundSystem, must use remote events.
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. tostring(13833382738)
	sound.Parent = game:GetService("SoundService")
	sound.Volume = 2
	sound:Play()
end)
local handleTutorialNode = TS.async(function()
	print("Player sees the beauty of the mountains")
end)
local handleBaseCampNode = TS.async(function()
	local handle = Roact.mount(Roact.createFragment({
		LandMarkNotification = Roact.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			DisplayOrder = -999,
		}, {
			Roact.createElement(Notification, {
				title = landmarks.BASE_CAMP,
			}),
		}),
	}), PlayerGui)
	wait(8)
	Roact.unmount(handle)
end)
-- segmentHandlers.ts
local handlers = { handleCutscene, handleLevelSegment1Enter, handleFogEnter, handleFogExit }
return {
	handleLevelSegment1Enter = handleLevelSegment1Enter,
	handleFogEnter = handleFogEnter,
	handleFogExit = handleFogExit,
	handleCutscene = handleCutscene,
	handleAIChase = handleAIChase,
	handleAISpawn = handleAISpawn,
	handleCutsceneEnter = handleCutsceneEnter,
	handleCutsceneExit = handleCutsceneExit,
	handleEeryMusicEnter = handleEeryMusicEnter,
	handleTutorialNode = handleTutorialNode,
	handleBaseCampNode = handleBaseCampNode,
	handlers = handlers,
}
