-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
-- Define ToolData for the Rifle
-- TODO: Prototype
local canteenData = {
	ammo = 3,
	maxAmmo = 3,
}
local PlayGunShakeEvent = Remotes.Server:Get("PlayGunShake")
local ToolPickupEvent = Remotes.Server:Get("ToolPickupEvent")
local ToolRemovedEvent = Remotes.Server:Get("ToolRemovedEvent")
local UpdateAmmoEvent = Remotes.Server:Get("UpdateAmmoEvent")
local AddThirstEvent = Remotes.Server:Get("AddThirst")
-- TODO: is this good? Play 3D Spatial Sound
-- Broken, only plays once and then never again...
local soundID = "7935556153"
local sound = "rbxassetid://" .. soundID
local soundInstance = Instance.new("Sound")
soundInstance.SoundId = sound
local CanteenComponent
do
	local super = BaseComponent
	CanteenComponent = setmetatable({}, {
		__tostring = function()
			return "CanteenComponent"
		end,
		__index = super,
	})
	CanteenComponent.__index = CanteenComponent
	function CanteenComponent.new(...)
		local self = setmetatable({}, CanteenComponent)
		return self:constructor(...) or self
	end
	function CanteenComponent:constructor()
		super.constructor(self)
		self.canteenData = {
			ammo = 3,
			maxAmmo = 3,
		}
		self.isReleased = false
		self.fireConnected = false
		self.timeActivated = nil
		self.hasDrunk = false
		self.drinkAfter4Seconds = false
	end
	function CanteenComponent:onStart()
		print("Canteen Tool Component Initiated")
		local tool = self.instance
		local timeActivated
		tool:GetPropertyChangedSignal("Parent"):Connect(function()
			-- Loop through all the parts of the tool and set CanCollide to false
			for _, part in ipairs(tool:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
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
					ToolPickupEvent:SendToPlayer(player, player, tool, self.canteenData)
					UpdateAmmoEvent:SendToPlayer(player, self.canteenData.ammo)
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
						self.timeActivated = tick()
						self.isReleased = false
						self.hasDrunk = false
						while not self.isReleased do
							wait(1)
							local currentTime = tick()
							local holdDuration = currentTime - self.timeActivated
							if holdDuration >= 4 and not self.hasDrunk then
								self:drink(player)
								self.hasDrunk = true
							end
						end
					end)
					tool.Deactivated:Connect(function()
						self.isReleased = true
						-- Calculate the duration for which the button was held
						local currentTime = tick()
						local holdDuration = 0
						if self.timeActivated ~= nil then
							holdDuration = currentTime - self.timeActivated
						end
						-- Check if the button was held for less than 4 seconds
						if holdDuration < 4 and not self.hasDrunk then
							print("Button released too soon! Hold the button for 4 seconds to drink.")
						end
					end)
					self.fireConnected = true
				end
			end
		end)
	end
	function CanteenComponent:drink(player)
		print("Drank!")
		AddThirstEvent:SendToPlayer(player, 30)
	end
	function CanteenComponent:attachTouchFunction(model)
		print("Canteen Active Initiated")
	end
end
-- (Flamework) CanteenComponent metadata
Reflect.defineMetadata(CanteenComponent, "identifier", "game/src/entities/Tools/Canteen/services/canteen-service@CanteenComponent")
Reflect.defineMetadata(CanteenComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(CanteenComponent, "$c:init@Component", Component, { {
	tag = "CanteenToolTriggerService",
	instanceGuard = t.instanceIsA("Tool"),
	attributes = {},
} })
return {
	CanteenComponent = CanteenComponent,
}
