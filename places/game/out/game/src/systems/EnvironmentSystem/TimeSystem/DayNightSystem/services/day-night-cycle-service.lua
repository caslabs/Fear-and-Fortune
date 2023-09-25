-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local RunService = _services.RunService
local Lighting = _services.Lighting
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
-- TODO: Should we have a day and night system?
-- How would it be part of our game system? I don't see it...
local DayNightCycleService
do
	DayNightCycleService = setmetatable({}, {
		__tostring = function()
			return "DayNightCycleService"
		end,
	})
	DayNightCycleService.__index = DayNightCycleService
	function DayNightCycleService.new(...)
		local self = setmetatable({}, DayNightCycleService)
		return self:constructor(...) or self
	end
	function DayNightCycleService:constructor()
		self.realMinutesPerInGameDay = 1500 / 60
		self.inGameHoursPerRealSecond = 24 / (self.realMinutesPerInGameDay * 60)
	end
	function DayNightCycleService:onInit()
		print("DayNightCycleService started")
		-- Only start the day/night cycle if this is running on the server
		if RunService:IsServer() then
			self:startDayNightCycle()
		end
	end
	function DayNightCycleService:startDayNightCycle()
		RunService.Heartbeat:Connect(function(deltaTime)
			-- Update the in-game time based on how much real time has passed since the last frame
			local newTime = (Lighting.ClockTime + self.inGameHoursPerRealSecond * deltaTime) % 24
			Lighting.ClockTime = newTime
		end)
	end
end
-- (Flamework) DayNightCycleService metadata
Reflect.defineMetadata(DayNightCycleService, "identifier", "game/src/systems/EnvironmentSystem/TimeSystem/DayNightSystem/services/day-night-cycle-service@DayNightCycleService")
Reflect.defineMetadata(DayNightCycleService, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(DayNightCycleService, "$:flamework@Service", Service, { {} })
return {
	DayNightCycleService = DayNightCycleService,
}
