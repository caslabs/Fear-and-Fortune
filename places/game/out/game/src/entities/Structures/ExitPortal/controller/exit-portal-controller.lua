-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
-- TODO: Refactor this to be a generic door component
local ToggleRespawn = Remotes.Client:Get("ToggleRespawn")
local IsExtractedEvent = Remotes.Client:Get("IsExtracted")
local UpdateExpeditionCountEvent = Remotes.Client:Get("UpdateExpeditionCount")
local animationInstance = Instance.new("Animation")
animationInstance.AnimationId = "rbxassetid://14308122728"
local ExitPortalComponent
do
	local super = BaseComponent
	ExitPortalComponent = setmetatable({}, {
		__tostring = function()
			return "ExitPortalComponent"
		end,
		__index = super,
	})
	ExitPortalComponent.__index = ExitPortalComponent
	function ExitPortalComponent.new(...)
		local self = setmetatable({}, ExitPortalComponent)
		return self:constructor(...) or self
	end
	function ExitPortalComponent:constructor()
		super.constructor(self)
		self.armParts = {}
		self.animation = nil
		self.charPantsID = nil
		self.charShirtID = nil
	end
	function ExitPortalComponent:onStart()
		print("ExitPortal Component Initiated")
		if self.instance:IsA("Model") and not self.instance.PrimaryPart then
			print("Unable to attach ProximityPrompt to ShopComponent because it has no PrimaryPart")
			return nil
		end
		local prompt = self:attachProximityPrompt()
		self.maid:GiveTask(prompt.Triggered:Connect(function(player)
			IsExtractedEvent:SendToServer(player)
			print("[PORTAL] Called IsExtractedEvent")
			SoundSystemController:playSound(SoundKeys.SFX_PORTAL_EXIT, 3)
			self:TeleportToLobby(player)
			-- TODO: EXTRACTION PING
			UpdateExpeditionCountEvent:SendToServer(player)
		end))
		self.maid:GiveTask(prompt.PromptButtonHoldBegan:Connect(function(player)
			self:startGlowing(player)
		end))
		self.maid:GiveTask(prompt.PromptButtonHoldEnded:Connect(function(player)
			self:stopGlowing(player)
		end))
		local player = Players.LocalPlayer
		local char = player.Character
		-- Save the Character pants and shirts
		local _result = char
		if _result ~= nil then
			_result = _result:FindFirstChildOfClass("Pants")
			if _result ~= nil then
				_result = _result.PantsTemplate
			end
		end
		self.charPantsID = _result
		local _result_1 = char
		if _result_1 ~= nil then
			_result_1 = _result_1:FindFirstChildOfClass("Shirt")
			if _result_1 ~= nil then
				_result_1 = _result_1.ShirtTemplate
			end
		end
		self.charShirtID = _result_1
		if char ~= nil then
			self.armParts = self:getArmParts(char)
		end
		local _humanoid = player.Character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChildOfClass("Humanoid")
		end
		local humanoid = _humanoid
		if humanoid then
			local animator = humanoid:FindFirstChildOfClass("Animator")
			if animator then
				self.animation = animator:LoadAnimation(animationInstance)
				print("animation loaded")
			end
		end
	end
	function ExitPortalComponent:getArmParts(character)
		local armPartNames = { "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "Left Arm", "Right Arm" }
		local armParts = {}
		for _, partName in ipairs(armPartNames) do
			local part = character:FindFirstChild(partName)
			if part ~= nil and part:IsA("BasePart") then
				table.insert(armParts, part)
			end
		end
		return armParts
	end
	function ExitPortalComponent:attachProximityPrompt()
		return Make("ProximityPrompt", {
			ObjectText = "ExitPortal",
			ActionText = "Exit",
			HoldDuration = 3,
			Parent = if self.instance:IsA("Model") then self.instance.PrimaryPart else self.instance,
		})
	end
	function ExitPortalComponent:TeleportToLobby(player)
		-- Make player temporarily immune + immunity effect
		-- Switch to spectate camera
		-- Show option to return to lobby or keep spectating
		-- If option is true, return to lobby
		ToggleRespawn:SendToServer(false)
		Signals.ExitPortalTouched:Fire()
		local character = player.Character
		if character ~= nil then
			player.Character = nil
			character:ClearAllChildren()
			character:Destroy()
		end
		--[[
			print("[INFO] Attempting to Teleport Lobby...");
			const placeId = 13733616492; // Replace with your main game's place ID
			TeleportService.TeleportAsync(placeId, [player]);
		]]
	end
	function ExitPortalComponent:startGlowing(player)
		print("[INFO] GLOWING")
		local character = player.Character
		-- DEFINSIVE PROGRAMMIGN -
		-- Only remove pants if they exist
		local _result = character
		if _result ~= nil then
			_result = _result:FindFirstChild("Pants")
		end
		local pants = _result
		if pants then
			pants.PantsTemplate = ""
		end
		-- Only remove shirt if it exists
		local _result_1 = character
		if _result_1 ~= nil then
			_result_1 = _result_1:FindFirstChild("Shirt")
		end
		local shirt = _result_1
		if shirt then
			shirt.ShirtTemplate = ""
		end
		for _, part in ipairs(self.armParts) do
			part.Material = Enum.Material.Neon
			print("Material set to " .. tostring(part.Material))
		end
		if self.animation ~= nil then
			self.animation:Play()
		else
			print("ERROR: No animation")
		end
		-- 14308122728
	end
	function ExitPortalComponent:stopGlowing(player)
		print("[INFO] STOP GLOWING")
		local character = player.Character
		if self.charPantsID == nil or self.charShirtID == nil then
			print("ERROR: No charPantsID or charShirtID")
		else
			-- Only give back pants if they exist
			local _result = character
			if _result ~= nil then
				_result = _result:FindFirstChild("Pants")
			end
			local pants = _result
			if pants then
				pants.PantsTemplate = self.charPantsID
			end
			-- Only give back shirt if it exists
			local _result_1 = character
			if _result_1 ~= nil then
				_result_1 = _result_1:FindFirstChild("Shirt")
			end
			local shirt = _result_1
			if shirt then
				shirt.ShirtTemplate = self.charShirtID
			end
		end
		for _, part in ipairs(self.armParts) do
			part.Material = Enum.Material.Plastic
		end
		if self.animation ~= nil then
			self.animation:Stop()
		else
			print("ERROR: No animation")
		end
	end
end
-- (Flamework) ExitPortalComponent metadata
Reflect.defineMetadata(ExitPortalComponent, "identifier", "game/src/entities/Structures/ExitPortal/controller/exit-portal-controller@ExitPortalComponent")
Reflect.defineMetadata(ExitPortalComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(ExitPortalComponent, "$c:init@Component", Component, { {
	tag = "ExitPortalTrigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	ExitPortalComponent = ExitPortalComponent,
}
