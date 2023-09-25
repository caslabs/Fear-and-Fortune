-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local CutsceneManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "CutsceneManager").CutsceneManager
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local EventCutsceneManager
do
	EventCutsceneManager = setmetatable({}, {
		__tostring = function()
			return "EventCutsceneManager"
		end,
	})
	EventCutsceneManager.__index = EventCutsceneManager
	function EventCutsceneManager.new(...)
		local self = setmetatable({}, EventCutsceneManager)
		return self:constructor(...) or self
	end
	function EventCutsceneManager:constructor(eventManager)
		self.cutsceneManager = CutsceneManager:getInstance()
		eventManager:registerListener(GameEventType.Cutscene, function(eventData)
			return self:handleCutscene(eventData)
		end)
	end
	function EventCutsceneManager:handleCutscene(eventData)
		local cutsceneId = eventData.cutsceneId
		self.cutsceneManager:loadCutscene(cutsceneId)
		-- this.cutsceneManager.playCutscene();
		self.cutsceneManager:playCutscene()
	end
end
return {
	EventCutsceneManager = EventCutsceneManager,
}
