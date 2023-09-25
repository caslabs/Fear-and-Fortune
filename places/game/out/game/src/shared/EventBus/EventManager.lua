-- Compiled with roblox-ts v1.3.3
local EventManager
do
	EventManager = setmetatable({}, {
		__tostring = function()
			return "EventManager"
		end,
	})
	EventManager.__index = EventManager
	function EventManager.new(...)
		local self = setmetatable({}, EventManager)
		return self:constructor(...) or self
	end
	function EventManager:constructor()
		self.listeners = {}
	end
	function EventManager:getInstance()
		if not EventManager.instance then
			EventManager.instance = EventManager.new()
		end
		return EventManager.instance
	end
	function EventManager:registerListener(eventType, callback)
		if not (self.listeners[eventType] ~= nil) then
			self.listeners[eventType] = {}
		end
		local listenerSet = self.listeners[eventType]
		local _result = listenerSet
		if _result ~= nil then
			_result[callback] = true
		end
	end
	function EventManager:deregisterListener(eventType, callback)
		local listenerSet = self.listeners[eventType]
		if listenerSet then
			listenerSet[callback] = nil
		end
	end
	function EventManager:dispatchEvent(eventType, eventData)
		local listenerSet = self.listeners[eventType]
		if listenerSet then
			for callback in pairs(listenerSet) do
				callback(eventData)
			end
		end
	end
end
return {
	EventManager = EventManager,
}
