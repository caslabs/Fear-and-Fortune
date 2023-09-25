-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local ExecuteMatchEvent = Remotes.Server:Get("ExecuteMatch")
local RequestToCancelMatchEvent = Remotes.Server:Get("RequestToCancelMatch")
local QueueState
do
	local _inverse = {}
	QueueState = setmetatable({}, {
		__index = _inverse,
	})
	QueueState.Idle = 0
	_inverse[0] = "Idle"
	QueueState.Searching = 1
	_inverse[1] = "Searching"
	QueueState.ServerFound = 2
	_inverse[2] = "ServerFound"
	QueueState.EmbarkFailed = 3
	_inverse[3] = "EmbarkFailed"
end
local EventFlowService
do
	EventFlowService = setmetatable({}, {
		__tostring = function()
			return "EventFlowService"
		end,
	})
	EventFlowService.__index = EventFlowService
	function EventFlowService.new(...)
		local self = setmetatable({}, EventFlowService)
		return self:constructor(...) or self
	end
	function EventFlowService:constructor(matchMakingService)
		self.matchMakingService = matchMakingService
	end
	function EventFlowService:onStart()
		Players.PlayerAdded:Connect(TS.async(function(player)
			player.Chatted:Connect(function(message)
				return self:onPlayerChat(player, message)
			end)
		end))
		print("EventFlowSystem Service Started")
	end
	function EventFlowService:onPlayerChat(player, message)
		print("onPlayerChat", player, message)
		-- TODO: DEV ONLY CAN START THE GAME
		if player.UserId == 11697914 then
			if message == "/start game" then
				-- TODO: Sync
				for userId, playerData in pairs(self.matchMakingService.queuedPlayers) do
					local player = Players:GetPlayerByUserId(userId)
					if player then
						ExecuteMatchEvent:SendToPlayer(player, player)
					end
				end
				-- ExecuteMatchEvent.SendToPlayers([player], player);
				-- this.matchMakingService.updateQueueState(QueueState.ServerFound); // Update queue state first
			elseif message == "/cancel game" then
				for userId, playerData in pairs(self.matchMakingService.queuedPlayers) do
					local player = Players:GetPlayerByUserId(userId)
					if player then
						RequestToCancelMatchEvent:SendToPlayer(player, player)
					end
				end
			end
		else
			print("Not a dev! Sorry!")
		end
	end
end
-- (Flamework) EventFlowService metadata
Reflect.defineMetadata(EventFlowService, "identifier", "lobby/src/systems/GameFlowSystem/services/event-flow-services@EventFlowService")
Reflect.defineMetadata(EventFlowService, "flamework:parameters", { "lobby/src/systems/MatchMakingSystem/services/match-making-service@MatchMakingService" })
Reflect.defineMetadata(EventFlowService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(EventFlowService, "$:flamework@Service", Service, { {
	loadOrder = 0,
} })
return {
	QueueState = QueueState,
	default = EventFlowService,
}
