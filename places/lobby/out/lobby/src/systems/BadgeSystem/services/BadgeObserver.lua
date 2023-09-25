-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
-- BadgeObserver.ts
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local badges = TS.import(script, game:GetService("ServerScriptService"), "SystemServices", "BadgeSystem", "BadgeDefinitions").badges
--[[
	This acts as a hub to control all badge signals received from game logic
]]
local BadgeObserver
do
	BadgeObserver = setmetatable({}, {
		__tostring = function()
			return "BadgeObserver"
		end,
	})
	BadgeObserver.__index = BadgeObserver
	function BadgeObserver.new(...)
		local self = setmetatable({}, BadgeObserver)
		return self:constructor(...) or self
	end
	function BadgeObserver:constructor(badgeService)
		self.badgeService = badgeService
	end
	function BadgeObserver:onStart()
		Signals.playerFirstJoinSignal:Connect(function(player)
			self.badgeService:AwardBadge(player.UserId, badges.first_time_player.id)
			-- Assuming you have a method in BadgeService that handles awarding badges
		end)
		-- TODO: Add more badge triggers
		-- You can add listeners for other signals here...
	end
end
-- (Flamework) BadgeObserver metadata
Reflect.defineMetadata(BadgeObserver, "identifier", "lobby/src/systems/BadgeSystem/services/BadgeObserver@BadgeObserver")
Reflect.defineMetadata(BadgeObserver, "flamework:parameters", { "lobby/src/systems/BadgeSystem/services/BadgeManager@BadgeManagerService" })
Reflect.defineMetadata(BadgeObserver, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(BadgeObserver, "$:flamework@Service", Service, { {
	loadOrder = 99998,
} })
return {
	default = BadgeObserver,
}
