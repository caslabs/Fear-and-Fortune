-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signal"))
local yieldForR15CharacterDescendants = TS.import(script, TS.getModule(script, "@rbxts", "yield-for-character")).default
local player = Players.LocalPlayer
local CharacterMechanic
do
	CharacterMechanic = setmetatable({}, {
		__tostring = function()
			return "CharacterMechanic"
		end,
	})
	CharacterMechanic.__index = CharacterMechanic
	function CharacterMechanic.new(...)
		local self = setmetatable({}, CharacterMechanic)
		return self:constructor(...) or self
	end
	function CharacterMechanic:constructor()
		self.onCharacterAdded = Signal.new()
		self.onCharacterRemoved = Signal.new()
	end
	function CharacterMechanic:onStart()
		print("CharacterMechanic started")
		if player.Character then
			self:onCharacterAddedCallback(player.Character)
		end
		player.CharacterAdded:Connect(function(c)
			return self:onCharacterAddedCallback(c)
		end)
		player.CharacterRemoving:Connect(function(c)
			return self:onCharacterRemoving(c)
		end)
	end
	function CharacterMechanic:getCurrentCharacter()
		return self.currentCharacter
	end
	CharacterMechanic.onCharacterAddedCallback = TS.async(function(self, model)
		local character = TS.await(yieldForR15CharacterDescendants(model))
		self.currentCharacter = character
		self.onCharacterAdded:Fire(character)
	end)
	function CharacterMechanic:onCharacterRemoving(model)
		if self.currentCharacter ~= nil and model == self.currentCharacter then
			self.currentCharacter = nil
			if not model.Parent then
				self.onCharacterRemoved:Fire(model)
				print("Character removed")
			end
		end
	end
end
-- (Flamework) CharacterMechanic metadata
Reflect.defineMetadata(CharacterMechanic, "identifier", "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic")
Reflect.defineMetadata(CharacterMechanic, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(CharacterMechanic, "$:flamework@Controller", Controller, { {
	loadOrder = 0,
} })
return {
	default = CharacterMechanic,
}
