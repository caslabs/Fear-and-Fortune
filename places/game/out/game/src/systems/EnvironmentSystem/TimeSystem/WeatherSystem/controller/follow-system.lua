-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Workspace = _services.Workspace
local Players = _services.Players
local ReplicatedStorage = _services.ReplicatedStorage
local RunService = _services.RunService
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local camera = Workspace.CurrentCamera
local FollowAgentSystemController
do
	FollowAgentSystemController = setmetatable({}, {
		__tostring = function()
			return "FollowAgentSystemController"
		end,
	})
	FollowAgentSystemController.__index = FollowAgentSystemController
	function FollowAgentSystemController.new(...)
		local self = setmetatable({}, FollowAgentSystemController)
		return self:constructor(...) or self
	end
	function FollowAgentSystemController:constructor(characterController)
		self.characterController = characterController
		self.isAgentVisible = false
		self.jumpscareTriggered = false
		self.isAgentFrozen = false
	end
	function FollowAgentSystemController:onInit()
	end
	function FollowAgentSystemController:onStart()
		print("FollowAgent Controller started")
		Signals.enableJumpScareEvent:Connect(function()
			self:toggleAgentVisibility(true)
			self.isAgentFrozen = true
			print("Jumpscare enabled")
		end)
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
			self:initializeFollowAgent()
		end
	end
	function FollowAgentSystemController:initializeFollowAgent()
		local followAgent = ReplicatedStorage:FindFirstChild("FollowAgent")
		if not followAgent then
			warn("FollowAgent not found")
			return nil
		end
		self.followAgentInstance = followAgent:Clone()
		self.followAgentInstance.Parent = Workspace
		RunService.RenderStepped:Connect(function()
			if not self.followAgentInstance then
				return nil
			end
			if not self.humanoid then
				return nil
			end
			local HumanoidRootPart = self.humanoid
			if HumanoidRootPart and self.isAgentVisible then
				self:setAgentTransparency()
				-- Only update the agent's position if it's not frozen
				if not self.isAgentFrozen then
					local lookVector = HumanoidRootPart.CFrame.LookVector * (-1)
					local offsetVector = Vector3.new(lookVector.X, 0, lookVector.Z) * 30
					local agentPosition = HumanoidRootPart.Position + offsetVector
					if self.followAgentInstance.PrimaryPart then
						self.followAgentInstance:SetPrimaryPartCFrame(CFrame.new(agentPosition))
					else
						warn("FollowAgent does not have a PrimaryPart defined")
					end
				end
				self:performJumpscare()
			end
		end)
		print("FollowAgent initialized")
	end
	function FollowAgentSystemController:setAgentTransparency()
		if not self.followAgentInstance then
			return nil
		end
		for _, child in ipairs(self.followAgentInstance:GetChildren()) do
			if child:IsA("BasePart") then
				child.CanCollide = false
				child.Transparency = if self.isAgentVisible or self.isAgentFrozen then 0 else 1
			end
		end
	end
	function FollowAgentSystemController:toggleAgentVisibility(visible)
		self.isAgentVisible = visible
		self.jumpscareTriggered = false
		self:setAgentTransparency()
		if visible then
			self:performJumpscare()
		end
	end
	function FollowAgentSystemController:performJumpscare()
		if self.humanoid and (self.followAgentInstance and (not self.jumpscareTriggered and self.isAgentFrozen)) then
			-- Get the player's look direction from the camera
			local lookVector = camera.CFrame.LookVector
			-- Get the direction from the player to the agent
			local _position = self.followAgentInstance.PrimaryPart.Position
			local _position_1 = self.humanoid.Position
			local agentDirection = (_position - _position_1).Unit
			-- Calculate the cosine of the angle between the look vector and the agent direction
			local cosAngle = lookVector:Dot(agentDirection)
			-- Check if the player is looking at the agent
			-- Cosine is close to 1 for small angles (allowing for a slight deviation due to the perspective)
			if cosAngle > 0.95 then
				print("Jumpscare!")
				self.jumpscareTriggered = true
			end
		end
	end
	function FollowAgentSystemController:setCharacter(character)
		if character then
			self.humanoid = character.HumanoidRootPart
			if not self.humanoid then
				print("Humanoid not found")
				return nil
			end
		else
			self.humanoid = nil
			self.followAgentInstance.Parent = nil
		end
	end
end
-- (Flamework) FollowAgentSystemController metadata
Reflect.defineMetadata(FollowAgentSystemController, "identifier", "game/src/systems/EnvironmentSystem/TimeSystem/WeatherSystem/controller/follow-system@FollowAgentSystemController")
Reflect.defineMetadata(FollowAgentSystemController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/CharacterMechanic/controller/character-controller@CharacterMechanic" })
Reflect.defineMetadata(FollowAgentSystemController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(FollowAgentSystemController, "$:flamework@Controller", Controller, { {
	loadOrder = 3,
} })
return {
	default = FollowAgentSystemController,
}
