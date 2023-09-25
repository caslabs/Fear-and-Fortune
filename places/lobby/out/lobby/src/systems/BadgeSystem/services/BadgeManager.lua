-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local BadgeService = TS.import(script, TS.getModule(script, "@rbxts", "services")).BadgeService
--[[
	Badge Manager manages badge award to player
]]
local BadgeManagerService
do
	BadgeManagerService = setmetatable({}, {
		__tostring = function()
			return "BadgeManagerService"
		end,
	})
	BadgeManagerService.__index = BadgeManagerService
	function BadgeManagerService.new(...)
		local self = setmetatable({}, BadgeManagerService)
		return self:constructor(...) or self
	end
	function BadgeManagerService:constructor()
	end
	function BadgeManagerService:onStart()
		print("BadgeManagerService Service Started")
	end
	function BadgeManagerService:AwardBadge(playerID, badgeID)
		BadgeService:AwardBadge(playerID, badgeID)
	end
	BadgeManagerService.awardBadge = TS.async(function(self, playerID, badgeID)
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		if TS.await(self:hasBadge(playerID, badgeID)) then
			error("Player " .. (tostring(playerID) .. (" already has badge " .. tostring(badgeID))))
		end
		BadgeService:AwardBadge(playerID, badgeID)
	end)
	BadgeManagerService.hasBadge = TS.async(function(self, playerID, badgeID)
		return BadgeService:UserHasBadgeAsync(playerID, badgeID)
	end)
end
-- (Flamework) BadgeManagerService metadata
Reflect.defineMetadata(BadgeManagerService, "identifier", "lobby/src/systems/BadgeSystem/services/BadgeManager@BadgeManagerService")
Reflect.defineMetadata(BadgeManagerService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(BadgeManagerService, "$:flamework@Service", Service, { {
	loadOrder = 0,
} })
return {
	default = BadgeManagerService,
}
