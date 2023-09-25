-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local TextChatService = _services.TextChatService
local Players = _services.Players
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local roles = {
	["The Boys"] = { 11697914, 710641889, 682379885, 1024253883, 661351256, 1032860613, 1683893477 },
	["Senior Beta Tester"] = { 1805616465, 3530383896, 1341618742 },
}
local TagMechanicController
do
	TagMechanicController = setmetatable({}, {
		__tostring = function()
			return "TagMechanicController"
		end,
	})
	TagMechanicController.__index = TagMechanicController
	function TagMechanicController.new(...)
		local self = setmetatable({}, TagMechanicController)
		return self:constructor(...) or self
	end
	function TagMechanicController:constructor()
	end
	function TagMechanicController:onInit()
	end
	function TagMechanicController:onStart()
		-- Mock-up, replace with actual TextChatService API when available
		TextChatService.OnIncomingMessage = function(message)
			return self:onIncomingMessage(message)
		end
		print("TagMechanicController started")
	end
	function TagMechanicController:onIncomingMessage(message)
		local properties = Instance.new("TextChatMessageProperties")
		if message.TextSource then
			local player = Players:GetPlayerByUserId(message.TextSource.UserId)
			if player then
				-- Default role
				local roleName = "Beta Tester"
				properties.PrefixText = "[" .. (roleName .. ("] " .. message.PrefixText))
				-- Check for specific roles
				for role, userIds in pairs(roles) do
					local _userId = player.UserId
					if table.find(userIds, _userId) ~= nil then
						roleName = role
						properties.PrefixText = "[" .. (roleName .. ("] " .. message.PrefixText))
						break
					end
				end
			end
		end
		return properties
	end
end
-- (Flamework) TagMechanicController metadata
Reflect.defineMetadata(TagMechanicController, "identifier", "lobby/src/mechanics/PlayerMechanics/CharacterMechanic/controller/tag-controller@TagMechanicController")
Reflect.defineMetadata(TagMechanicController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(TagMechanicController, "$:flamework@Controller", Controller, { {
	loadOrder = 99999,
} })
return {
	TagMechanicController = TagMechanicController,
}
