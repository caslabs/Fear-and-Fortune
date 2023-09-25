-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local UserInputService = _services.UserInputService
local Workspace = _services.Workspace
local CameraShaker = TS.import(script, TS.getModule(script, "@caslabs", "roblox-modified-camera-shaker").CameraShaker)
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local LOCAL_PLAYER = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local cursor = Instance.new("ImageLabel")
local camShakeWalk = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame = camera.CFrame * shakeCFrame
	return camera.CFrame
end)
local camShakeRun = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame = camera.CFrame * shakeCFrame
	return camera.CFrame
end)
local camShakeChase = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame = camera.CFrame * shakeCFrame
	return camera.CFrame
end)
local camShakeGun = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame = camera.CFrame * shakeCFrame
	return camera.CFrame
end)
local CameraMechanic
do
	CameraMechanic = setmetatable({}, {
		__tostring = function()
			return "CameraMechanic"
		end,
	})
	CameraMechanic.__index = CameraMechanic
	function CameraMechanic.new(...)
		local self = setmetatable({}, CameraMechanic)
		return self:constructor(...) or self
	end
	function CameraMechanic:constructor(characterController)
		self.characterController = characterController
		self.desiredCameraCFrame = CFrame.new()
		self.prevMousePos = Vector2.new()
		self.headBobbingEnabled = true
		self.isZooming = false
	end
	function CameraMechanic:onInit()
		self.prevMousePos = UserInputService:GetMouseLocation()
	end
	function CameraMechanic:onStart()
		print("CameraMechanic Controller started")
		Signals.switchToPreviousPlayer:Connect(function()
			self:switchToPreviousPlayer()
		end)
		Signals.switchToNextPlayer:Connect(function()
			self:switchToNextPlayer()
		end)
		-- Camera Shaking
		local startChasingShakeEvent = Remotes.Client:Get("StartChasingShake")
		local stopChasingShakeEvent = Remotes.Client:Get("StopChasingShake")
		local playGunShakeEvent = Remotes.Client:Get("PlayGunShake")
		playGunShakeEvent:Connect(function()
			camShakeGun:Start()
			-- TODO: Make a custom present for gun shake
			camShakeGun:Shake(CameraShaker.Presets.Explosion)
			print("Shaking")
			-- Play for 0.5 seconds
			wait(0.5)
			camShakeGun:Stop()
		end)
		startChasingShakeEvent:Connect(function()
			camShakeChase:Start()
			camShakeChase:ShakeSustain(CameraShaker.Presets.Explosion)
			print("Shaking")
		end)
		stopChasingShakeEvent:Connect(function()
			camShakeChase:Stop()
			camShakeChase:StopSustained(0.3)
			print("Stopped Shaking")
		end)
	end
	function CameraMechanic:enableTitleCamera()
		-- Apparently, having this will always show the title, without it - its random.
		local character = LOCAL_PLAYER.Character or (LOCAL_PLAYER.CharacterAdded:Wait())
		local humanoid = character:WaitForChild("Humanoid")
		local head = character:WaitForChild("Head")
		camera.CameraType = Enum.CameraType.Scriptable
		-- TODO: add typing Workspace.TutorialNode
		local TitlePartCamera = Workspace:WaitForChild("TutorialNode"):WaitForChild("TitleCam")
		camera.CFrame = TitlePartCamera.CFrame
		self.desiredCameraCFrame = TitlePartCamera.CFrame
		-- Disconnect previous connection, if it exists
		if self.renderSteppedConnection ~= nil then
			self.renderSteppedConnection:Disconnect()
		end
		-- Save connection to RenderStepped event
		-- this.renderSteppedConnection = RunService.RenderStepped.Connect((dt) => this.updateCamera(dt));
		print("Enabled Title Camera")
	end
	function CameraMechanic:updateCamera(dt)
	end
	function CameraMechanic:enableSpectateCamera()
		-- TODO: Need a system to track the player's who's in the play session only (there are 2 states: in-game and spectate players)
		print("Switching to Spectate Camera")
		-- Get the list of players
		local players = Players:GetPlayers()
		-- Remove the local player from the list
		local _players = players
		local _arg0 = function(player)
			return player ~= LOCAL_PLAYER
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(_players) do
			if _arg0(_v, _k - 1, _players) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		players = _newValue
		if #players == 0 then
			self.currentPlayerToSpectate = LOCAL_PLAYER
		else
			self.currentPlayerToSpectate = players[1]
		end
		-- Change the camera view to the player
		self:disableHeadBobbing()
		self:changeCameraView(self.currentPlayerToSpectate)
	end
	function CameraMechanic:changeCameraView(player)
		-- Get the character and humanoid
		local character = player.Character
		local _result = character
		if _result ~= nil then
			_result = _result:FindFirstChild("Humanoid")
		end
		local humanoid = _result
		-- Check if the character and humanoid are available
		if not character or not humanoid then
			print("Spectate camera cannot be enabled because the character or humanoid is not available")
			return nil
		end
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = humanoid
		LOCAL_PLAYER.CameraMaxZoomDistance = 20
		LOCAL_PLAYER.CameraMinZoomDistance = 10
		-- Disconnect the RenderStepped connection if it exists
		if self.renderSteppedConnection ~= nil then
			self.renderSteppedConnection:Disconnect()
		end
		print("Spectating " .. player.Name)
	end
	function CameraMechanic:switchToNextPlayer()
		local players = Players:GetPlayers()
		local _players = players
		local _arg0 = function(player)
			return player ~= LOCAL_PLAYER
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(_players) do
			if _arg0(_v, _k - 1, _players) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		players = _newValue
		if #players == 0 then
			self.currentPlayerToSpectate = LOCAL_PLAYER
		else
			self.currentPlayerToSpectate = players[1]
		end
		local _players_1 = players
		local _arg0_1 = function(player)
			return player == self.currentPlayerToSpectate
		end
		-- ▼ ReadonlyArray.findIndex ▼
		local _result = -1
		for _i, _v in ipairs(_players_1) do
			if _arg0_1(_v, _i - 1, _players_1) == true then
				_result = _i - 1
				break
			end
		end
		-- ▲ ReadonlyArray.findIndex ▲
		local currentIndex = _result
		local nextPlayer = players[(currentIndex + 1) % #players + 1]
		self.currentPlayerToSpectate = nextPlayer
		self:changeCameraView(nextPlayer)
	end
	function CameraMechanic:switchToPreviousPlayer()
		local players = Players:GetPlayers()
		local _players = players
		local _arg0 = function(player)
			return player ~= LOCAL_PLAYER
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(_players) do
			if _arg0(_v, _k - 1, _players) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		players = _newValue
		if #players == 0 then
			self.currentPlayerToSpectate = LOCAL_PLAYER
		else
			self.currentPlayerToSpectate = players[1]
		end
		local _players_1 = players
		local _arg0_1 = function(player)
			return player == self.currentPlayerToSpectate
		end
		-- ▼ ReadonlyArray.findIndex ▼
		local _result = -1
		for _i, _v in ipairs(_players_1) do
			if _arg0_1(_v, _i - 1, _players_1) == true then
				_result = _i - 1
				break
			end
		end
		-- ▲ ReadonlyArray.findIndex ▲
		local currentIndex = _result
		local prevPlayer = players[(currentIndex - 1 + #players) % #players + 1]
		self.currentPlayerToSpectate = prevPlayer
		self:changeCameraView(prevPlayer)
	end
	function CameraMechanic:enableFirstPerson()
		local character = self.characterController:getCurrentCharacter()
		local _result = character
		if _result ~= nil then
			_result = _result:FindFirstChild("Humanoid")
		end
		local humanoid = _result
		-- check if the character and humanoid are available
		if not character or not humanoid then
			print("First person mode cannot be enabled because the character or humanoid is not available")
			return nil
		end
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = humanoid
		LOCAL_PLAYER.CameraMaxZoomDistance = 0.5
		LOCAL_PLAYER.CameraMinZoomDistance = 0.5
		-- LOCAL_PLAYER.CameraMode = Enum.CameraMode.LockFirstPerson;
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		print("[DEBUG] Setting mouse behavior to LockCenter")
		print("[DEBUG] Current mouse behavior: " .. UserInputService.MouseBehavior.Name)
		if self.renderSteppedConnection ~= nil then
			self.renderSteppedConnection:Disconnect()
		end
		self:setupInputListeners()
		for _, part in ipairs(character:GetChildren()) do
			self:antiTrans(part)
		end
		print("[INFO] First person enabled")
	end
	function CameraMechanic:antiTrans(part)
		local armParts = { "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "Left Arm", "Right Arm" }
		local _result = part
		if _result ~= nil then
			_result = _result.Name
		end
		print("Parsing " .. tostring(_result))
		local _result_1 = part
		if _result_1 ~= nil then
			_result_1 = _result_1.Name
		end
		print("Checking if " .. tostring(_result_1) .. " is in " .. tostring(armParts))
		local _condition = part
		if _condition then
			local _name = part.Name
			_condition = table.find(armParts, _name) ~= nil
		end
		if _condition then
			print("TEST")
		end
		local _condition_1 = part
		if _condition_1 then
			local _name = part.Name
			_condition_1 = table.find(armParts, _name) ~= nil
		end
		if _condition_1 then
			print("Transparency set to " .. tostring(part.Transparency))
			part.LocalTransparencyModifier = 0
			part:GetPropertyChangedSignal("Transparency"):Connect(function()
				part.LocalTransparencyModifier = 0
				print("AntiTrans applied to " .. part.Name)
			end)
		end
	end
	function CameraMechanic:enableFirstPerson2()
		local character = self.characterController:getCurrentCharacter()
		local _result = character
		if _result ~= nil then
			_result = _result:FindFirstChild("Humanoid")
		end
		local humanoid = _result
		-- check if the character and humanoid are available
		if not character or not humanoid then
			print("First person mode cannot be enabled because the character or humanoid is not available")
			return nil
		end
		LOCAL_PLAYER.CameraMaxZoomDistance = 0.5
		LOCAL_PLAYER.CameraMinZoomDistance = 0.5
		-- camera.CameraType = Enum.CameraType.Custom;
		-- camera.CameraSubject = humanoid;
		LOCAL_PLAYER.CameraMode = Enum.CameraMode.LockFirstPerson
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		print("[DEBUG] Setting mouse behavior to LockCenter")
		print("[DEBUG] Current mouse behavior: " .. UserInputService.MouseBehavior.Name)
		if self.renderSteppedConnection ~= nil then
			self.renderSteppedConnection:Disconnect()
		end
		self:setupInputListeners()
		print("[INFO] First person enabled")
	end
	function CameraMechanic:enableShopCamera()
		-- Get the character and humanoid
		local character = self.characterController:getCurrentCharacter()
		local _result = character
		if _result ~= nil then
			_result = _result:FindFirstChild("Humanoid")
		end
		local humanoid = _result
		-- Check if the character and humanoid are available
		if not character or not humanoid then
			print("Dev camera cannot be enabled because the character or humanoid is not available")
			return nil
		end
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = humanoid
		-- TODO: quick hack, need to find solution
		-- 1 is the min, but looks weird. 20 is good.
		LOCAL_PLAYER.CameraMaxZoomDistance = 20
		LOCAL_PLAYER.CameraMinZoomDistance = 20
		-- Set the mouse behavior back to default
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		LOCAL_PLAYER.CameraMode = Enum.CameraMode.Classic
		print("[DEBUG] Current mouse behavior: " .. UserInputService.MouseBehavior.Name)
		print("[DEBUG] Current zoom level: " .. UserInputService.MouseBehavior.Name)
		-- Disconnect the RenderStepped connection if it exists
		if self.renderSteppedConnection ~= nil then
			self.renderSteppedConnection:Disconnect()
		end
		print("[INFO] Dev camera enabled")
	end
	function CameraMechanic:enableCameraSway()
		-- TODO: Fine tune the camera sway
		local localPlayer = Players.LocalPlayer
		local camera = Workspace.CurrentCamera
		if not camera then
			return nil
		end
		local turn = 0
		-- Lerp function
		local function lerp(a, b, t)
			return a + (b - a) * math.clamp(t, 0, 1)
		end
		-- Lerp Turning <=> Sway
		RunService:BindToRenderStep("CameraSway", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)
			local mouseDelta = UserInputService:GetMouseDelta()
			turn = lerp(turn, math.clamp(mouseDelta.X, -4.5, 4.5), 10 * deltaTime)
			local _cFrame = camera.CFrame
			local _arg0 = CFrame.Angles(0, 0, math.rad(turn))
			camera.CFrame = _cFrame * _arg0
		end)
	end
	function CameraMechanic:enableHeadBobbing()
		print("Head Bobbing called")
		local character = self.characterController:getCurrentCharacter()
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid.Humanoid
		end
		local humanoid = _humanoid
		if not humanoid then
			print("head bobbing failed")
			return nil
		end
		local isWalking = false
		local isRunning = false
		local shakeSustained = false
		camShakeWalk:Start()
		camShakeWalk:ShakeSustain(CameraShaker.Presets.Walking)
		-- TODO: Fix this spaghetti code. Implement FSM
		humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			-- Character is idle.
			if humanoid.MoveDirection.Magnitude == 0 then
				if not isWalking then
					isWalking = true
					if not shakeSustained then
						shakeSustained = true
						camShakeWalk:Start()
						camShakeWalk:ShakeSustain(CameraShaker.Presets.Walking)
						print("Started idle bobbing")
					end
					if isRunning then
						isRunning = false
						camShakeRun:StopSustained(0.2)
						camShakeRun:Stop()
						shakeSustained = false
					end
				end
			elseif self.headBobbingEnabled and (humanoid.MoveDirection.Magnitude > 0 and humanoid.WalkSpeed < 17) then
				if not isWalking then
					isWalking = true
					if not shakeSustained then
						shakeSustained = true
						camShakeWalk:Start()
						camShakeWalk:ShakeSustain(CameraShaker.Presets.Walking)
						print("Started walking")
					end
					if isRunning then
						isRunning = false
						camShakeRun:StopSustained(0.2)
						camShakeRun:Stop()
						shakeSustained = false
					end
				end
			elseif self.headBobbingEnabled then
				if not isRunning then
					isRunning = true
					if not shakeSustained then
						shakeSustained = true
						camShakeRun:Start()
						camShakeRun:ShakeSustain(CameraShaker.Presets.Sprinting)
						print("Started running")
					end
					if isWalking then
						isWalking = false
						camShakeWalk:StopSustained(0.2)
						camShakeWalk:Stop()
						shakeSustained = false
					end
				end
			end
		end)
		self.renderSteppedConnection = RunService.RenderStepped:Connect(function()
			if self.headBobbingEnabled and humanoid.MoveDirection.Magnitude > 0 then
				-- Adjust camera position for head bobbing, but don't start/stop the shake effect.
				local headBobbingIntensity = 0.1
				local time = tick()
				local verticalBob = math.sin(time * 10) * headBobbingIntensity
				local _cFrame = camera.CFrame
				local _cFrame_1 = CFrame.new(0, verticalBob, 0)
				local newCFrame = _cFrame * _cFrame_1
				camera.CFrame = newCFrame
			end
		end)
	end
	function CameraMechanic:disableHeadBobbing()
		self.headBobbingEnabled = false
		-- Stop any sustained camera shake effects.
		camShakeWalk:StopSustained(0.2)
		camShakeWalk:Stop()
		camShakeRun:StopSustained(0.2)
		camShakeRun:Stop()
		-- Disconnect the RenderStepped connection if it exists.
		if self.renderSteppedConnection then
			self.renderSteppedConnection:Disconnect()
			self.renderSteppedConnection = nil
		end
	end
	function CameraMechanic:setupInputListeners()
		-- Handle Zoom effect
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.Z and not gameProcessed then
				self.isZooming = true
				self:zoom()
			end
		end)
		UserInputService.InputEnded:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.Z and not gameProcessed then
				self.isZooming = false
			end
		end)
	end
	function CameraMechanic:zoom()
		local zoomedFov = 40
		local transitionDuration = 0.5
		-- Update the FOV every frame with a heartbeat connection and clamp function
		local heartbeatConnection
		heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
			if self.isZooming then
				camera.FieldOfView = math.clamp(camera.FieldOfView - (deltaTime * (80 - zoomedFov)) / transitionDuration, zoomedFov, 80)
			else
				camera.FieldOfView = math.clamp(camera.FieldOfView + (deltaTime * (80 - zoomedFov)) / transitionDuration, zoomedFov, 80)
				if camera.FieldOfView == 80 then
					heartbeatConnection:Disconnect()
				end
			end
		end)
	end
	function CameraMechanic:enableDevCamera()
		-- Get the character and humanoid
		local character = self.characterController:getCurrentCharacter()
		local _result = character
		if _result ~= nil then
			_result = _result:FindFirstChild("Humanoid")
		end
		local humanoid = _result
		-- Check if the character and humanoid are available
		if not character or not humanoid then
			print("Dev camera cannot be enabled because the character or humanoid is not available")
			return nil
		end
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = humanoid
		LOCAL_PLAYER.CameraMaxZoomDistance = math.huge
		LOCAL_PLAYER.CameraMinZoomDistance = 20
		-- Set the mouse behavior back to default
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		LOCAL_PLAYER.CameraMode = Enum.CameraMode.Classic
		print("[DEBUG] Current mouse behavior: " .. UserInputService.MouseBehavior.Name)
		print("[DEBUG] Current zoom level: " .. UserInputService.MouseBehavior.Name)
		-- Disconnect the RenderStepped connection if it exists
		if self.renderSteppedConnection ~= nil then
			self.renderSteppedConnection:Disconnect()
		end
		print("[INFO] Dev camera enabled")
	end
end
-- (Flamework) CameraMechanic metadata
Reflect.defineMetadata(CameraMechanic, "identifier", "game/src/mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller@CameraMechanic")
Reflect.defineMetadata(CameraMechanic, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(CameraMechanic, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(CameraMechanic, "$:flamework@Controller", Controller, { {
	loadOrder = 3,
} })
return {
	default = CameraMechanic,
}
