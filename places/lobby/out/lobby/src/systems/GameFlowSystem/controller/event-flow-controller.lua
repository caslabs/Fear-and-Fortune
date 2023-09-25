-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local StarterGui = _services.StarterGui
local ContentProvider = _services.ContentProvider
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local SoundSystemController = TS.import(script, script.Parent.Parent, "SoundSystem", "sound-system-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local MusicSystemController = TS.import(script, script.Parent.Parent, "MusicSystem", "music-controller").default
local MusicKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "MusicSystem", "MusicData").MusicKeys
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local _services_1 = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Workspace = _services_1.Workspace
local Lighting = _services_1.Lighting
local ReplicatedStorage = _services_1.ReplicatedStorage
local StarterPack = _services_1.StarterPack
local QueueState
do
	local _inverse = {}
	QueueState = setmetatable({}, {
		__index = _inverse,
	})
	QueueState.Idle = 0
	_inverse[0] = "Idle"
	QueueState.Searching = 1
	_inverse[1] = "Searching"
	QueueState.ServerFound = 2
	_inverse[2] = "ServerFound"
	QueueState.EmbarkFailed = 3
	_inverse[3] = "EmbarkFailed"
end
local EventFlowController
do
	EventFlowController = setmetatable({}, {
		__tostring = function()
			return "EventFlowController"
		end,
	})
	EventFlowController.__index = EventFlowController
	function EventFlowController.new(...)
		local self = setmetatable({}, EventFlowController)
		return self:constructor(...) or self
	end
	function EventFlowController:constructor(hudController, cameraMechanic)
		self.hudController = hudController
		self.cameraMechanic = cameraMechanic
		self.tasks = { function(done)
			return self:showLobbyScreen(done)
		end, function(done)
			return self:transitionToGame(done)
		end, function(done)
			return self:teleportToGame(done)
		end }
		self.queueState = QueueState.Idle
	end
	function EventFlowController:onStart()
		print("Event System Controller started")
		self:runNextTask()
		local ExecuteMatchEvent = Remotes.Client:Get("ExecuteMatch")
		ExecuteMatchEvent:Connect(function()
			Signals.startGameSignal:Fire()
		end)
	end
	function EventFlowController:runNextTask()
		if #self.tasks > 0 then
			local nextTask = table.remove(self.tasks, 1)
			if nextTask then
				nextTask(function()
					return self:runNextTask()
				end)
			end
		else
			print("All tasks completed")
		end
	end
	function EventFlowController:showTitleScreen(done)
		local disablePlayerControls = Remotes.Client:Get("disablePlayerControls")
		disablePlayerControls:SendToServer(Players.LocalPlayer)
		Signals.switchToTitleHUD:Fire()
		print("Fired switchToTitleHUD Signal")
		-- Delete the pre loading screen
		if PlayerGui:WaitForChild("LOADING_SCREEN") then
			print("Found Loading Screen")
			wait(1)
			PlayerGui:WaitForChild("LOADING_SCREEN"):Destroy()
		else
			print("Deleted")
		end
		PlayerGui:WaitForChild("LOADING_SCREEN"):Destroy()
		print("[EVENT] Awaiting for the player to singal title...")
		-- Wait for the signal to be fired
		Signals.finishedTitleScreen:Wait()
		SoundSystemController:playSound(SoundKeys.SFX_THUNDER)
		SoundSystemController:stopSound(SoundKeys.SFX_SNOW_AMBIENCE)
		-- Perform action after signal has been fired
		done()
	end
	EventFlowController.showAssetLoadScreen = TS.async(function(self, done)
		print("[EVENT] Beginning asset loading...")
		TS.try(function()
			-- Load assets
			TS.await(self:loadAssets())
			print("[EVENT] Asset loading completed.")
			done()
		end, function(error)
			print("[ERROR] Asset loading failed: " .. tostring(error))
			-- You might want to handle this error more gracefully. Perhaps retry, or inform the player.
		end)
	end)
	EventFlowController.showLobbyScreen = TS.async(function(self, done)
		-- DEV: Begin the await this.loadAssets();
		-- await this.loadAssets();
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
		-- Delete the pre loading screen
		if PlayerGui:WaitForChild("LOADING_SCREEN") then
			print("Found Loading Screen")
			wait(1)
		else
			print("Deleted")
		end
		-- PlayerGui.WaitForChild("LOADING_SCREEN")!.Destroy();
		print("[EVENT] Awaiting for the player to singal title...")
		-- Show the Lobby Screen
		Signals.switchToLobbyHUD:Fire()
		MusicSystemController:playMusic(MusicKeys.LOBBY_MUSIC, true)
		local loadProfileEvent = Remotes.Client:Get("LoadProfile")
		loadProfileEvent:SendToServer()
		done()
	end)
	EventFlowController.transitionToGame = TS.async(function(self, done)
		print("Awaiting queueStateChangedSignal...")
		-- Here we use Connect to attach an event listener
		local connection = Signals.queueStateChangedSignal:Connect(function(newQueueState)
			self.queueState = newQueueState
		end)
		-- Wait for the startGameSignal to be fired
		-- TODO: This is the flow that starts the game
		Signals.startGameSignal:Wait()
		print("Start game signal received")
		-- Set the queueState to ServerFound and disconnect the signal
		self:setQueueState(QueueState.ServerFound)
		-- Initialize countdownTime to 5
		local countdownTime = 5
		-- Emit startCountdownSignal with countdownTime
		Signals.startCountdownSignal:Fire(countdownTime)
		-- Decrement countdownTime every second
		while countdownTime > 0 do
			wait(1)
			countdownTime -= 1
			if countdownTime > 0 then
				-- If there's still time left, emit the signal with the updated countdownTime
				Signals.startCountdownSignal:Fire(countdownTime)
				SoundSystemController:playSound(SoundKeys.UI_COUNTDOWN, 2)
			else
				-- If countdownTime reaches 0, emit endCountdownSignal
				Signals.endCountdownSignal:Fire()
				SoundSystemController:playSound(SoundKeys.UI_BACKPACK, 2)
			end
		end
		connection:Disconnect()
		print("Transitioning to game")
		done()
	end)
	EventFlowController.teleportToGame = TS.async(function(self, done)
		local TeleportMatchEvent = Remotes.Client:Get("TeleportMatch")
		TeleportMatchEvent:SendToServer()
		print("Teleporting to game")
		done()
	end)
	function EventFlowController:setQueueState(newQueueState)
		self.queueState = newQueueState
		Signals.queueStateChangedSignal:Fire(newQueueState)
	end
	EventFlowController.loadAssets = TS.async(function(self)
		local allObjects = { Workspace:GetDescendants(), Lighting:GetDescendants(), ReplicatedStorage:GetDescendants(), StarterGui:GetDescendants(), Players:GetDescendants(), StarterPack:GetDescendants() }
		-- Check if the character exists before fetching its descendants
		local localPlayerCharacter = Players.LocalPlayer.Character
		if localPlayerCharacter then
			local _arg0 = localPlayerCharacter:GetDescendants()
			table.insert(allObjects, _arg0)
		end
		local allLoadables = {}
		for _, objects in ipairs(allObjects) do
			for _1, loadable in ipairs(self:filterLoadables(objects)) do
				table.insert(allLoadables, loadable)
			end
		end
		local loadedCount = 0
		local totalAssets = #allLoadables
		local promises = {}
		for _, loadable in ipairs(allLoadables) do
			local promise = TS.Promise.new(function(resolve, reject)
				TS.try(function()
					ContentProvider:PreloadAsync({ loadable })
					loadedCount += 1
					-- print(`[LOADING] Loading asset: ${loadable.Name}`);
					print("[LOADING] loading progress: " .. (tostring(loadedCount) .. (" / " .. tostring(totalAssets))))
					resolve()
				end, function(error)
					reject("Failed to load asset: " .. (tostring(loadable) .. (". Error: " .. tostring(error))))
				end)
			end)
			table.insert(promises, promise)
		end
		TS.await(TS.Promise.all(promises))
	end)
	function EventFlowController:filterLoadables(objects)
		local loadables = {}
		for _, obj in ipairs(objects) do
			if obj:IsA("Model") or (obj:IsA("Texture") or obj:IsA("Sound")) then
				table.insert(loadables, obj)
			end
		end
		return loadables
	end
end
-- (Flamework) EventFlowController metadata
Reflect.defineMetadata(EventFlowController, "identifier", "lobby/src/systems/GameFlowSystem/controller/event-flow-controller@EventFlowController")
Reflect.defineMetadata(EventFlowController, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/UIMechanic/controller/hud-controller@HUDController", "lobby/src/mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller@CameraMechanic" })
Reflect.defineMetadata(EventFlowController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(EventFlowController, "$:flamework@Controller", Controller, { {
	loadOrder = 99999,
} })
return {
	QueueState = QueueState,
	EventFlowController = EventFlowController,
}
