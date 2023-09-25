-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local EventManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "EventManager").EventManager
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Workspace = _services.Workspace
local TweenService = _services.TweenService
local SoundManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "sound-manager").SoundManager
-- TODO: pre-render cutscene events
-- In a story-driven game, this
-- flow might also include variousin - game movies that serve to advance the player’s understanding of the storyas it unfolds.
local _cFrame = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(-1, 0, 0))
local _arg0 = CFrame.Angles(math.rad(-58.472), math.rad(1.853), math.rad(-32.761))
local startRotation = _cFrame * _arg0
local _cFrame_1 = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, 1, 0))
local _arg0_1 = CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
local endRotation = _cFrame_1 * _arg0_1
local _cFrame_2 = CFrame.new(Vector3.new(0, 0, 0))
local _arg0_2 = CFrame.Angles(0, 0, 0)
local startPosition = _cFrame_2 * _arg0_2
local _cFrame_3 = CFrame.new(Vector3.new(0, 3, 0))
local _arg0_3 = CFrame.Angles(0, 0, 0)
local endPosition = _cFrame_3 * _arg0_3
-- Define your cutscenes
local cutscenes = {
	A1Objective2 = {
		positions = { CFrame.new(Vector3.new(0, 5, -10)), CFrame.new(Vector3.new(10, 5, 0)), CFrame.new(Vector3.new(0, 5, 10)) },
		duration = 3,
	},
}
local CutsceneManager
do
	CutsceneManager = setmetatable({}, {
		__tostring = function()
			return "CutsceneManager"
		end,
	})
	CutsceneManager.__index = CutsceneManager
	function CutsceneManager.new(...)
		local self = setmetatable({}, CutsceneManager)
		return self:constructor(...) or self
	end
	function CutsceneManager:constructor()
		-- Initialize any necessary resources
		self.eventManager = EventManager:getInstance()
		self:subscribe(self.eventManager)
		self.soundManager = SoundManager:getInstance()
	end
	function CutsceneManager:getInstance()
		if not CutsceneManager.instance then
			CutsceneManager.instance = CutsceneManager.new()
		end
		return CutsceneManager.instance
	end
	function CutsceneManager:subscribe(eventManager)
		eventManager:registerListener(GameEventType.Cutscene, function(eventData)
			return self:handleCutsceneEvent(eventData)
		end)
	end
	function CutsceneManager:handleCutsceneEvent(eventData)
		-- Handle the cutscene event data
		local cutsceneId = eventData.cutsceneId
		if self:loadCutscene(cutsceneId) then
			self:playCutscene()
		end
	end
	function CutsceneManager:loadCutscene(cutsceneId)
		local cutscene = cutscenes[cutsceneId]
		if not cutscene then
			warn('Cutscene with ID "' .. (cutsceneId .. '" not found.'))
			self.currentCutscene = nil
			return false
		end
		self.currentCutscene = cutscene
		-- TODO: Make ID dynamic
		-- this.soundManager.LoadSound({ fileName: Game[cutsceneId], soundName: "DIALOGUE", volume: 2 });
		-- this.soundManager.PlaySound("DIALOGUE");
		return true
	end
	function CutsceneManager:playCutscene()
		-- Signals.switchToCutsceneHUD.Fire();
		print("Played cutscene")
		if not self.currentCutscene then
			warn("No cutscene has been loaded.")
			return nil
		end
		local camera = Workspace.CurrentCamera
		if not camera then
			warn("No camera found in the workspace.")
			return nil
		end
		local index = 0
		local playNextPosition
		playNextPosition = function()
			if index >= #self.currentCutscene.positions then
				self:stopCutscene()
				return nil
			end
			local newPosition = self.currentCutscene.positions[index + 1]
			self.cutsceneTween = TweenService:Create(camera, TweenInfo.new(self.currentCutscene.duration), {
				CFrame = newPosition,
			})
			self.cutsceneTween.Completed:Connect(playNextPosition)
			self.cutsceneTween:Play()
			index += 1
		end
		playNextPosition()
		-- this.stopCutscene();
	end
	function CutsceneManager:playStrongCutscene()
		print("Played cutscene")
		if not self.currentCutscene then
			warn("No cutscene has been loaded.")
			return nil
		end
		local camera = Workspace.CurrentCamera
		if not camera then
			warn("No camera found in the workspace.")
			return nil
		end
		local startPosition = self.currentCutscene.positions[1]
		local endPosition = self.currentCutscene.positions[#self.currentCutscene.positions - 1 + 1]
		camera.CFrame = startPosition
		do
			local i = 1
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #self.currentCutscene.positions - 1) then
					break
				end
				camera.CFrame = self.currentCutscene.positions[i + 1]
			end
		end
		self.cutsceneTween = TweenService:Create(camera, TweenInfo.new(self.currentCutscene.duration), {
			CFrame = endPosition,
		})
		self.cutsceneTween:Play()
		self.cutsceneTween.Completed:Wait()
	end
	function CutsceneManager:stopCutscene()
	end
end
return {
	CutsceneManager = CutsceneManager,
}
