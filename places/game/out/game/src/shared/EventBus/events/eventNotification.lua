-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local NotificationManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "NotificationManager", "NotificationManager").NotificationManager
local EventNotification
do
	EventNotification = setmetatable({}, {
		__tostring = function()
			return "EventNotification"
		end,
	})
	EventNotification.__index = EventNotification
	function EventNotification.new(...)
		local self = setmetatable({}, EventNotification)
		return self:constructor(...) or self
	end
	function EventNotification:constructor(eventManager)
		self.notificationManager = NotificationManager:getInstance()
		eventManager:registerListener(GameEventType.Notification, function(eventData)
			return self:handleNotificationEvent(eventData)
		end)
	end
	function EventNotification:handleNotificationEvent(eventData)
		-- Delegate the event data to the NotificationManager
		self.notificationManager:enqueueNotification(eventData)
	end
end
return {
	EventNotification = EventNotification,
}
