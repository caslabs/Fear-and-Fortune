-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local DataStoreService = _services.DataStoreService
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local getExpeditionDataFunc = Remotes.Server:Get("GetExpeditionData")
local ExpeditionSystemService
do
	ExpeditionSystemService = setmetatable({}, {
		__tostring = function()
			return "ExpeditionSystemService"
		end,
	})
	ExpeditionSystemService.__index = ExpeditionSystemService
	function ExpeditionSystemService.new(...)
		local self = setmetatable({}, ExpeditionSystemService)
		return self:constructor(...) or self
	end
	function ExpeditionSystemService:constructor(profileService)
		self.profileService = profileService
		self.ExpeditionExpedition = DataStoreService:GetOrderedDataStore("ExpeditionLeaderboard")
	end
	function ExpeditionSystemService:onInit()
		print("ExpeditionSystem Service initialized")
	end
	function ExpeditionSystemService:onStart()
		print("ExpeditionSystem Service Started")
		getExpeditionDataFunc:SetCallback(TS.async(function(player)
			-- Add print statement for debugging
			print("Fetching Expedition data...")
			local topDonators = {}
			local dataPages = self.ExpeditionExpedition:GetSortedAsync(false, 10)
			-- Get first page
			local data = dataPages:GetCurrentPage()
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < #data and i < 10) then
						break
					end
					local ExpeditionData = data[i + 1]
					local userId = tonumber(ExpeditionData.key)
					-- Ensure userId is not undefined before passing to GetNameFromUserIdAsync
					if userId == nil then
						warn("Unable to convert " .. (ExpeditionData.key .. " to a number"))
						continue
					end
					local _arg0 = {
						name = TS.await(Players:GetNameFromUserIdAsync(userId)),
						expedition = ExpeditionData.value,
					}
					table.insert(topDonators, _arg0)
				end
			end
			-- Add print statement for debugging
			print("Fetched Expedition data")
			-- eslint-disable-next-line roblox-ts/no-array-pairs
			for player, Expedition in pairs(topDonators) do
				print(tostring(player + 1) .. (". " .. (Expedition.name .. (" - ₹" .. tostring(Expedition.expedition)))))
			end
			return topDonators
		end))
	end
end
-- (Flamework) ExpeditionSystemService metadata
Reflect.defineMetadata(ExpeditionSystemService, "identifier", "lobby/src/systems/MetaSystem/LeaderboardSystem/services/expedition-service@ExpeditionSystemService")
Reflect.defineMetadata(ExpeditionSystemService, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic" })
Reflect.defineMetadata(ExpeditionSystemService, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(ExpeditionSystemService, "$:flamework@Service", Service, { {} })
return {
	default = ExpeditionSystemService,
}
