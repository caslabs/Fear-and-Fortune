-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local TweenService = _services.TweenService
local Workspace = _services.Workspace
local PlayerStates = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "AISystem", "AIManager", "character-states").default
local camera = Workspace.CurrentCamera
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
-- PlayerStateProperties.ts
local PlayerStateController
do
	PlayerStateController = setmetatable({}, {
		__tostring = function()
			return "PlayerStateController"
		end,
	})
	PlayerStateController.__index = PlayerStateController
	function PlayerStateController.new(...)
		local self = setmetatable({}, PlayerStateController)
		return self:constructor(...) or self
	end
	function PlayerStateController:constructor(characterController)
		self.characterController = characterController
		self.currentState = PlayerStates.Normal
		-- Initialize the state properties dictionary
		self.stateProperties = {}
		local _stateProperties = self.stateProperties
		local _normal = PlayerStates.Normal
		_stateProperties[_normal] = {
			walkSpeed = 16,
			fov = 70,
		}
		local _stateProperties_1 = self.stateProperties
		local _sprinting = PlayerStates.Sprinting
		_stateProperties_1[_sprinting] = {
			walkSpeed = 16 * 1.45,
			fov = 85,
		}
		local _stateProperties_2 = self.stateProperties
		local _chasing = PlayerStates.Chasing
		_stateProperties_2[_chasing] = {
			walkSpeed = 16 * 2,
			fov = 90,
		}
		local _stateProperties_3 = self.stateProperties
		local _crouching = PlayerStates.Crouching
		_stateProperties_3[_crouching] = {
			walkSpeed = 8,
			fov = 70,
		}
	end
	function PlayerStateController:onInit()
	end
	function PlayerStateController:onStart()
	end
	function PlayerStateController:setState(newState)
		local character = self.characterController:getCurrentCharacter()
		local _result = character
		if _result ~= nil then
			_result = _result:FindFirstChild("Humanoid")
		end
		local humanoid = _result
		if not humanoid then
			print("No humanoid found")
			return nil
		end
		local properties = self:getProperties(newState)
		if not properties then
			print("No properties found for state: " .. tostring(newState))
			return nil
		end
		humanoid.WalkSpeed = properties.walkSpeed
		self:updateFov(properties.fov)
		self.currentState = newState
		print("Set state to " .. (tostring(newState) .. (", walkSpeed: " .. (tostring(properties.walkSpeed) .. (", fov: " .. tostring(properties.fov))))))
	end
	function PlayerStateController:getProperties(state)
		return self.stateProperties[state]
	end
	function PlayerStateController:updateFov(newFov)
		TweenService:Create(camera, tweenInfo, {
			FieldOfView = newFov,
		}):Play()
	end
end
-- (Flamework) PlayerStateController metadata
Reflect.defineMetadata(PlayerStateController, "identifier", "game/src/mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/character-states-controller@PlayerStateController")
Reflect.defineMetadata(PlayerStateController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(PlayerStateController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(PlayerStateController, "$:flamework@Controller", Controller, { {} })
return {
	default = PlayerStateController,
}
