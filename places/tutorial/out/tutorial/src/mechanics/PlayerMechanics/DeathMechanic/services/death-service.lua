-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local Workspace = _services.Workspace
local RunService = _services.RunService
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local baseplate = Workspace:WaitForChild("TutorialNode"):WaitForChild("Baseplate")
local deathRules = { {
	condition = function(lastPosition)
		return lastPosition.Y < baseplate.Position.Y
	end,
	message = "You fell to your death",
	hint = "Try not to fall next time...",
}, {
	condition = function(lastPosition, player)
		return player:GetAttribute("JustReset")
	end,
	message = "Another soul claimed...",
	hint = "You took the easy way out",
}, {
	condition = function(lastPosition, player)
		return player:GetAttribute("LastDamagedByAI")
	end,
	message = "You died to the Eyeless",
	hint = "Try not to look at it again... ",
} }
local PlayerDeathEvent = Remotes.Server:Get("PlayerDeathEvent")
local DeathMechanic
do
	DeathMechanic = setmetatable({}, {
		__tostring = function()
			return "DeathMechanic"
		end,
	})
	DeathMechanic.__index = DeathMechanic
	function DeathMechanic.new(...)
		local self = setmetatable({}, DeathMechanic)
		return self:constructor(...) or self
	end
	function DeathMechanic:constructor()
	end
	function DeathMechanic:onStart()
		print("DeathMechanic Service started")
		Players.PlayerAdded:Connect(function(player)
			player:SetAttribute("JustReset", false)
			player.CharacterAdded:Connect(function(character)
				local humanoid = character:WaitForChild("Humanoid")
				-- Record the last known health of the character.
				local lastHealth = humanoid.Health
				-- Record the last known position of the character every second.
				local lastPosition
				local recording = RunService.Heartbeat:Connect(function()
					if character.PrimaryPart then
						lastPosition = character.PrimaryPart.Position
						lastHealth = humanoid.Health
					end
				end)
				humanoid.Died:Connect(function()
					recording:Disconnect()
					-- If the player's health dropped rapidly (e.g., within a single frame), they probably reset their character.
					if lastHealth == humanoid.MaxHealth then
						player:SetAttribute("JustReset", true)
					end
					for _, rule in ipairs(deathRules) do
						if rule.condition(lastPosition, player) then
							print(player.Name .. (" " .. (rule.message .. ".")))
							print("hint: " .. rule.hint)
							-- Ping to Client to show the death screen
							PlayerDeathEvent:SendToPlayer(player, player, rule.message, rule.hint)
							break
						end
					end
					player:SetAttribute("JustReset", false)
					player:SetAttribute("LastDamagedByAI", false)
				end)
			end)
		end)
	end
end
-- (Flamework) DeathMechanic metadata
Reflect.defineMetadata(DeathMechanic, "identifier", "tutorial/src/mechanics/PlayerMechanics/DeathMechanic/services/death-service@DeathMechanic")
Reflect.defineMetadata(DeathMechanic, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(DeathMechanic, "$:flamework@Service", Service, { {} })
return {
	default = DeathMechanic,
}
