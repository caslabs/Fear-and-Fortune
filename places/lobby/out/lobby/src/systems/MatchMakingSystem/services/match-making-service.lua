-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local TeleportService = _services.TeleportService
local MessagingService = _services.MessagingService
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local QueueState = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").QueueState
local PlayFabMultiplayer = TS.import(script, TS.getModule(script, "@rbxts", "playfab").out).PlayFabMultiplayer
local function tableToString(obj)
	local result = "{ "
	for key, val in pairs(obj) do
		result = result .. key .. " : " .. tostring(val) .. ", "
	end
	return result .. " }"
end
local ExecuteMatchEvent = Remotes.Server:Get("ExecuteMatch")
local UpdatePlayerCountEvent = Remotes.Server:Get("UpdatePlayerCount")
local QueueStateChangeEvent = Remotes.Server:Get("QueueStateChange")
local UpdateQueueMembers = Remotes.Server:Get("UpdateQueueMembers")
local MatchMakingService
do
	MatchMakingService = setmetatable({}, {
		__tostring = function()
			return "MatchMakingService"
		end,
	})
	MatchMakingService.__index = MatchMakingService
	function MatchMakingService.new(...)
		local self = setmetatable({}, MatchMakingService)
		return self:constructor(...) or self
	end
	function MatchMakingService:constructor(sessionService, partyService)
		self.sessionService = sessionService
		self.partyService = partyService
		self.queuedPlayers = {}
		self.matchToServerMap = {}
		self.queuedPlayersPLAYFAB = {}
		self.playerMatchmakingTickets = {}
		self.memberMatchmakingTickets = {}
		self.queueName = "Demo_Queue"
		self.matchmakingTimeout = 120
		self.matchmakingPollInterval = 6
	end
	function MatchMakingService:onStart()
		print("MatchMaking Service Started")
		local JoinMatchEvent = Remotes.Server:Get("JoinMatch"):Connect(function(player)
			-- this.addPlayerToQueue(player);
			-- this.addPlayerToQueue(player);
			self:handleJoinQueueRequest(player)
		end)
		local LeaveMatchEvent = Remotes.Server:Get("LeaveMatch"):Connect(function(player)
			self:handlePlayerRemoving(player)
		end)
		local TeleportMatchEvent = Remotes.Server:Get("TeleportMatch"):Connect(function(player) end)
		TS.try(function()
			MessagingService:SubscribeAsync("MatchMakingChannel", TS.async(function(message)
				print("[MATCH MAKING] Received message: ", message)
				print("[MATCH MAKING] Received message as string: ", tableToString(message))
				local messageData = message.Data
				print("[MATCH MAKING] Message Data: ", messageData)
				print("[MATCH MAKING] Message Data as string: ", tableToString(messageData))
				local castedMessage = messageData
				if castedMessage.type == "MATCH_FOUND" then
					local _matchToServerMap = self.matchToServerMap
					local _matchId = castedMessage.matchId
					local _reservedServerCode = castedMessage.reservedServerCode
					_matchToServerMap[_matchId] = _reservedServerCode
					-- When a match is found, get the corresponding players and teleport them
					-- When a match is found, get the corresponding players and teleport them
					local players = {}
					for _, userId in ipairs(castedMessage.userIds) do
						local numUserId = tonumber(userId)
						if numUserId ~= nil then
							local player = Players:GetPlayerByUserId(numUserId)
							if player ~= nil then
								table.insert(players, player)
							end
						end
					end
					if #players > 0 then
						self:teleportPlayerToMatch(players, castedMessage.matchId)
					end
				else
					print("none BRUH")
				end
			end))
		end, function()
			print("[MATCH MAKING] Error subscribing to MessagingService: ")
		end)
		Players.PlayerAdded:Connect(function(player)
			print("[MATCH MAKING] Player added: ", player.Name)
		end)
		self:driveMatchmakingLoop()
	end
	MatchMakingService.handleJoinQueueRequest = TS.async(function(self, player)
		local playerSession = self.sessionService:getPlayerSession(player)
		print("[MATCH MAKING] Player in handleJoin", player.Name)
		-- If host, then have MembersToMatchWith
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		if self.partyService:isHost(tostring(player.UserId)) then
			print("[HOST] Player is host")
			-- Assuming you have a method that identifies if the player is the host.
			-- Create a ticket specifically for the host
			-- Assuming your match-making service has a reference to your party service.
			local partyMembers = self.partyService:getPartyMembers(tostring(player.UserId))
			for _, member in ipairs(partyMembers) do
				print("[HOST] member: ", member.userId)
			end
			-- Loop over each party member to get their player session and entity key
			local memberEntityKeys = {}
			for _, member in ipairs(partyMembers) do
				local userIdNumber = tonumber(member.userId)
				if userIdNumber ~= nil then
					local memberPlayer = Players:GetPlayerByUserId(userIdNumber)
					if memberPlayer then
						local playerSession = TS.await(self.sessionService:getPlayerSession(memberPlayer))
						if playerSession then
							-- Make sure the entityKey has a Type
							local _entityKey = playerSession.entityKey
							table.insert(memberEntityKeys, _entityKey)
						else
							error("PlayerSession could not be retrieved or the entityKey does not have a Type")
						end
					else
						error("userId does not correspond to a valid Player")
					end
				else
					error("userId is not a valid number")
				end
			end
			print("[HOST] memberEntityKeys: ", memberEntityKeys)
			-- Iterate over memberEntityKeys
			for _, memberEntityKey in ipairs(memberEntityKeys) do
				print("[HOST] memberEntityKey: ", memberEntityKey.Id, memberEntityKey.Type)
			end
			local _fn = PlayFabMultiplayer
			local _exp = playerSession.entityToken
			local _object = {
				Creator = {
					Entity = playerSession.entityKey,
				},
				GiveUpAfterSeconds = self.matchmakingTimeout,
				QueueName = self.queueName,
			}
			local _left = "MembersToMatchWith"
			local _array = {}
			local _length = #_array
			table.move(memberEntityKeys, 1, #memberEntityKeys, _length + 1, _array)
			_object[_left] = _array
			local _exp_1 = _fn:CreateMatchmakingTicket(_exp, _object)
			local _arg0 = function(ticket)
				print("[HOST] ticket: ", ticket)
				-- The line should be here
				print("ABOUT OT ENTER TICKET")
				print("[HOST] ticket: ", ticket)
				local _playerMatchmakingTickets = self.playerMatchmakingTickets
				local _ticketId = ticket.TicketId
				_playerMatchmakingTickets[player] = _ticketId
				print("HOST ENTERED TICKET")
			end
			local ticket = _exp_1:andThen(_arg0)
		elseif self.partyService:isMember(tostring(player.UserId)) then
			local hostPlayer = self.partyService:getHostPlayer(player)
			if not hostPlayer then
				error("Error getting host player")
			end
			local ticketId = self.playerMatchmakingTickets[hostPlayer]
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			if ticketId ~= "" and ticketId then
				PlayFabMultiplayer:JoinMatchmakingTicket(playerSession.entityToken, {
					TicketId = ticketId,
					QueueName = self.queueName,
					Member = {
						Entity = playerSession.entityKey,
					},
				})
				self.memberMatchmakingTickets[player] = ticketId
			end
			print("MEMBER JOINED TICKET")
		else
			-- Solo queue
			local ticket = PlayFabMultiplayer:CreateMatchmakingTicket(playerSession.entityToken, {
				Creator = {
					Entity = playerSession.entityKey,
				},
				GiveUpAfterSeconds = self.matchmakingTimeout,
				QueueName = self.queueName,
			})
			local _playerMatchmakingTickets = self.playerMatchmakingTickets
			local _ticketId = (TS.await(ticket)).TicketId
			_playerMatchmakingTickets[player] = _ticketId
		end
		return true
	end)
	function MatchMakingService:handlePlayerRemoving(player)
		if not (self.playerMatchmakingTickets[player] ~= nil) then
			return nil
		end
		local playerSession = self.sessionService:getPlayerSession(player)
		PlayFabMultiplayer:CancelAllMatchmakingTicketsForPlayer(playerSession.entityToken, {
			QueueName = self.queueName,
			Entity = playerSession.entityKey,
		})
		self.playerMatchmakingTickets[player] = nil
	end
	MatchMakingService.driveMatchmakingLoop = TS.async(function(self)
		-- Map to hold matched players grouped by matchId
		local matchedPlayersMap = {}
		-- ▼ ReadonlyMap.size ▼
		local _size = 0
		for _ in pairs(self.playerMatchmakingTickets) do
			_size += 1
		end
		-- ▲ ReadonlyMap.size ▲
		if _size > 0 then
			for player, ticketId in pairs(self.playerMatchmakingTickets) do
				local playerSession = self.sessionService:getPlayerSession(player)
				local ticket = TS.await(PlayFabMultiplayer:GetMatchmakingTicket(playerSession.entityToken, {
					TicketId = ticketId,
					QueueName = self.queueName,
					EscapeObject = false,
				}))
				print("Ticket", ticket)
				local _value = ticket.Status == "Matched" and ticket.MatchId
				if _value ~= "" and _value then
					-- We found a match!
					local _matchId = ticket.MatchId
					if not (matchedPlayersMap[_matchId] ~= nil) then
						local _matchId_1 = ticket.MatchId
						matchedPlayersMap[_matchId_1] = {}
					end
					-- Get the player list and check if it is defined
					local _matchId_1 = ticket.MatchId
					local players = matchedPlayersMap[_matchId_1]
					if players then
						table.insert(players, player)
					end
				end
			end
		end
		-- ▼ ReadonlyMap.size ▼
		local _size_1 = 0
		for _ in pairs(self.memberMatchmakingTickets) do
			_size_1 += 1
		end
		-- ▲ ReadonlyMap.size ▲
		if _size_1 > 0 then
			for player, ticketId in pairs(self.memberMatchmakingTickets) do
				local playerSession = self.sessionService:getPlayerSession(player)
				local ticket = TS.await(PlayFabMultiplayer:GetMatchmakingTicket(playerSession.entityToken, {
					TicketId = ticketId,
					QueueName = self.queueName,
					EscapeObject = false,
				}))
				print("Ticket", ticket)
				local _value = ticket.Status == "Matched" and ticket.MatchId
				if _value ~= "" and _value then
					-- We found a match!
					local _matchId = ticket.MatchId
					if not (matchedPlayersMap[_matchId] ~= nil) then
						local _matchId_1 = ticket.MatchId
						matchedPlayersMap[_matchId_1] = {}
					end
					-- Get the player list and check if it is defined
					local _matchId_1 = ticket.MatchId
					local players = matchedPlayersMap[_matchId_1]
					if players then
						table.insert(players, player)
					end
				end
			end
		else
			print("No tickets to process")
		end
		-- Iterate over the matchedPlayersMap and handle each unique match
		for matchId, players in pairs(matchedPlayersMap) do
			self:handleFoundMatch(players, matchId)
		end
		task.delay(self.matchmakingPollInterval, function()
			self:driveMatchmakingLoop()
		end)
	end)
	function MatchMakingService:handleFoundMatch(players, matchId)
		local placeId = 13885123622
		local reservedServerCode, reservedPlaceID = TeleportService:ReserveServer(placeId)
		local _object = {
			type = "MATCH_FOUND",
			matchId = matchId,
			reservedServerCode = reservedServerCode,
		}
		local _left = "userIds"
		local _arg0 = function(player)
			return player.UserId
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#players)
		for _k, _v in ipairs(players) do
			_newValue[_k] = _arg0(_v, _k - 1, players)
		end
		-- ▲ ReadonlyArray.map ▲
		_object[_left] = _newValue
		local message = _object
		print("[MATCH MAKING HANDLE] Publishing message: ", message)
		MessagingService:PublishAsync("MatchMakingChannel", message)
		print("[MATCH MAKING HANDLE] Message published successfully")
		print("[MATCH MAKING HANDLE] matchId: ", matchId, " reservedServerCode: ", reservedServerCode)
	end
	function MatchMakingService:teleportPlayerToMatch(players, matchId)
		local reservedServerCode = self.matchToServerMap[matchId]
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		if reservedServerCode ~= "" and reservedServerCode then
			local placeId = 13885123622
			local _arg0 = function(player)
				return player ~= nil
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in ipairs(players) do
				if _arg0(_v, _k - 1, players) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			local validPlayers = _newValue
			if #validPlayers > 0 then
				local _arg0_1 = function(player)
					ExecuteMatchEvent:SendToPlayer(player, player)
				end
				for _k, _v in ipairs(validPlayers) do
					_arg0_1(_v, _k - 1, validPlayers)
				end
				TeleportService:TeleportToPrivateServer(placeId, reservedServerCode, validPlayers)
			else
				print("[MATCH MAKING] No valid players found for teleportation in match: ", matchId)
			end
		else
			print("[MATCH MAKING] No server code found for match: ", matchId)
		end
	end
	function MatchMakingService:startGame(player)
		local _queuedPlayers = self.queuedPlayers
		local _userId = player.UserId
		if _queuedPlayers[_userId] ~= nil then
			self:updateQueueState(QueueState.Searching)
			-- Starting the game simulation like countdown and finding a server can be implemented here.
		else
			warn("Player " .. (player.Name .. " tried to start the game but is not in the queue."))
		end
	end
	function MatchMakingService:addPlayerToQueue(player)
		local playerData = self:getPlayerData(player)
		local _queuedPlayers = self.queuedPlayers
		local _userId = player.UserId
		_queuedPlayers[_userId] = playerData
		-- Notify the client about the updated player count.
		local _fn = UpdatePlayerCountEvent
		-- ▼ ReadonlyMap.size ▼
		local _size = 0
		for _ in pairs(self.queuedPlayers) do
			_size += 1
		end
		-- ▲ ReadonlyMap.size ▲
		_fn:SendToAllPlayers(_size)
		self:syncMembers()
	end
	function MatchMakingService:removePlayerFromQueue(player)
		local _queuedPlayers = self.queuedPlayers
		local _userId = player.UserId
		_queuedPlayers[_userId] = nil
		-- Notify the client about the updated player count.
		local _fn = UpdatePlayerCountEvent
		-- ▼ ReadonlyMap.size ▼
		local _size = 0
		for _ in pairs(self.queuedPlayers) do
			_size += 1
		end
		-- ▲ ReadonlyMap.size ▲
		_fn:SendToAllPlayers(_size)
		self:syncMembers()
	end
	function MatchMakingService:getPlayerData(player)
		return {
			userId = player.UserId,
			username = player.Name,
		}
	end
	function MatchMakingService:updateQueueState(newState)
		for userId, playerData in pairs(self.queuedPlayers) do
			local player = Players:GetPlayerByUserId(userId)
			if player then
				QueueStateChangeEvent:SendToPlayer(player, newState)
			end
		end
	end
	function MatchMakingService:getQueuedPlayersAsPlayerArray()
		local playerArray = {}
		for userId, playerData in pairs(self.queuedPlayers) do
			local player = Players:GetPlayerByUserId(userId)
			if player then
				table.insert(playerArray, player)
			end
		end
		return playerArray
	end
	function MatchMakingService:syncMembers()
		UpdateQueueMembers:SendToAllPlayers(self:getQueuedPlayersAsPlayerArray())
	end
end
-- (Flamework) MatchMakingService metadata
Reflect.defineMetadata(MatchMakingService, "identifier", "lobby/src/systems/MatchMakingSystem/services/match-making-service@MatchMakingService")
Reflect.defineMetadata(MatchMakingService, "flamework:parameters", { "lobby/src/systems/MatchMakingSystem/services/session-service@PlayFabSessionService", "lobby/src/systems/MatchMakingSystem/services/party-service@PartyService" })
Reflect.defineMetadata(MatchMakingService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(MatchMakingService, "$:flamework@Service", Service, { {} })
return {
	default = MatchMakingService,
}
