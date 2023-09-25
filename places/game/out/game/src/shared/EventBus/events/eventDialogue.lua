-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local DialogueManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "DialogueManager", "DialogueManager").DialogueManager
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local dialogues = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "DialogueManager", "logs").dialogues
local RandomDialogueManager
do
	RandomDialogueManager = setmetatable({}, {
		__tostring = function()
			return "RandomDialogueManager"
		end,
	})
	RandomDialogueManager.__index = RandomDialogueManager
	function RandomDialogueManager.new(...)
		local self = setmetatable({}, RandomDialogueManager)
		return self:constructor(...) or self
	end
	function RandomDialogueManager:constructor(eventManager)
		self.dialogueManager = DialogueManager.new(dialogues)
		eventManager:registerListener(GameEventType.RandomDialogue, function(eventData)
			return self:handleRandomDialogue(eventData)
		end)
	end
	function RandomDialogueManager:handleRandomDialogue(eventData)
		-- ... play the random dialogue
		self.dialogueManager:startDialogue(eventData.dialogueId)
	end
end
return {
	RandomDialogueManager = RandomDialogueManager,
}
