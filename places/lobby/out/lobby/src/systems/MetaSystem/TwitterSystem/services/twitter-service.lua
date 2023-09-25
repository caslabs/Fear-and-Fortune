-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local TwitterSystemService
do
	TwitterSystemService = setmetatable({}, {
		__tostring = function()
			return "TwitterSystemService"
		end,
	})
	TwitterSystemService.__index = TwitterSystemService
	function TwitterSystemService.new(...)
		local self = setmetatable({}, TwitterSystemService)
		return self:constructor(...) or self
	end
	function TwitterSystemService:constructor(profileService, currencyMechanic)
		self.profileService = profileService
		self.currencyMechanic = currencyMechanic
	end
	function TwitterSystemService:onInit()
		print("TwitterSystem Service initialized")
	end
	function TwitterSystemService:onStart()
		print("TwitterSystem Service Started")
		-- Check Code for UI end
		local CheckIfReedemEvent = Remotes.Server:Get("CheckIfReedem")
		CheckIfReedemEvent:SetCallback(TS.async(function(player)
			return TS.await(self:checkIfReedem(player))
		end))
		-- Reedem Code
		-- Reedem Code
		local ReedemTwitterCodeEvent = Remotes.Server:Get("ReedemTwitterCode")
		ReedemTwitterCodeEvent:SetCallback(function(player, code)
			print("Bruh")
			return self:reedemTwitterCode(player, code)
		end)
	end
	TwitterSystemService.checkIfReedem = TS.async(function(self, player)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		print(profile.Data.twitter_code_1)
		return profile.Data.twitter_code_1
	end)
	TwitterSystemService.reedemTwitterCode = TS.async(function(self, player, code)
		if not (TS.await(self:checkIfReedem(player))) then
			local profile = self.profileService:getProfile(player)
			while not profile do
				TS.await(TS.Promise.delay(1))
				profile = self.profileService:getProfile(player)
			end
			if profile then
				if code == "PLAYTEST" then
					self:award(player)
					return "Success!"
				else
					return "Wrong Code!"
				end
			else
				return "Failed to fetch profile!"
			end
		else
			return "Already Redeemed!"
		end
	end)
	TwitterSystemService.award = TS.async(function(self, player)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		self.currencyMechanic:addCurrency(player, 10000)
		profile.Data.twitter_code_1 = true
		profile:Release()
	end)
end
-- (Flamework) TwitterSystemService metadata
Reflect.defineMetadata(TwitterSystemService, "identifier", "lobby/src/systems/MetaSystem/TwitterSystem/services/twitter-service@TwitterSystemService")
Reflect.defineMetadata(TwitterSystemService, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic", "lobby/src/mechanics/PlayerMechanics/CurrencyMechanic/services/currency-service@CurrencyMechanicService" })
Reflect.defineMetadata(TwitterSystemService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(TwitterSystemService, "$:flamework@Service", Service, { {} })
return {
	default = TwitterSystemService,
}
