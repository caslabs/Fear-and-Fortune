-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _sound_manager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "sound-manager")
local Game = _sound_manager.Game
local SoundManager = _sound_manager.SoundManager
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local EventJumpScareManager
do
	EventJumpScareManager = setmetatable({}, {
		__tostring = function()
			return "EventJumpScareManager"
		end,
	})
	EventJumpScareManager.__index = EventJumpScareManager
	function EventJumpScareManager.new(...)
		local self = setmetatable({}, EventJumpScareManager)
		return self:constructor(...) or self
	end
	function EventJumpScareManager:constructor(eventManager)
		self.soundManager = SoundManager:getInstance()
		eventManager:registerListener(GameEventType.JumpScare, function(eventData)
			return self:handleJumpScare(eventData)
		end)
	end
	function EventJumpScareManager:handleJumpScare(eventData)
		-- ... play the random dialogue
		-- Audio cues: Use sudden, loud, and unexpected sounds to startle the player. You can create tension by using eerie or unsettling background music and then suddenly playing a loud sound effect when the jumpscare occurs.
		-- Visual cues: Use sudden changes in the game environment, such as flashing images or sudden appearances of a scary character or object.You can also use lighting effects and shadows to create an unsettling atmosphere.
		-- Misdirection: Trick the player by leading them to expect a jumpscare in one area, only to surprise them with a jumpscare from another direction or at an unexpected time.
		-- TODO: Add jumpscare ID to the event data
		-- Vary the intensity: Not every jumpscare needs to be at the same intensity level. Vary the intensity of your jumpscares, using both subtle and intense scares to keep the player engaged and on edge.
		-- Player-triggered jumpscares: Tie jumpscares to player actions, such as picking up an item, opening a door, or entering a specific area. This can help create a sense of agency and make the jumpscare feel more personal and impactful.
		-- TODO: Peraphs this would be more suited
		--[[
			const jumpscareID = eventData.jumpscareID as string;
			// Load the jump scare sound as a stinger
			this.musicManager.loadTrack(MusicState.JUMPSCARE, Game.JUMPSCARE);
			// Play the jump scare stinger
			this.musicManager.playStinger(MusicState.JUMPSCARE);
		]]
		local jumpscareID = eventData.jumpscareID
		self.soundManager:LoadSound({
			fileName = Game.JUMPSCARE,
			soundName = "JUMPSCARE",
			volume = 2,
		})
		self.soundManager:PlaySound("JUMPSCARE")
	end
end
return {
	EventJumpScareManager = EventJumpScareManager,
}
