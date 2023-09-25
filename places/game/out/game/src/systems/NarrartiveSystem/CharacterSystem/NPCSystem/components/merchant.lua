-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local _shop_manager = TS.import(script, script.Parent.Parent.Parent, "ui", "Pages", "Shop", "shop-manager")
local getIsCurrentlyOpen = _shop_manager.getIsCurrentlyOpen
local setIsCurrentlyOpen = _shop_manager.setIsCurrentlyOpen
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local NPCComponent
do
	local super = BaseComponent
	NPCComponent = setmetatable({}, {
		__tostring = function()
			return "NPCComponent"
		end,
		__index = super,
	})
	NPCComponent.__index = NPCComponent
	function NPCComponent.new(...)
		local self = setmetatable({}, NPCComponent)
		return self:constructor(...) or self
	end
	function NPCComponent:constructor(...)
		super.constructor(self, ...)
	end
	function NPCComponent:onStart()
		local agentModel = self.instance
		local humanoidRootPart = agentModel:FindFirstChild("Body")
		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.Parent = humanoidRootPart
		local distanceToLookAtPlayer = 99999999
		print("NPC-1 Component Initiated")
		print("NPC-1 Component Initiated on " .. (self.instance.Name .. (" (" .. (self.instance.ClassName .. ")"))))
		if not t.instanceIsA("BasePart")(humanoidRootPart) then
			print("Unable to find HumanoidRootPart in the NPC-1 model")
			return nil
		end
		print("Found part:", humanoidRootPart.Name)
		local prompt = self:attachProximityPrompt(humanoidRootPart)
		print("Merchant prompt enabled")
		self.maid:GiveTask(prompt.Triggered:Connect(function()
			print("Shop UI triggered")
			if getIsCurrentlyOpen() == false then
				Signals.switchToShopHUD:Fire()
				setIsCurrentlyOpen(true)
			end
		end))
		-- TODO: Polish the stare behavior
		RunService.Heartbeat:Connect(function()
			local playerCharacter = Player.Character
			if playerCharacter then
				local playerHumanoidRootPart = playerCharacter:FindFirstChild("HumanoidRootPart")
				if playerHumanoidRootPart and playerHumanoidRootPart:IsA("BasePart") then
					local _position = humanoidRootPart.Position
					local _position_1 = playerHumanoidRootPart.Position
					local distanceToPlayer = (_position - _position_1).Magnitude
					if distanceToPlayer <= distanceToLookAtPlayer then
						bodyGyro.CFrame = CFrame.lookAt(humanoidRootPart.Position, playerHumanoidRootPart.Position)
					end
				end
			end
		end)
	end
	function NPCComponent:attachProximityPrompt(humanoidRootPart)
		return Make("ProximityPrompt", {
			ObjectText = "The Caregiver",
			ActionText = "Talk",
			Parent = humanoidRootPart,
			MaxActivationDistance = 20,
		})
	end
end
-- (Flamework) NPCComponent metadata
Reflect.defineMetadata(NPCComponent, "identifier", "game/src/systems/NarrartiveSystem/CharacterSystem/NPCSystem/components/merchant@NPCComponent")
Reflect.defineMetadata(NPCComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(NPCComponent, "$c:init@Component", Component, { {
	tag = "NPC-Merchant",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	NPCComponent = NPCComponent,
}
