-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local ProfileService = TS.import(script, TS.getModule(script, "@rbxts", "profileservice").src)
-- Constants
local PROFILE_STORE_NAME = "PlayerData"
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
local ProfileData
do
	ProfileData = setmetatable({}, {
		__tostring = function()
			return "ProfileData"
		end,
	})
	ProfileData.__index = ProfileData
	function ProfileData.new(...)
		local self = setmetatable({}, ProfileData)
		return self:constructor(...) or self
	end
	function ProfileData:constructor()
		self.inventory = {}
		self.backpack = {}
		self.currency = 0
		self.class = PlayerClass.Soldier
		self.twitter_code_1 = false
		self.twitter_code_2 = false
		self.donation = 0
		self.successful_expeditions = 0
	end
end
local profileStore = ProfileService.GetProfileStore(PROFILE_STORE_NAME, ProfileData.new())
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
			return self:handlePlayerAdded(player)
		end)
		Players.PlayerRemoving:Connect(function(player)
			return self:handlePlayerRemoved(player)
		end)
		print("ProfileServiceSystem service started")
	end
	function ProfileSystemMechanic:handlePlayerAdded(player)
		local profile = profileStore:LoadProfileAsync("Player_" .. tostring(player.UserId), "ForceLoad")
		if profile then
			-- TODO: Consider undefined case
			local _profiles = self.profiles
			local _userId = player.UserId
			_profiles[_userId] = profile
		else
			error("[PROFILE] Failed to load profile for " .. player.Name)
			-- Handle error as appropriate for your use case
		end
	end
	function ProfileSystemMechanic:handlePlayerRemoved(player)
		local _profiles = self.profiles
		local _userId = player.UserId
		local profile = _profiles[_userId]
		if profile and profile:IsActive() then
			profile:Release()
			local _profiles_1 = self.profiles
			local _userId_1 = player.UserId
			_profiles_1[_userId_1] = nil
		end
	end
	function ProfileSystemMechanic:getProfile(player)
		local _profiles = self.profiles
		local _userId = player.UserId
		return _profiles[_userId]
	end
end
-- (Flamework) ProfileSystemMechanic metadata
Reflect.defineMetadata(ProfileSystemMechanic, "identifier", "lobby/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic")
Reflect.defineMetadata(ProfileSystemMechanic, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(ProfileSystemMechanic, "$:flamework@Service", Service, { {
	loadOrder = -1,
} })
return {
	ProfileSystemMechanic = ProfileSystemMechanic,
}
