-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local PostProcessingManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "PostProcessingManager").PostProcessingManager
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local _postProcessingStates = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "PostProcessingManager", "postProcessingStates")
local BlackoutState = _postProcessingStates.BlackoutState
local DefaultState = _postProcessingStates.DefaultState
local JumpscareState = _postProcessingStates.JumpscareState
local JumpscareZoomState = _postProcessingStates.JumpscareZoomState
local ZoomState = _postProcessingStates.ZoomState
local EventPostProcessing
do
	EventPostProcessing = setmetatable({}, {
		__tostring = function()
			return "EventPostProcessing"
		end,
	})
	EventPostProcessing.__index = EventPostProcessing
	function EventPostProcessing.new(...)
		local self = setmetatable({}, EventPostProcessing)
		return self:constructor(...) or self
	end
	function EventPostProcessing:constructor(eventManager)
		self.postProcessingManager = PostProcessingManager:getInstance()
		-- Create the post-processing templates
		self.postProcessingManager:createTemplate("blackout", BlackoutState.new(), {
			Brightness = 0,
		})
		self.postProcessingManager:createTemplate("jumpscare", JumpscareState.new(), {
			Brightness = 1,
		})
		self.postProcessingManager:createTemplate("default", DefaultState.new(), {})
		self.postProcessingManager:createTemplate("jumpscarezoom", JumpscareZoomState.new(), {})
		self.postProcessingManager:createTemplate("zoom", ZoomState.new(), {})
		eventManager:registerListener(GameEventType.PostProcessing, function(eventData)
			return self:handlePostProcessingEvent(eventData)
		end)
	end
	function EventPostProcessing:handlePostProcessingEvent(eventData)
		local state = eventData.state
		-- Update the post-processing state using the PostProcessingManager
		self.postProcessingManager:updateState(state, "smooth")
	end
end
return {
	EventPostProcessing = EventPostProcessing,
}
