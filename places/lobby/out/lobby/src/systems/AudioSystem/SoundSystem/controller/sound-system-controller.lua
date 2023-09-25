-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local SoundData = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundData
local SoundSystemController
do
	SoundSystemController = setmetatable({}, {
		__tostring = function()
			return "SoundSystemController"
		end,
	})
	SoundSystemController.__index = SoundSystemController
	function SoundSystemController.new(...)
		local self = setmetatable({}, SoundSystemController)
		return self:constructor(...) or self
	end
	function SoundSystemController:constructor()
	end
	function SoundSystemController:onInit()
		for soundKey, soundId in pairs(SoundData) do
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://" .. soundId
			sound.Parent = game:GetService("SoundService")
			sound.Volume = 1
			SoundSystemController.soundInstances[soundKey] = sound
		end
		print("SoundSystemController initialized")
	end
	function SoundSystemController:onStart()
		print("SoundSystemController started")
	end
	function SoundSystemController:playSound(id, volume)
		print("[INFO] playSound", id)
		local sound = SoundSystemController.soundInstances[id]
		if sound then
			sound:Play()
			if volume ~= nil then
				sound.Volume = volume
			end
		end
	end
	function SoundSystemController:playAmbienceSound(id, volume)
		print("[INFO] playAmbienceSound", id)
		local sound = SoundSystemController.soundInstances[id]
		if sound then
			sound.Looped = true
			sound:Play()
		end
	end
	function SoundSystemController:stopSound(id)
		print("[INFO] stopSound", id)
		local sound = SoundSystemController.soundInstances[id]
		if sound then
			sound:Stop()
		end
	end
	function SoundSystemController:playSoundVolume(id, volume)
		print("[INFO] playSound", id)
		local sound = SoundSystemController.soundInstances[id]
		if sound then
			sound.Volume = volume
			sound:Play()
		end
	end
	SoundSystemController.soundInstances = {}
end
-- (Flamework) SoundSystemController metadata
Reflect.defineMetadata(SoundSystemController, "identifier", "lobby/src/systems/AudioSystem/SoundSystem/controller/sound-system-controller@SoundSystemController")
Reflect.defineMetadata(SoundSystemController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(SoundSystemController, "$:flamework@Controller", Controller, { {} })
return {
	default = SoundSystemController,
}
