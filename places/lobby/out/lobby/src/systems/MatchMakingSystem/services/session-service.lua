-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local _playfab = TS.import(script, TS.getModule(script, "@rbxts", "playfab").out)
local Settings = _playfab.Settings
local PlayFabClient = _playfab.PlayFabClient
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local PlayFabSessionService
do
	PlayFabSessionService = setmetatable({}, {
		__tostring = function()
			return "PlayFabSessionService"
		end,
	})
	PlayFabSessionService.__index = PlayFabSessionService
	function PlayFabSessionService.new(...)
		local self = setmetatable({}, PlayFabSessionService)
		return self:constructor(...) or self
	end
	function PlayFabSessionService:constructor()
		self.playerSessions = {}
	end
	function PlayFabSessionService:onStart()
		Players.PlayerAdded:Connect(function(player)
			return self:handlePlayerJoin(player)
		end)
		Players.PlayerRemoving:Connect(function(player)
			wait(5)
			self.playerSessions[player] = nil
		end)
	end
	function PlayFabSessionService:getPlayerSession(player)
		local session = self.playerSessions[player]
		if not session then
			error("Player doesn't have a session yet!")
		end
		return session
	end
	function PlayFabSessionService:handlePlayerJoin(player)
		Settings.titleId = "D1B10"
		local _exp = PlayFabClient:LoginWithCustomID({
			CustomId = tostring(player.UserId),
			CreateAccount = true,
		})
		local _arg0 = function(response)
			local playfabId = response.PlayFabId
			local sessionTicket = response.SessionTicket
			local entityId = response.EntityToken.Entity.Id
			local entityType = response.EntityToken.Entity.Type
			local entityToken = response.EntityToken.EntityToken
			local _playerSessions = self.playerSessions
			local _arg1 = {
				playFabId = playfabId,
				sessionTicket = sessionTicket,
				entityToken = entityToken,
				entityKey = {
					Id = entityId,
					Type = entityType,
				},
			}
			_playerSessions[player] = _arg1
			print("----------------------\nPlayer " .. player.Name .. " authenticated with PlayFab:" .. "\n    PlayFab ID: " .. playfabId .. "\n    Entity ID: " .. entityId .. "\n    Entity Type: " .. entityType .. "\n    Session Ticket: " .. sessionTicket .. "\n    Entity Token: " .. entityToken .. "\n----------------------" .. "\n")
		end
		_exp:andThen(_arg0):catch(function()
			warn("Something went wrong!")
		end)
	end
end
-- (Flamework) PlayFabSessionService metadata
Reflect.defineMetadata(PlayFabSessionService, "identifier", "lobby/src/systems/MatchMakingSystem/services/session-service@PlayFabSessionService")
Reflect.defineMetadata(PlayFabSessionService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(PlayFabSessionService, "$:flamework@Service", Service, { {} })
return {
	default = PlayFabSessionService,
}
