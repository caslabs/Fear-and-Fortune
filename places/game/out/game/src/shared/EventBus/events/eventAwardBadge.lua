-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local BadgeManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "BadgeManager").BadgeManager
local AwardBadgeHandler
do
	AwardBadgeHandler = setmetatable({}, {
		__tostring = function()
			return "AwardBadgeHandler"
		end,
	})
	AwardBadgeHandler.__index = AwardBadgeHandler
	function AwardBadgeHandler.new(...)
		local self = setmetatable({}, AwardBadgeHandler)
		return self:constructor(...) or self
	end
	function AwardBadgeHandler:constructor(eventManager)
		self.badgeManager = BadgeManager:getInstance()
		eventManager:registerListener(GameEventType.AwardBadge, function(eventData)
			return self:handleAwardBadge(eventData)
		end)
	end
	function AwardBadgeHandler:handleAwardBadge(eventData)
		self.badgeManager:awardBadgeToPlayers(eventData.players, eventData.badgeId)
	end
end
return {
	AwardBadgeHandler = AwardBadgeHandler,
}
