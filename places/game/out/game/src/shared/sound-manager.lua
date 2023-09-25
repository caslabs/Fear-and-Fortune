-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local UI = {
	buttonClick = "songID",
	notification = "294316715",
	close = "6895079853",
}
local Lobby = {
	ambienbce = "songID",
}
local Game = {
	tuturoo = "2806491346",
	background_music1 = "9048378383",
	open_chest = "6176999962",
	item_pickup = "6176999962",
	blood_shrine = "221057812",
	chance_shrine = "6883650972",
	sus_shrine = "7361207035",
	A1Objective2 = "13368966497",
	QUEST_COMPLETE = "5621616510",
	JUMPSCARE = "7076365030",
	intro = "13615772080",
	gate_open = "7509847163",
}
local Dialogue = {
	D2 = "13659163893",
	S1 = "13660016606",
}
local SoundQueus = {
	name = "footstep",
	falloff = 25,
	priority = "low",
	switch_name = "foot_surface",
	sources = { {
		switch = "sand",
		sources = { "fs_sand1.wav", "fs_sand2.wav", "fs_sand3.wav" },
	}, {
		switch = "grass",
		sources = {},
	} },
}
--[[
	SoundManager can be used to handle immediate and specific sound effects, such as UI sounds or character interactions.
]]
local SoundManager
do
	SoundManager = setmetatable({}, {
		__tostring = function()
			return "SoundManager"
		end,
	})
	SoundManager.__index = SoundManager
	function SoundManager.new(...)
		local self = setmetatable({}, SoundManager)
		return self:constructor(...) or self
	end
	function SoundManager:constructor()
		self.sounds = {}
		self.soundQueue = {}
	end
	function SoundManager:getInstance()
		if not SoundManager.instance then
			SoundManager.instance = SoundManager.new()
		end
		return SoundManager.instance
	end
	SoundManager.LoadSound = TS.async(function(self, _param)
		local fileName = _param.fileName
		local soundName = _param.soundName
		local volume = _param.volume
		local looped = _param.looped
		-- Load the sound effect
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://" .. fileName
		sound.Parent = game:GetService("SoundService")
		sound.Volume = 1
		if not sound then
			warn("Failed to load sound effect: " .. fileName)
			-- throw new Error(`Failed to load sound effect: ${fileName}`);
		end
		-- TODO: Does this work?
		-- Set the sound effect properties
		if volume ~= nil or type(volume) == "number" then
			sound.Volume = volume
		end
		if looped ~= nil or type(looped) == "boolean" then
			sound.Looped = looped
		end
		-- Add the sound effect to the map
		self.sounds[soundName] = sound
	end)
	SoundManager.PlaySound = TS.async(function(self, soundName)
		-- Check if the sound exists
		if not (self.sounds[soundName] ~= nil) then
			warn("Sound effect not found: " .. soundName)
			-- throw new Error(`Sound effect not found: ${soundName}`);
		end
		-- Play the sound effect
		local sound = self.sounds[soundName]
		if sound then
			print("Playing sound effect: " .. soundName)
			sound:Play()
		end
	end)
	function SoundManager:getSound(soundName)
		return self.sounds[soundName]
	end
	SoundManager.playSpatialSound = TS.async(function(self, soundName, parent)
		-- Check if the sound exists
		local sound = self.sounds[soundName]
		if sound then
			print("Playing spatial sound effect: " .. soundName)
			-- Clone sound for playing, to prevent interrupting a sound already playing
			local soundToPlay = sound:Clone()
			soundToPlay.Parent = parent
			soundToPlay.RollOffMode = Enum.RollOffMode.InverseTapered
			soundToPlay.MaxDistance = 50
			soundToPlay:Play()
		else
			warn("Sound effect not found: " .. soundName)
		end
	end)
	SoundManager.PlayNextSoundInQueue = TS.async(function(self)
		-- Check if there are any sounds in the queue
		if #self.soundQueue == 0 then
			return nil
		end
		-- Play the next sound in the queue
		local nextSound = table.remove(self.soundQueue, 1)
		if nextSound then
			nextSound.Volume = 1
			TS.await(nextSound:Play())
		end
		-- If there are more sounds in the queue, play the next one after a delay
		if #self.soundQueue > 0 then
			wait(nextSound.TimeLength + 1)
			self:PlayNextSoundInQueue()
		end
	end)
	function SoundManager:EnqueueSound(soundName)
		-- Check if the sound exists
		if not (self.sounds[soundName] ~= nil) then
			print("Sound effect not found: " .. soundName)
			-- throw new Error(`Sound effect not found: ${soundName}`);
		end
		-- Add the sound to the queue
		local _soundQueue = self.soundQueue
		local _arg0 = self.sounds[soundName]
		table.insert(_soundQueue, _arg0)
	end
end
return {
	UI = UI,
	Lobby = Lobby,
	Game = Game,
	Dialogue = Dialogue,
	SoundQueus = SoundQueus,
	SoundManager = SoundManager,
}
