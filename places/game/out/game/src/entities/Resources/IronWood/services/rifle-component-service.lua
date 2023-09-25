-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local PlayGunShakeEvent = Remotes.Server:Get("PlayGunShake")
local ToolPickupEvent = Remotes.Server:Get("ToolPickupEvent")
local ToolRemovedEvent = Remotes.Server:Get("ToolRemovedEvent")
local UpdateAmmoEvent = Remotes.Server:Get("UpdateAmmoEvent")
local activatedConnection
local rifleData = {
	ammo = 8,
	maxAmmo = 8,
}
local soundID = "7935556153"
local sound = "rbxassetid://" .. soundID
local soundInstance = Instance.new("Sound")
soundInstance.SoundId = sound
local RifleModelComponent
do
	local super = BaseComponent
	RifleModelComponent = setmetatable({}, {
		__tostring = function()
			return "RifleModelComponent"
		end,
		__index = super,
	})
	RifleModelComponent.__index = RifleModelComponent
	function RifleModelComponent.new(...)
		local self = setmetatable({}, RifleModelComponent)
		return self:constructor(...) or self
	end
	function RifleModelComponent:constructor()
		super.constructor(self)
		self.rifleData = {
			ammo = 8,
			maxAmmo = 8,
		}
		self.fireConnected = false
	end
	function RifleModelComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "Makeshift Rifle",
			ActionText = "Grab",
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
			HoldDuration = 1,
		})
	end
	function RifleModelComponent:grab(player)
		print("Rifle Tool Component Initiated")
		-- Add the tool to the player's backpack and destroy the instance in the Workspace.
		local _result = Workspace:FindFirstChild("ToolTest")
		if _result ~= nil then
			_result = _result:Clone()
		end
		local tool = _result
		tool.Parent = Workspace
		tool.Name = "HuntingRifle"
		tool.Parent = player.Character
		print("Tool Parent: ", tool.Parent)
		tool.Activated:Connect(function()
			print("Activated")
			self:fire(player)
			print("FIRE!")
		end)
		print("Tool created", tool)
		print(tool.Name)
		local _result_1 = tool.Parent
		if _result_1 ~= nil then
			_result_1 = _result_1:IsA("Model")
		end
		if _result_1 then
			if not player then
				error("Player not found!")
			end
			-- Check if the tool is already in the player's backpack.
			local playerBackpack = player:FindFirstChild("Backpack")
			if playerBackpack and not playerBackpack:FindFirstChild(tool.Name) then
				print("Tool is not in the player's backpack.")
				local _result_2 = playerBackpack
				if _result_2 ~= nil then
					_result_2 = _result_2:FindFirstChild(tool.Name)
				end
				print(_result_2)
				-- Only send the ToolPickupEvent if the tool is not already in the backpack.
				ToolPickupEvent:SendToPlayer(player, player, tool, self.rifleData)
				UpdateAmmoEvent:SendToPlayer(player, self.rifleData.ammo)
			else
				local _result_2 = playerBackpack
				if _result_2 ~= nil then
					_result_2 = _result_2:FindFirstChild(tool.Name)
				end
				print(_result_2)
				print("Tool is already in the player's backpack.")
			end
		else
			print("Tool does not have a parent or is not a model")
		end
		self.instance:Destroy()
	end
	function RifleModelComponent:onStart()
		print("Rifle Tool Component Initiated")
		local tool = self.instance
		print("Rifle Object Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to RifleComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			-- Grab IronWood
			self:grab(player)
		end))
	end
	function RifleModelComponent:fire(player)
		if self.rifleData.ammo > 0 then
			self.rifleData.ammo -= 1
			print("FIRE!")
			PlayGunShakeEvent:SendToPlayer(player)
			UpdateAmmoEvent:SendToPlayer(player, self.rifleData.ammo)
			print("Ammo: ", self.rifleData.ammo)
			soundInstance.Parent = player.Character
			soundInstance.Volume = 15
			soundInstance.MaxDistance = 10
			soundInstance:Play()
			local character = player.Character
			if not character then
				error("Character not found!")
			end
			local humanoid = character:WaitForChild("Humanoid")
			humanoid.BreakJointsOnDeath = false
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			local _cameraDirection = Workspace.CurrentCamera
			if _cameraDirection ~= nil then
				_cameraDirection = _cameraDirection.CFrame.LookVector
			end
			local cameraDirection = _cameraDirection
			if not cameraDirection then
				error("Camera direction not found!")
			end
			if t.instanceIsA("Part")(humanoidRootPart) then
				local bullet = Instance.new("Part")
				bullet.BrickColor = BrickColor.new("Black")
				bullet.Shape = Enum.PartType.Ball
				bullet.Size = Vector3.new(0.5, 0.5, 0.5)
				local lookVector = humanoidRootPart.CFrame.LookVector
				local _position = humanoidRootPart.Position
				local _arg0 = lookVector * 2
				bullet.Position = _position + _arg0
				local antiGravity = Instance.new("BodyForce")
				antiGravity.Force = Vector3.new(0, Workspace.Gravity * bullet:GetMass(), 0)
				antiGravity.Parent = bullet
				bullet.Parent = Workspace
				local bulletVelocity = Instance.new("BodyVelocity")
				bulletVelocity.Velocity = lookVector * 100
				bulletVelocity.Parent = bullet
				print("Bullet Velocity: ", bulletVelocity.Velocity)
				bullet.Touched:Connect(function()
					antiGravity:Destroy()
					print("Touched event triggered!")
					bullet:Destroy()
				end)
			else
				error("HumanoidRootPart not found!")
			end
		else
			print("No ammo left!")
		end
	end
end
-- (Flamework) RifleModelComponent metadata
Reflect.defineMetadata(RifleModelComponent, "identifier", "game/src/entities/Resources/IronWood/services/rifle-component-service@RifleModelComponent")
Reflect.defineMetadata(RifleModelComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(RifleModelComponent, "$c:init@Component", Component, { {
	tag = "RifleTrigger",
	instanceGuard = t.instanceIsA("Model"),
	attributes = {},
} })
return {
	RifleModelComponent = RifleModelComponent,
}
