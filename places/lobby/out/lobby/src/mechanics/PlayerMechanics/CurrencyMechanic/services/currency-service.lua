-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local UpdateCurrencyEvent = Remotes.Server:Get("UpdateCurrency")
local UpdateCurrencyTwitterEvent = Remotes.Server:Get("UpdateCurrencyTwitter")
local CurrencyMechanicService
do
	CurrencyMechanicService = setmetatable({}, {
		__tostring = function()
			return "CurrencyMechanicService"
		end,
	})
	CurrencyMechanicService.__index = CurrencyMechanicService
	function CurrencyMechanicService.new(...)
		local self = setmetatable({}, CurrencyMechanicService)
		return self:constructor(...) or self
	end
	function CurrencyMechanicService:constructor(profileService)
		self.profileService = profileService
	end
	function CurrencyMechanicService:onStart()
		print("CurrencyMechanic Service started")
		Players.PlayerAdded:Connect(TS.async(function(player)
			local currency = self:getCurrency(player)
			UpdateCurrencyEvent:SendToPlayer(player, player, TS.await(currency))
			UpdateCurrencyTwitterEvent:SendToPlayer(player, player, TS.await(currency))
			print("Curremcy Updated")
		end))
		Players.PlayerRemoving:Connect(TS.async(function(player)
			local _profile = self.profileService
			if _profile ~= nil then
				_profile = _profile:getProfile(player)
			end
			local profile = _profile
			if profile and profile:IsActive() then
				profile.Data.currency = TS.await(self:getCurrency(player))
				print("Updated Currency Value")
				profile:Release()
			end
		end))
	end
	CurrencyMechanicService.getCurrency = TS.async(function(self, player)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		return profile.Data.currency
	end)
	CurrencyMechanicService.addCurrency = TS.async(function(self, player, amount)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		if profile then
			profile.Data.currency += amount
			UpdateCurrencyEvent:SendToPlayer(player, player, profile.Data.currency)
			UpdateCurrencyTwitterEvent:SendToPlayer(player, player, profile.Data.currency)
		else
			error("Profile not found for player " .. player.Name)
		end
	end)
	CurrencyMechanicService.removeCurrency = TS.async(function(self, player, amount)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		if profile then
			profile.Data.currency += amount
			print("Removed " .. tostring(amount) .. " currency from " .. player.Name)
			print("[CURRENCY] " .. player.Name .. " now has " .. tostring(profile.Data.currency) .. " currency")
			UpdateCurrencyEvent:SendToPlayer(player, player, profile.Data.currency)
			UpdateCurrencyTwitterEvent:SendToPlayer(player, player, profile.Data.currency)
		else
			error("Profile not found for player " .. player.Name)
		end
	end)
end
-- (Flamework) CurrencyMechanicService metadata
Reflect.defineMetadata(CurrencyMechanicService, "identifier", "lobby/src/mechanics/PlayerMechanics/CurrencyMechanic/services/currency-service@CurrencyMechanicService")
Reflect.defineMetadata(CurrencyMechanicService, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic" })
Reflect.defineMetadata(CurrencyMechanicService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(CurrencyMechanicService, "$:flamework@Service", Service, { {
	loadOrder = 99999,
} })
return {
	CurrencyMechanicService = CurrencyMechanicService,
}
