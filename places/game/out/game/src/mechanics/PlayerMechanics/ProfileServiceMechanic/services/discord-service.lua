-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local _discord_webhook = TS.import(script, TS.getModule(script, "@rbxts", "discord-webhook").out)
local DiscordWebhook = _discord_webhook.DiscordWebhook
local DiscordEmbed = _discord_webhook.DiscordEmbed
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local webhookUrl = "https://hooks.hyra.io/api/webhooks/872426946057867275/gawsTvbbVyCwMXqtVU_b5bzc0QuIcvVSRmLFtMjFSaA_UJotl9J5waEfMSMaLiYWZnzD"
local webhook = DiscordWebhook.new(webhookUrl)
-- Mapping of game IDs to Discord messages
local gameMessages = {
	[13123] = "Message for game ID 13123",
	[45456] = "Message for game ID 45456",
}
local DiscordService
do
	DiscordService = setmetatable({}, {
		__tostring = function()
			return "DiscordService"
		end,
	})
	DiscordService.__index = DiscordService
	function DiscordService.new(...)
		local self = setmetatable({}, DiscordService)
		return self:constructor(...) or self
	end
	function DiscordService:constructor()
	end
	function DiscordService:onStart()
		print("DiscordService Service Started")
		Players.PlayerAdded:Connect(function(player)
			return self:handlePlayerEvent(player, "joined")
		end)
		Players.PlayerRemoving:Connect(function(player)
			return self:handlePlayerEvent(player, "left")
		end)
	end
	function DiscordService:handlePlayerEvent(player, eventType)
		local currentGameId = game.PlaceId
		local discordMessage = gameMessages[currentGameId]
		-- Ensure there's a message to send for this game ID
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		if not (discordMessage ~= "" and discordMessage) then
			print("No Discord message found for game ID: " .. tostring(currentGameId))
			return nil
		end
		local title = "Player " .. eventType
		local description = player.Name .. (" has " .. (eventType .. (" the game with game ID: " .. tostring(currentGameId))))
		local embed = DiscordEmbed.new():setTitle(title):setDescription(description):addField("Investigate", "https://www.roblox.com/games/" .. tostring(currentGameId), true):setColor(Color3.new(46, 204, 113))
		print(webhook:send(embed))
	end
end
-- (Flamework) DiscordService metadata
Reflect.defineMetadata(DiscordService, "identifier", "game/src/mechanics/PlayerMechanics/ProfileServiceMechanic/services/discord-service@DiscordService")
Reflect.defineMetadata(DiscordService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(DiscordService, "$:flamework@Service", Service, { {} })
return {
	default = DiscordService,
}
