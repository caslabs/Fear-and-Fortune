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
			local embed = DiscordEmbed.new():setTitle("Player Joined"):setDescription(player.Name .. " has joined the game"):addField("Investigate", "https://www.roblox.com/games/13733616492/PLAYTEST-The-Yeti-of-Mount-Everest", true):setColor(Color3.new(46, 204, 113))
			print(webhook:send(embed))
		end)
		Players.PlayerRemoving:Connect(function(player)
			local embed = DiscordEmbed.new():setTitle("Player Left"):setDescription(player.Name .. " has left the game"):addField("Investigate", "https://www.roblox.com/games/13733616492/PLAYTEST-The-Yeti-of-Mount-Everest", true):setColor(Color3.new(46, 204, 113))
			print(webhook:send(embed))
		end)
	end
end
-- (Flamework) DiscordService metadata
Reflect.defineMetadata(DiscordService, "identifier", "tutorial/src/systems/TaskSystem/services/discord-service@DiscordService")
Reflect.defineMetadata(DiscordService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(DiscordService, "$:flamework@Service", Service, { {} })
return {
	default = DiscordService,
}
