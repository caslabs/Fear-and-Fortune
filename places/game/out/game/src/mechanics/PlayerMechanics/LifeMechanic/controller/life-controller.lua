-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local ToggleRespawn = Remotes.Client:Get("ToggleRespawn")
local LifeMechanic
do
	LifeMechanic = setmetatable({}, {
		__tostring = function()
			return "LifeMechanic"
		end,
	})
	LifeMechanic.__index = LifeMechanic
	function LifeMechanic.new(...)
		local self = setmetatable({}, LifeMechanic)
		return self:constructor(...) or self
	end
	function LifeMechanic:constructor(characterController, hudController, musicSystemController)
		self.characterController = characterController
		self.hudController = hudController
		self.musicSystemController = musicSystemController
		self.playerLives = 1
		self.livesChanged = Signal.new()
		self.isDying = false
	end
	function LifeMechanic:onInit()
	end
	function LifeMechanic:onStart()
		self.characterController.onCharacterAdded:Connect(function()
			local character = self.characterController:getCurrentCharacter()
			local _humanoid = character
			if _humanoid ~= nil then
				_humanoid = _humanoid.Humanoid
			end
			local humanoid = _humanoid
			if not humanoid then
				return nil
			end
			self.isDying = false
			self:monitorHealth(humanoid)
		end)
		self.characterController.onCharacterRemoved:Connect(function()
			if self.playerLives <= 0 then
				self.playerLives = 1
			end
		end)
		if self.characterController:getCurrentCharacter() then
			local _humanoid = self.characterController:getCurrentCharacter()
			if _humanoid ~= nil then
				_humanoid = _humanoid.Humanoid
			end
			local humanoid = _humanoid
			if humanoid then
				self:monitorHealth(humanoid)
			end
		end
	end
	function LifeMechanic:monitorHealth(humanoid)
		humanoid.HealthChanged:Connect(function(newHealth)
			if newHealth <= 0 and not self.isDying then
				self.isDying = true
				self.playerLives -= 1
				print("Player has " .. (tostring(self.playerLives) .. " lives left."))
				if self.playerLives <= 0 then
					print("Player has lost all lives.")
					self.livesChanged:Fire(self.playerLives)
					local respawnEnabled = self.playerLives > 0
					ToggleRespawn:SendToServer(respawnEnabled)
				end
			end
		end)
	end
end
-- (Flamework) LifeMechanic metadata
Reflect.defineMetadata(LifeMechanic, "identifier", "game/src/mechanics/PlayerMechanics/LifeMechanic/controller/life-controller@LifeMechanic")
Reflect.defineMetadata(LifeMechanic, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic", "game/src/mechanics/PlayerMechanics/UIMechanic/controller/hud-controller@HUDController", "game/src/systems/AudioSystem/MusicSystem/controller/music-controller@MusicSystemController" })
Reflect.defineMetadata(LifeMechanic, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(LifeMechanic, "$:flamework@Controller", Controller, { {} })
return {
	default = LifeMechanic,
}
