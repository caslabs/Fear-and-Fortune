-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local MusicData = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "MusicSystem", "MusicData").MusicData
local MusicSystemController
do
	MusicSystemController = setmetatable({}, {
		__tostring = function()
			return "MusicSystemController"
		end,
	})
	MusicSystemController.__index = MusicSystemController
	function MusicSystemController.new(...)
		local self = setmetatable({}, MusicSystemController)
		return self:constructor(...) or self
	end
	function MusicSystemController:constructor()
	end
	function MusicSystemController:onInit()
		for musicKey, musicId in pairs(MusicData) do
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://" .. musicId
			sound.Parent = game:GetService("SoundService")
			sound.Volume = 1
			MusicSystemController.musicInstances[musicKey] = sound
		end
		print("MusicSystemController initialized")
	end
	function MusicSystemController:onStart()
		print("MusicSystemController started")
	end
	function MusicSystemController:playMusic(id, isLoop)
		print("[INFO] playSound", id)
		local sound = MusicSystemController.musicInstances[id]
		if sound then
			sound:Play()
			sound.Looped = isLoop or false
			print("Playing Music")
		end
	end
	function MusicSystemController:stopMusic(id)
		print("[INFO] playSound", id)
		local sound = MusicSystemController.musicInstances[id]
		if sound then
			sound:Stop()
		end
	end
	function MusicSystemController:pauseMusic(id)
		print("[INFO] playSound", id)
		local sound = MusicSystemController.musicInstances[id]
		if sound then
			sound:Pause()
		end
	end
	function MusicSystemController:unpauseMusic(id)
		print("[INFO] playSound", id)
		local sound = MusicSystemController.musicInstances[id]
		if sound then
			sound:Resume()
		end
	end
	MusicSystemController.musicInstances = {}
end
-- (Flamework) MusicSystemController metadata
Reflect.defineMetadata(MusicSystemController, "identifier", "lobby/src/systems/AudioSystem/MusicSystem/controller/music-controller@MusicSystemController")
Reflect.defineMetadata(MusicSystemController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(MusicSystemController, "$:flamework@Controller", Controller, { {} })
return {
	default = MusicSystemController,
}
