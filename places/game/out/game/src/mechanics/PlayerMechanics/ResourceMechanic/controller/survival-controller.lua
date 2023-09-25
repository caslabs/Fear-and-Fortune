-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local PlayerDeathSurvivalEvent = Remotes.Client:Get("PlayerDeathSurvival")
local AddThirstEvent = Remotes.Client:Get("AddThirst")
local AddExposureEvent = Remotes.Client:Get("AddExposure")
local SurvivalController
do
	SurvivalController = setmetatable({}, {
		__tostring = function()
			return "SurvivalController"
		end,
	})
	SurvivalController.__index = SurvivalController
	function SurvivalController.new(...)
		local self = setmetatable({}, SurvivalController)
		return self:constructor(...) or self
	end
	function SurvivalController:constructor(characterController)
		self.characterController = characterController
		self.maxHunger = 100
		self.hunger = self.maxHunger
		self.maxThirst = 100
		self.thirst = self.maxThirst
		self.maxExposure = 100
		self.exposure = self.maxExposure
		self.maxValues = {
			hunger = self.maxHunger,
			thirst = self.maxThirst,
			exposure = self.maxExposure,
		}
		self.startTimes = {
			hunger = tick(),
			thirst = tick(),
			exposure = tick(),
		}
		self.isNearHeatedSource = false
		self.fullDepletionTime = {
			hunger = 1800,
			thirst = 1200,
			exposure = 300,
		}
		self.harmInterval = 5
		self.harmAmount = 10
	end
	function SurvivalController:onInit()
	end
	function SurvivalController:onStart()
		task.spawn(function()
			return self:depleteStat("hunger")
		end)
		task.spawn(function()
			return self:depleteStat("thirst")
		end)
		task.spawn(function()
			return self:depleteStat("exposure")
		end)
		AddThirstEvent:Connect(function(amount)
			self.thirst += amount
			if self.thirst > self.maxThirst then
				self.thirst = self.maxThirst
			end
			-- Reset the start time for thirst
			self.startTimes.thirst = tick()
			Signals.ThirstUpdate:Fire(Players.LocalPlayer, self.thirst)
		end)
		AddExposureEvent:Connect(function(isHeated)
			self.isNearHeatedSource = isHeated
			-- Update the start time for exposure
			self.startTimes.exposure = tick()
		end)
	end
	SurvivalController.depleteStat = TS.async(function(self, stat)
		local character = self.characterController:getCurrentCharacter()
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChildOfClass("Humanoid")
		end
		local humanoid = _humanoid
		while humanoid and humanoid.Health > 0 do
			local elapsedTime = tick() - self.startTimes[stat]
			if stat == "exposure" and self.isNearHeatedSource then
				self.exposure += (0.1 / self.fullDepletionTime[stat]) * self.maxExposure
				if self.exposure > self.maxExposure then
					self.exposure = self.maxExposure
				end
			else
				self[stat] = self.maxValues[stat] - (elapsedTime / self.fullDepletionTime[stat]) * self.maxValues[stat]
				if self[stat] < 0 then
					self[stat] = 0
				end
			end
			if self[stat] <= 0 then
				humanoid.Health -= self.harmAmount
				if humanoid.Health <= 0 then
					print(Players.LocalPlayer.Name .. (" died from " .. (stat .. ".")))
					PlayerDeathSurvivalEvent:SendToServer()
					break
				end
			end
			if stat == "hunger" then
				Signals.HungerUpdate:Fire(Players.LocalPlayer, self.hunger)
			elseif stat == "thirst" then
				Signals.ThirstUpdate:Fire(Players.LocalPlayer, self.thirst)
			elseif stat == "exposure" then
				Signals.ExposureUpdate:Fire(Players.LocalPlayer, self.exposure)
			end
			TS.await(TS.Promise.delay(0.1))
		end
	end)
	SurvivalController.harmPlayer = TS.async(function(self)
		local character = self.characterController:getCurrentCharacter()
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChildOfClass("Humanoid")
		end
		local humanoid = _humanoid
		while humanoid and humanoid.Health > 0 do
			humanoid.Health -= self.harmAmount
			if humanoid.Health <= 0 then
				print(Players.LocalPlayer.Name .. " died from thirst, hunger, or exposure.")
				PlayerDeathSurvivalEvent:SendToServer()
				break
			end
			TS.await(TS.Promise.delay(self.harmInterval))
		end
	end)
end
-- (Flamework) SurvivalController metadata
Reflect.defineMetadata(SurvivalController, "identifier", "game/src/mechanics/PlayerMechanics/ResourceMechanic/controller/survival-controller@SurvivalController")
Reflect.defineMetadata(SurvivalController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(SurvivalController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(SurvivalController, "$:flamework@Controller", Controller, { {} })
return {
	default = SurvivalController,
}
