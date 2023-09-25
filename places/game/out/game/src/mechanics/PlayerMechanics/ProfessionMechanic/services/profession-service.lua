-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
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
local ProfessionMechanicService
do
	ProfessionMechanicService = setmetatable({}, {
		__tostring = function()
			return "ProfessionMechanicService"
		end,
	})
	ProfessionMechanicService.__index = ProfessionMechanicService
	function ProfessionMechanicService.new(...)
		local self = setmetatable({}, ProfessionMechanicService)
		return self:constructor(...) or self
	end
	function ProfessionMechanicService:constructor(profileService)
		self.profileService = profileService
	end
	function ProfessionMechanicService:onStart()
		print("ProfessionMechanic Service started")
	end
	ProfessionMechanicService.getProfession = TS.async(function(self, player)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		return profile.Data.class
	end)
end
-- (Flamework) ProfessionMechanicService metadata
Reflect.defineMetadata(ProfessionMechanicService, "identifier", "game/src/mechanics/PlayerMechanics/ProfessionMechanic/services/profession-service@ProfessionMechanicService")
Reflect.defineMetadata(ProfessionMechanicService, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic" })
Reflect.defineMetadata(ProfessionMechanicService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(ProfessionMechanicService, "$:flamework@Service", Service, { {
	loadOrder = 99999,
} })
return {
	ProfessionMechanicService = ProfessionMechanicService,
}
