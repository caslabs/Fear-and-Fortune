-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local FXManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "FXManager").FXManager
local EventFx
do
	EventFx = setmetatable({}, {
		__tostring = function()
			return "EventFx"
		end,
	})
	EventFx.__index = EventFx
	function EventFx.new(...)
		local self = setmetatable({}, EventFx)
		return self:constructor(...) or self
	end
	function EventFx:constructor(eventManager)
		self.FXManager = FXManager:getInstance()
		eventManager:registerListener(GameEventType.FX, function(eventData)
			return self:handleFXEvent(eventData)
		end)
	end
	function EventFx:handleFXEvent(eventData)
		local fxId = eventData.fxId
		-- Play the specified FX using the FXManager
		self.FXManager:playFX({
			templateId = fxId,
		})
	end
end
return {
	EventFx = EventFx,
}
