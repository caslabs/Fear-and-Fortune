-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local PartyPlayer
do
	PartyPlayer = setmetatable({}, {
		__tostring = function()
			return "PartyPlayer"
		end,
	})
	PartyPlayer.__index = PartyPlayer
	function PartyPlayer.new(...)
		local self = setmetatable({}, PartyPlayer)
		return self:constructor(...) or self
	end
	function PartyPlayer:constructor(userId, role)
		self.userId = userId
		self.role = role
	end
end
local Party
do
	Party = setmetatable({}, {
		__tostring = function()
			return "Party"
		end,
	})
	Party.__index = Party
	function Party.new(...)
		local self = setmetatable({}, Party)
		return self:constructor(...) or self
	end
	function Party:constructor(host, maxSize)
		if maxSize == nil then
			maxSize = 5
		end
		self.host = host
		self.members = {}
		self.maxSize = maxSize
	end
	function Party:addMember(PartyPlayer)
		if #self.members < self.maxSize then
			local _members = self.members
			table.insert(_members, PartyPlayer)
		else
			error("Party is already full")
		end
	end
	function Party:removeMember(userId)
		local _members = self.members
		local _arg0 = function(member)
			return member.userId ~= userId
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(_members) do
			if _arg0(_v, _k - 1, _members) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		self.members = _newValue
	end
	function Party:changeHost(newHostId)
		local _members = self.members
		local _arg0 = function(member)
			return member.userId == newHostId
		end
		-- ▼ ReadonlyArray.findIndex ▼
		local _result = -1
		for _i, _v in ipairs(_members) do
			if _arg0(_v, _i - 1, _members) == true then
				_result = _i - 1
				break
			end
		end
		-- ▲ ReadonlyArray.findIndex ▲
		local newHostIndex = _result
		if newHostIndex >= 0 then
			local newHost = self.members[newHostIndex + 1]
			newHost.role = "host"
			self.host.role = "member"
			local _members_1 = self.members
			local _arg0_1 = function(_, index)
				return index ~= newHostIndex
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in ipairs(_members_1) do
				if _arg0_1(_v, _k - 1, _members_1) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self.members = _newValue
			local oldHostId = self.host.userId
			self.host = newHost
			local _members_2 = self.members
			local _arg0_2 = function(member)
				return member.userId ~= oldHostId
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue_1 = {}
			local _length_1 = 0
			for _k, _v in ipairs(_members_2) do
				if _arg0_2(_v, _k - 1, _members_2) == true then
					_length_1 += 1
					_newValue_1[_length_1] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self.members = _newValue_1
			print("New Host: ", self.host.userId, " Old Host: ", oldHostId)
		else
			error("The new host is not in the party members list")
		end
	end
	function Party:kickMember(userId, kickedBy)
		if kickedBy.role == "host" then
			self:removeMember(userId)
		else
			error("Only the host can kick party members")
		end
	end
end
local PartyUpdateEvent = Remotes.Server:Get("PartyUpdate")
local OnPlayerInvitedToPartyInvitationEvent = Remotes.Server:Get("OnPlayerInvitedToParty")
local InvitePlayerToPartyEvent = Remotes.Server:Get("InvitePlayerToParty")
local RespondToPartyInvitationEvent = Remotes.Server:Get("RespondToPartyInvitation")
local RequestQueueEvent = Remotes.Server:Get("RequestQueue")
local EnterQueueEvent = Remotes.Server:Get("EnterQueue")
local ExitQueueEvent = Remotes.Server:Get("ExitQueue")
local PartyService
do
	PartyService = setmetatable({}, {
		__tostring = function()
			return "PartyService"
		end,
	})
	PartyService.__index = PartyService
	function PartyService.new(...)
		local self = setmetatable({}, PartyService)
		return self:constructor(...) or self
	end
	function PartyService:constructor()
		self.parties = {}
	end
	function PartyService:onStart()
		print("Party Service System Started")
		InvitePlayerToPartyEvent:Connect(function(player, invitedPlayerId)
			local invitedPlayer = Players:GetPlayerByUserId(invitedPlayerId)
			if invitedPlayer then
				OnPlayerInvitedToPartyInvitationEvent:SendToPlayer(invitedPlayer, invitedPlayer, player)
			end
		end)
		RespondToPartyInvitationEvent:Connect(function(player, invitedPlayerId, invitingPlayerId, accepted)
			print("RespondToPartyInvitationEvent Called")
			local invitedPlayer = Players:GetPlayerByUserId(invitedPlayerId)
			if invitedPlayer then
				if not accepted then
					return nil
				end
				local host = PartyPlayer.new(tostring(invitingPlayerId), "host")
				local party = self:getParty(host)
				if not party then
					-- If the inviting player is not currently a host, create a party for them
					party = Party.new(host)
					local _parties = self.parties
					local _userId = host.userId
					local _party = party
					_parties[_userId] = _party
					print("Party Created")
				end
				local invitee = PartyPlayer.new(tostring(invitedPlayerId), "member")
				party:addMember(invitee)
				self:updateParty(host)
			end
		end)
		RequestQueueEvent:Connect(function(player, partyMembers, operation)
			-- convert the array of party member user IDs to an array of Player instances
			local partyMembersInQueue = {}
			for _, member in ipairs(partyMembers) do
				if member ~= nil then
					local player = Players:GetPlayerByUserId(member)
					if player then
						table.insert(partyMembersInQueue, player)
					end
				else
					-- Handle the case where userId is not a valid number
					-- e.g., throw an error, log a warning, etc.
					error("userId is not a valid number")
				end
			end
			if operation == "ENTER_QUEUE" then
				local _fn = EnterQueueEvent
				local _array = {}
				local _length = #_array
				table.move(partyMembersInQueue, 1, #partyMembersInQueue, _length + 1, _array)
				_fn:SendToPlayers(_array)
			elseif operation == "EXIT_QUEUE" then
				local _fn = ExitQueueEvent
				local _array = {}
				local _length = #_array
				table.move(partyMembersInQueue, 1, #partyMembersInQueue, _length + 1, _array)
				_fn:SendToPlayers(_array)
			end
		end)
		Players.PlayerRemoving:Connect(function(player)
			self:handlePlayerDisconnect(tostring(player.UserId))
		end)
	end
	function PartyService:getParty(hostPlayer)
		local _parties = self.parties
		local _userId = hostPlayer.userId
		return _parties[_userId]
	end
	PartyService.invitePlayer = TS.async(function(self, hostPlayer, invitedPlayer)
		local party = self:getParty(hostPlayer)
		if not party then
			-- If the inviting PartyPlayer is not currently a host, create a party for them
			party = Party.new(hostPlayer)
			local _parties = self.parties
			local _userId = hostPlayer.userId
			local _party = party
			_parties[_userId] = _party
		end
		party:addMember(invitedPlayer)
		self:updateParty(hostPlayer)
	end)
	function PartyService:isMember(userId)
		local isMember = false
		local _parties = self.parties
		local _arg0 = function(party)
			local _condition = party.host.userId == userId
			if not _condition then
				local _members = party.members
				local _arg0_1 = function(member)
					return member.userId == userId
				end
				-- ▼ ReadonlyArray.some ▼
				local _result = false
				for _k, _v in ipairs(_members) do
					if _arg0_1(_v, _k - 1, _members) then
						_result = true
						break
					end
				end
				-- ▲ ReadonlyArray.some ▲
				_condition = _result
			end
			if _condition then
				isMember = true
				return nil
			end
		end
		for _k, _v in pairs(_parties) do
			_arg0(_v, _k, _parties)
		end
		return isMember
	end
	function PartyService:removePlayerFromParty(playerId)
		local _parties = self.parties
		local _arg0 = function(party, hostId)
			local initialMembersSize = #party.members
			party:removeMember(playerId)
			if party.host.userId == playerId then
				-- If the party host leaves, assign a new host or destroy the party
				if #party.members > 0 then
					print("HOST LEFT DETECTED! UPDATING NEW HOST")
					party:changeHost(party.members[1].userId)
					self.parties[hostId] = nil
					local _parties_1 = self.parties
					local _userId = party.host.userId
					_parties_1[_userId] = party
					self:updateParty(PartyPlayer.new(party.host.userId, "host"))
				else
					self.parties[hostId] = nil
				end
			elseif initialMembersSize ~= #party.members then
				-- If the size of the party members has changed, then a member was removed and we update the party
				self:updateParty(PartyPlayer.new(hostId, "host"))
			end
		end
		for _k, _v in pairs(_parties) do
			_arg0(_v, _k, _parties)
		end
	end
	function PartyService:handlePlayerDisconnect(playerId)
		-- Handle a PartyPlayer disconnecting or leaving the game
		self:removePlayerFromParty(playerId)
	end
	function PartyService:acceptInvite(PartyPlayer, hostPlayer)
		local party = self:getParty(hostPlayer)
		if party then
			party:addMember(PartyPlayer)
		end
	end
	function PartyService:isHost(userId)
		local party = self.parties[userId]
		if party then
			print("Party Found", party.host.userId, userId)
			return party.host.userId == userId and #party.members > 0
		end
		return false
	end
	function PartyService:getPartyByMember(memberId)
		local foundParty
		local _parties = self.parties
		local _arg0 = function(party, hostId)
			local _members = party.members
			local _arg0_1 = function(member)
				return member.userId == memberId
			end
			-- ▼ ReadonlyArray.some ▼
			local _result = false
			for _k, _v in ipairs(_members) do
				if _arg0_1(_v, _k - 1, _members) then
					_result = true
					break
				end
			end
			-- ▲ ReadonlyArray.some ▲
			local _condition = _result
			if not _condition then
				_condition = party.host.userId == memberId
			end
			if _condition then
				foundParty = party
				print("Party Found", party.host.userId, memberId)
				return nil
			end
		end
		for _k, _v in pairs(_parties) do
			_arg0(_v, _k, _parties)
		end
		return foundParty
	end
	function PartyService:getHostPlayer(member)
		local party = self:getPartyByMember(tostring(member.UserId))
		if party then
			local hostId = tonumber(party.host.userId)
			if hostId ~= nil then
				return Players:GetPlayerByUserId(hostId)
			else
				error("Invalid host ID: " .. party.host.userId)
				return nil
			end
		end
		return nil
	end
	function PartyService:kickPlayerFromParty(hostPlayer, targetPlayer)
		local party = self:getParty(hostPlayer)
		if party and hostPlayer.role == "host" then
			party:kickMember(targetPlayer.userId, hostPlayer)
			self:updateParty(hostPlayer)
		else
			error("The host PartyPlayer either doesn't exist or isn't the host of a party")
		end
	end
	function PartyService:getPartyMembers(hostId)
		local party = self.parties[hostId]
		if party then
			return party.members
		else
			error("No party found for the provided hostId")
		end
	end
	PartyService.updateParty = TS.async(function(self, hostPlayer)
		local party = self:getParty(hostPlayer)
		if party then
			-- Get Player instances from string user IDs
			local partyMembers = {}
			for _, member in ipairs(party.members) do
				local userIdNumber = tonumber(member.userId)
				if userIdNumber ~= nil then
					local player = Players:GetPlayerByUserId(userIdNumber)
					if player then
						table.insert(partyMembers, player)
					end
				else
					-- Handle the case where userId is not a valid number
					-- e.g., throw an error, log a warning, etc.
					error("userId is not a valid number")
				end
			end
			local hostId = party.host.userId
			local hostPlayerIdNumber = tonumber(hostPlayer.userId)
			if hostPlayerIdNumber ~= nil then
				local hostPlayerRbx = Players:GetPlayerByUserId(hostPlayerIdNumber)
				local _array = { hostPlayerRbx }
				local _length = #_array
				table.move(partyMembers, 1, #partyMembers, _length + 1, _array)
				print("Sending Update to", _array)
				if hostPlayerRbx then
					-- Fire the PartyUpdate event for the host player and pass the list of party members
					local _fn = PartyUpdateEvent
					local _array_1 = { hostPlayerRbx }
					local _length_1 = #_array_1
					table.move(partyMembers, 1, #partyMembers, _length_1 + 1, _array_1)
					local _arg0 = function(member)
						return member.UserId
					end
					-- ▼ ReadonlyArray.map ▼
					local _newValue = table.create(#partyMembers)
					for _k, _v in ipairs(partyMembers) do
						_newValue[_k] = _arg0(_v, _k - 1, partyMembers)
					end
					-- ▲ ReadonlyArray.map ▲
					_fn:SendToPlayers(_array_1, hostId, _newValue)
				end
			else
				error("userId is not a valid number")
			end
		end
	end)
end
-- (Flamework) PartyService metadata
Reflect.defineMetadata(PartyService, "identifier", "lobby/src/systems/MatchMakingSystem/services/party-service@PartyService")
Reflect.defineMetadata(PartyService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(PartyService, "$:flamework@Service", Service, { {} })
return {
	Party = Party,
	default = PartyService,
}
