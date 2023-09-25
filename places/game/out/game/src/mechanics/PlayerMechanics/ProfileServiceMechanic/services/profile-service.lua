-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local ProfileService = TS.import(script, TS.getModule(script, "@rbxts", "profileservice").src)
local PlayerClass
do
	local _inverse = {}
	PlayerClass = setmetatable({}, {
		__index = _inverse,
	})
	PlayerClass.Mountaineer = 0
	_inverse[0] = "Mountaineer"
	PlayerClass.Soldier = 1
	_inverse[1] = "Soldier"
	PlayerClass.Engineer = 2
	_inverse[2] = "Engineer"
	PlayerClass.Doctor = 3
	_inverse[3] = "Doctor"
	PlayerClass.Scholar = 4
	_inverse[4] = "Scholar"
	PlayerClass.Cameraman = 5
	_inverse[5] = "Cameraman"
end
-- TODO: Finalize Profile Data Structure
local profileTemplate = {
	inventory = {},
	backpack = {},
	currency = 0,
	class = PlayerClass.Soldier,
	twitter_code_1 = false,
	twitter_code_2 = false,
	donation = 0,
	successful_expeditions = 0,
}
local profileStore = ProfileService.GetProfileStore("PlayerData", profileTemplate)
local ProfileSystemMechanic
do
	ProfileSystemMechanic = setmetatable({}, {
		__tostring = function()
			return "ProfileSystemMechanic"
		end,
	})
	ProfileSystemMechanic.__index = ProfileSystemMechanic
	function ProfileSystemMechanic.new(...)
		local self = setmetatable({}, ProfileSystemMechanic)
		return self:constructor(...) or self
	end
	function ProfileSystemMechanic:constructor()
		self.profiles = {}
	end
	function ProfileSystemMechanic:onInit()
		print("ProfileServiceSystem service initiated")
	end
	function ProfileSystemMechanic:onStart()
		Players.PlayerAdded:Connect(function(player)
			local profile = profileStore:LoadProfileAsync("Player_" .. tostring(player.UserId), "ForceLoad")
			if profile then
				if profile.Data.inventory == nil then
					profile.Data.inventory = profileTemplate.inventory
				end
				if profile.Data.backpack == nil then
					profile.Data.backpack = profileTemplate.backpack
				end
				if profile.Data.currency == nil then
					profile.Data.currency = profileTemplate.currency
				end
				if profile.Data.class == nil then
					profile.Data.class = profileTemplate.class
				end
				if profile.Data.twitter_code_1 == nil then
					profile.Data.twitter_code_1 = profileTemplate.twitter_code_1
				end
				if profile.Data.twitter_code_2 == nil then
					profile.Data.twitter_code_2 = profileTemplate.twitter_code_2
				end
				if profile.Data.donation == nil then
					profile.Data.donation = profileTemplate.donation
				end
				if profile.Data.successful_expeditions == nil then
					profile.Data.successful_expeditions = profileTemplate.successful_expeditions
				end
				local _profiles = self.profiles
				local _userId = player.UserId
				_profiles[_userId] = profile
			else
				print("[PROFILE] Failed to load profile for " .. player.Name)
			end
		end)
		Players.PlayerRemoving:Connect(function(player)
			local _profiles = self.profiles
			local _userId = player.UserId
			local profile = _profiles[_userId]
			if profile and profile:IsActive() then
				profile:Release()
				local _profiles_1 = self.profiles
				local _userId_1 = player.UserId
				_profiles_1[_userId_1] = nil
			end
		end)
		print("ProfileServiceSystem service started")
	end
	function ProfileSystemMechanic:getProfile(player)
		local _profiles = self.profiles
		local _userId = player.UserId
		return _profiles[_userId]
	end
end
-- (Flamework) ProfileSystemMechanic metadata
Reflect.defineMetadata(ProfileSystemMechanic, "identifier", "game/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic")
Reflect.defineMetadata(ProfileSystemMechanic, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(ProfileSystemMechanic, "$:flamework@Service", Service, { {
	loadOrder = -1,
} })
return {
	ProfileSystemMechanic = ProfileSystemMechanic,
}
