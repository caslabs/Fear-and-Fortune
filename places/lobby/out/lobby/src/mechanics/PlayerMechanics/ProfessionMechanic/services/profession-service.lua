-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
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
local function PlayerClassToString(playerClass)
	repeat
		if playerClass == (PlayerClass.Mountaineer) then
			return "Mountaineer"
		end
		if playerClass == (PlayerClass.Soldier) then
			return "Soldier"
		end
		if playerClass == (PlayerClass.Engineer) then
			return "Engineer"
		end
		if playerClass == (PlayerClass.Doctor) then
			return "Doctor"
		end
		if playerClass == (PlayerClass.Scholar) then
			return "Scholar"
		end
		if playerClass == (PlayerClass.Cameraman) then
			return "Cameraman"
		end
	until true
end
local function StringToPlayerClass(playerClass)
	repeat
		if playerClass == "Mountaineer" then
			return PlayerClass.Mountaineer
		end
		if playerClass == "Soldier" then
			return PlayerClass.Soldier
		end
		if playerClass == "Engineer" then
			return PlayerClass.Engineer
		end
		if playerClass == "Doctor" then
			return PlayerClass.Doctor
		end
		if playerClass == "Scholar" then
			return PlayerClass.Scholar
		end
		if playerClass == "Cameraman" then
			return PlayerClass.Cameraman
		end
	until true
end
local PlayerProfessionUpdateEvent = Remotes.Server:Get("PlayerProfessionUpdate")
local SendPartyMemberofClassEvent = Remotes.Server:Get("SendPartyMemberofClassEvent")
local RequestUpdateProfessionEvent = Remotes.Server:Get("RequestProfessionUpdate")
local RequestPartyMemberofClassEvent = Remotes.Server:Get("RequestPartyMemberofClassEvent")
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
	function ProfessionMechanicService:constructor(profileService, partyService)
		self.profileService = profileService
		self.partyService = partyService
	end
	function ProfessionMechanicService:onStart()
		print("ProfessionMechanic Service started")
		Players.PlayerAdded:Connect(TS.async(function(player)
			local playerClass = TS.await(self:getProfession(player))
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			if playerClass == nil then
				-- If the player has no profession, set it to Mountaineer
				return nil
				-- eslint-disable-next-line roblox-ts/lua-truthiness
			elseif playerClass ~= 0 and (playerClass == playerClass and playerClass) then
				local playerClassStr = PlayerClassToString(playerClass)
				if playerClassStr == nil then
					return nil
				end
				PlayerProfessionUpdateEvent:SendToPlayer(player, playerClassStr)
				print("Profession Updated")
			end
		end))
		Players.PlayerRemoving:Connect(TS.async(function(player)
			local _profile = self.profileService
			if _profile ~= nil then
				_profile = _profile:getProfile(player)
			end
			local profile = _profile
			if profile and profile:IsActive() then
				profile.Data.class = TS.await(self:getProfession(player))
				print("Updated Profession Value")
				profile:Release()
			end
		end))
		RequestUpdateProfessionEvent:Connect(TS.async(function(player, profession)
			local playerClass = StringToPlayerClass(profession)
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			if playerClass ~= 0 and (playerClass == playerClass and playerClass) then
				TS.await(self:setProfession(player, playerClass))
			end
		end))
	end
	ProfessionMechanicService.getProfession = TS.async(function(self, player)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		return profile.Data.class
	end)
	ProfessionMechanicService.setProfession = TS.async(function(self, player, profession)
		local profile = self.profileService:getProfile(player)
		while not profile do
			TS.await(TS.Promise.delay(1))
			profile = self.profileService:getProfile(player)
		end
		if profile then
			profile.Data.class = profession
			PlayerProfessionUpdateEvent:SendToPlayer(player, PlayerClassToString(profile.Data.class))
			local members = {}
			if self.partyService:isMember(tostring(player.UserId)) then
				print("[HOST] Player is a member of a party")
				-- Assuming you have a method that identifies if the player is the host.
				-- Create a ticket specifically for the host
				-- Assuming your match-making service has a reference to your party service.
				local partyMembers = self.partyService:getPartyMembers(tostring(player.UserId))
				for _, member in ipairs(partyMembers) do
					local userId = tonumber(member.userId)
					-- Skip Local Player if member as we already have it.
					local thisPlayer = Players.LocalPlayer
					if thisPlayer and userId ~= thisPlayer.UserId then
						continue
					end
					if userId ~= nil then
						local member = Players:GetPlayerByUserId(userId)
						if member then
							table.insert(members, member)
						end
					end
				end
				SendPartyMemberofClassEvent:SendToPlayers(members, members, PlayerClassToString(profile.Data.class))
			else
				error("Profile not found for player " .. player.Name)
			end
		end
	end)
end
-- (Flamework) ProfessionMechanicService metadata
Reflect.defineMetadata(ProfessionMechanicService, "identifier", "lobby/src/mechanics/PlayerMechanics/ProfessionMechanic/services/profession-service@ProfessionMechanicService")
Reflect.defineMetadata(ProfessionMechanicService, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/profile-service@ProfileSystemMechanic", "lobby/src/systems/MatchMakingSystem/services/party-service@PartyService" })
Reflect.defineMetadata(ProfessionMechanicService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(ProfessionMechanicService, "$:flamework@Service", Service, { {
	loadOrder = 99999,
} })
return {
	ProfessionMechanicService = ProfessionMechanicService,
}
