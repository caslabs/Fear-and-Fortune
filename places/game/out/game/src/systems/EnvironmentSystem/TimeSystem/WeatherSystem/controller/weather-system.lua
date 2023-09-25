-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Workspace = _services.Workspace
local Players = _services.Players
local ReplicatedStorage = _services.ReplicatedStorage
local RunService = _services.RunService
local WeatherSystemController
do
	WeatherSystemController = setmetatable({}, {
		__tostring = function()
			return "WeatherSystemController"
		end,
	})
	WeatherSystemController.__index = WeatherSystemController
	function WeatherSystemController.new(...)
		local self = setmetatable({}, WeatherSystemController)
		return self:constructor(...) or self
	end
	function WeatherSystemController:constructor(characterController)
		self.characterController = characterController
	end
	function WeatherSystemController:onInit()
	end
	function WeatherSystemController:onStart()
		print("WeatherSystem Controller started")
		local player = Players.LocalPlayer
		if player then
			-- Deploy Character Controller
			wait(5)
			self:setCharacter(self.characterController:getCurrentCharacter())
			self.characterController.onCharacterAdded:Connect(function(character)
				return self:setCharacter(character)
			end)
			self.characterController.onCharacterRemoved:Connect(function()
				return self:setCharacter(nil)
			end)
			self:initializeWeather()
		end
	end
	function WeatherSystemController:initializeWeather()
		local weather = ReplicatedStorage:FindFirstChild("Weather")
		if not weather then
			warn("Weather not found")
			return nil
		end
		local weatherInstance = weather:Clone()
		-- Access the ParticleEmitter
		local basePart = weatherInstance:FindFirstChild("Weather")
		local snowEmitter = basePart:FindFirstChildOfClass("ParticleEmitter")
		-- Check if we found the emitter
		if not snowEmitter then
			warn("ParticleEmitter not found")
			return nil
		end
		-- Set properties for the ParticleEmitter
		snowEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		snowEmitter.Size = NumberSequence.new(0.5, 2)
		snowEmitter.Lifetime = NumberRange.new(5, 50)
		snowEmitter.Rate = 500
		snowEmitter.Speed = NumberRange.new(15, 300)
		snowEmitter.Rotation = NumberRange.new(0, 360)
		snowEmitter.Transparency = NumberSequence.new(0, 0.5)
		snowEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) })
		-- ...
		snowEmitter.LightEmission = 0.5
		snowEmitter.LightInfluence = 0
		snowEmitter.SpreadAngle = Vector2.new(-180, 180)
		print("ParticleEmitter properties set")
		-- Keeps the weather following the player
		RunService.RenderStepped:Connect(function()
			if not self.humanoid then
				return nil
			end
			local HumanoidRootPart = self.humanoid
			if HumanoidRootPart then
				if weatherInstance.Parent ~= Workspace then
					weatherInstance = weather:Clone()
					weatherInstance.Parent = Workspace
				end
				weatherInstance:SetPrimaryPartCFrame(CFrame.new(Vector3.new(HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y + 88.204, HumanoidRootPart.Position.Z)))
			else
				weatherInstance.Parent = nil
			end
		end)
		print("Weather initialized")
	end
	function WeatherSystemController:setCharacter(character)
		if character then
			self.humanoid = character.HumanoidRootPart
			if not self.humanoid then
				print("Humanoid not found")
				return nil
			end
		else
			self.humanoid = nil
		end
	end
end
-- (Flamework) WeatherSystemController metadata
Reflect.defineMetadata(WeatherSystemController, "identifier", "game/src/systems/EnvironmentSystem/TimeSystem/WeatherSystem/controller/weather-system@WeatherSystemController")
Reflect.defineMetadata(WeatherSystemController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(WeatherSystemController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(WeatherSystemController, "$:flamework@Controller", Controller, { {
	loadOrder = 3,
} })
return {
	default = WeatherSystemController,
}
