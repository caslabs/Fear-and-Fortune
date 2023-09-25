-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local BadgeService = _services.BadgeService
local BadgeManager
do
	BadgeManager = setmetatable({}, {
		__tostring = function()
			return "BadgeManager"
		end,
	})
	BadgeManager.__index = BadgeManager
	function BadgeManager.new(...)
		local self = setmetatable({}, BadgeManager)
		return self:constructor(...) or self
	end
	function BadgeManager:constructor()
	end
	function BadgeManager:getInstance()
		if not BadgeManager.instance then
			BadgeManager.instance = BadgeManager.new()
		end
		return BadgeManager.instance
	end
	function BadgeManager:awardBadgeToPlayers(playerUserIds, badgeId)
		local _arg0 = function(userId)
			local player = Players:GetPlayerByUserId(userId)
			if player and not BadgeService:UserHasBadgeAsync(userId, badgeId) then
				BadgeService:AwardBadge(userId, badgeId)
			end
		end
		for _k, _v in ipairs(playerUserIds) do
			_arg0(_v, _k - 1, playerUserIds)
		end
	end
end
return {
	BadgeManager = BadgeManager,
}
