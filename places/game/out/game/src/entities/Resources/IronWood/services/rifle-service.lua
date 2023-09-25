-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local Workspace = _services.Workspace
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
-- Define ToolData for the Rifle
-- TODO: Prototype
local rifleData = {
	ammo = 8,
	maxAmmo = 8,
}
local PlayGunShakeEvent = Remotes.Server:Get("PlayGunShake")
local ToolPickupEvent = Remotes.Server:Get("ToolPickupEvent")
local ToolRemovedEvent = Remotes.Server:Get("ToolRemovedEvent")
local UpdateAmmoEvent = Remotes.Server:Get("UpdateAmmoEvent")
-- TODO: is this good? Play 3D Spatial Sound
-- Broken, only plays once and then never again...
local soundID = "7935556153"
local sound = "rbxassetid://" .. soundID
local soundInstance = Instance.new("Sound")
soundInstance.SoundId = sound
local RifleComponent
do
	local super = BaseComponent
	RifleComponent = setmetatable({}, {
		__tostring = function()
			return "RifleComponent"
		end,
		__index = super,
	})
	RifleComponent.__index = RifleComponent
	function RifleComponent.new(...)
		local self = setmetatable({}, RifleComponent)
		return self:constructor(...) or self
	end
	function RifleComponent:constructor()
		super.constructor(self)
		self.rifleData = {
			ammo = 8,
			maxAmmo = 8,
		}
		self.fireConnected = false
	end
	function RifleComponent:onStart()
		print("Rifle Tool Component Initiated")
		local tool = self.instance
		tool:GetPropertyChangedSignal("Parent"):Connect(function()
			-- If the tool is picked up by a player.
			local _result = tool.Parent
			if _result ~= nil then
				_result = _result:IsA("Model")
			end
			local _condition = _result
			if _condition then
				_condition = Players:GetPlayerFromCharacter(tool.Parent)
			end
			if _condition then
				local player = Players:GetPlayerFromCharacter(tool.Parent)
				if not player then
					error("Player not found!")
				end
				-- Check if the tool is already in the player's backpack.
				local playerBackpack = player:FindFirstChild("Backpack")
				if playerBackpack and not playerBackpack:FindFirstChild(tool.Name) then
					print("Tool is not in the player's backpack.")
					local _result_1 = playerBackpack
					if _result_1 ~= nil then
						_result_1 = _result_1:FindFirstChild(tool.Name)
					end
					print(_result_1)
					-- Only send the ToolPickupEvent if the tool is not already in the backpack.
					ToolPickupEvent:SendToPlayer(player, player, tool, self.rifleData)
					UpdateAmmoEvent:SendToPlayer(player, self.rifleData.ammo)
				else
					local _result_1 = playerBackpack
					if _result_1 ~= nil then
						_result_1 = _result_1:FindFirstChild(tool.Name)
					end
					print(_result_1)
					print("Tool is already in the player's backpack.")
				end
				-- Bind to mouse button 1 for PC users
				if not self.fireConnected then
					tool.Activated:Connect(function()
						self:fire(player)
					end)
					self.fireConnected = true
				end
			end
		end)
	end
	function RifleComponent:fire(player)
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
	function RifleComponent:attachTouchFunction(model)
		print("Rifle Active Initiated")
		local primaryPart = model.PrimaryPart
		if primaryPart then
			primaryPart.Touched:Connect(function(part)
				print("Touched event triggered!")
				local _result = part.Parent
				if _result ~= nil then
					_result = _result:FindFirstChild("Humanoid")
				end
				if _result then
					local humanoid = part.Parent:FindFirstChild("Humanoid")
					humanoid:TakeDamage(humanoid.MaxHealth)
				end
			end)
		end
	end
end
-- (Flamework) RifleComponent metadata
Reflect.defineMetadata(RifleComponent, "identifier", "game/src/entities/Resources/IronWood/services/rifle-service@RifleComponent")
Reflect.defineMetadata(RifleComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(RifleComponent, "$c:init@Component", Component, { {
	tag = "RifleTool",
	instanceGuard = t.instanceIsA("Tool"),
	attributes = {},
} })
return {
	RifleComponent = RifleComponent,
}
