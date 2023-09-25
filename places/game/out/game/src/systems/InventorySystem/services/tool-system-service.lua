-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _core = TS.import(script, TS.getModule(script, "@flamework", "core").out)
local Reflect = _core.Reflect
local Flamework = _core.Flamework
-- eslint-disable roblox-ts/lua-truthiness
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local BaseComponent = _components.BaseComponent
local Component = _components.Component
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local ServerStorage = _services.ServerStorage
local Workspace = _services.Workspace
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local _items_config = TS.import(script, game:GetService("ServerScriptService"), "SystemServices", "InventorySystem", "items-config")
local CooldownManager = _items_config.CooldownManager
local ToolDataConfig = _items_config.ToolDataConfig
local ToolPickupEvent = Remotes.Server:Get("ToolPickupEvent")
local function createPhysicalItem(item, position)
	-- assuming the item has a Model property that refers to a Roblox model ID
	local model = Instance.new("Part")
	model.Parent = Workspace
	model.Position = position
	-- create and configure the ProximityPrompt for the item
	local prompt = Instance.new("ProximityPrompt")
	prompt.ObjectText = item
	prompt.ActionText = "Pick up"
	prompt.Parent = model
	-- return the model and prompt for further use
	return {
		model = model,
		prompt = prompt,
	}
end
local cooldownManager = CooldownManager.new()
local FunctionMap = {
	chopTree = function()
		print("A tree has been chopped!")
	end,
	hitPlayer = function()
		-- Implement friendly fire?
		print("A player has been hit!")
	end,
	hitEntity = function()
		print("An entity has been hit!")
	end,
	swing = function(context)
		local _binding = context
		local lastActionTime = _binding.lastActionTime
		local player = _binding.player
		local action = _binding.action
		local tool = _binding.tool
		local animationInstance = Instance.new("Animation")
		animationInstance.AnimationId = "rbxassetid://" .. action.animationId
		local currentTime = tick()
		local _condition = lastActionTime[player]
		if not (_condition ~= 0 and (_condition == _condition and _condition)) then
			_condition = 0
		end
		local lastSwingTime = _condition
		local _exp = currentTime - lastSwingTime
		local _result = action.cooldownBehavior
		if _result ~= nil then
			_result = _result.duration
		end
		local _condition_1 = _result
		if not (_condition_1 ~= 0 and (_condition_1 == _condition_1 and _condition_1)) then
			_condition_1 = 0
		end
		if _exp < tonumber(_condition_1) then
			print("Cooldown")
			return nil
		end
		lastActionTime[player] = currentTime
		-- Load Animation onto Player
		local _humanoid = player.Character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChildOfClass("Humanoid")
		end
		local humanoid = _humanoid
		if humanoid then
			local animator = humanoid:FindFirstChildOfClass("Animator")
			if animator then
				local animationTrack = animator:LoadAnimation(animationInstance)
				animationTrack:Play()
				print("SWING BABY SWING")
			end
		end
		local hitbox = tool:FindFirstChild("Hitbox")
		if hitbox then
			-- Create the OverlapParams
			local overlapParams = OverlapParams.new()
			overlapParams.FilterType = Enum.RaycastFilterType.Blacklist
			overlapParams.FilterDescendantsInstances = { tool }
			overlapParams.MaxParts = math.huge
			-- Get all parts in the Overlap space
			local parts = Workspace:GetPartsInPart(hitbox, overlapParams)
			for _, part in ipairs(parts) do
				-- Make sure the part is not part of the tool
				if part.Parent ~= tool.Parent then
					-- The part belongs to another player, so it was touched by the hitbox
					print(part.Name .. " was touched by the hitbox")
					-- get position
					--[[
						Design a collision system
					]]
					-- If in action.collision
					local _result_1 = action.collisions
					if _result_1 ~= nil then
						local _arg0 = function(c)
							return c.type == part.Name
						end
						-- ▼ ReadonlyArray.find ▼
						local _result_2
						for _i, _v in ipairs(_result_1) do
							if _arg0(_v, _i - 1, _result_1) == true then
								_result_2 = _v
								break
							end
						end
						-- ▲ ReadonlyArray.find ▲
						_result_1 = _result_2
					end
					if _result_1 then
						local _result_2 = action.collisions
						if _result_2 ~= nil then
							local _arg0 = function(c)
								return c.type == part.Name
							end
							-- ▼ ReadonlyArray.find ▼
							local _result_3
							for _i, _v in ipairs(_result_2) do
								if _arg0(_v, _i - 1, _result_2) == true then
									_result_3 = _v
									break
								end
							end
							-- ▲ ReadonlyArray.find ▲
							_result_2 = _result_3
						end
						local item = _result_2.type
						local ironWoodPart = part
						local dropRadius = 5
						-- TODO: use sound system
						local _soundID = action.collisions
						if _soundID ~= nil then
							local _arg0 = function(c)
								return c.type == part.Name
							end
							-- ▼ ReadonlyArray.find ▼
							local _result_3
							for _i, _v in ipairs(_soundID) do
								if _arg0(_v, _i - 1, _soundID) == true then
									_result_3 = _v
									break
								end
							end
							-- ▲ ReadonlyArray.find ▲
							_soundID = _result_3
							if _soundID ~= nil then
								_soundID = _soundID.soundId[1]
							end
						end
						local soundID = _soundID
						local sound = "rbxassetid://" .. tostring(soundID)
						local soundInstance = Instance.new("Sound")
						soundInstance.SoundId = sound
						soundInstance.Parent = tool
						soundInstance.Volume = 7
						soundInstance.MaxDistance = 10
						soundInstance:Play()
						-- eslint-disable-next-line roblox-ts/lua-truthiness
						local _value = part:GetAttribute("hitCount")
						if not (_value ~= 0 and (_value == _value and (_value ~= "" and _value))) then
							part:SetAttribute("hitCount", 1)
						else
							-- Increment the hit count
							local currentHitCount = part:GetAttribute("hitCount")
							local _fn = part
							currentHitCount += 1
							_fn:SetAttribute("hitCount", currentHitCount)
							print("Hit Count: ", part:GetAttribute("hitCount"))
							-- Check if hit count is enough to destroy the tree
							if (part:GetAttribute("hitCount")) >= 3 then
								-- Your drop items code...
								do
									local i = 0
									local _shouldIncrement = false
									while true do
										if _shouldIncrement then
											i += 1
										else
											_shouldIncrement = true
										end
										local _exp_1 = i
										local _collisions = action.collisions
										local _arg0 = function(c)
											return c.type == part.Name
										end
										-- ▼ ReadonlyArray.find ▼
										local _result_3
										for _i, _v in ipairs(_collisions) do
											if _arg0(_v, _i - 1, _collisions) == true then
												_result_3 = _v
												break
											end
										end
										-- ▲ ReadonlyArray.find ▲
										if not (_exp_1 < _result_3.amount) then
											break
										end
										-- calculate a random position around the player to drop the item
										local _position = ironWoodPart.Position
										local _vector3 = Vector3.new(math.random() * dropRadius - dropRadius / 2, 0, math.random() * dropRadius - dropRadius / 2)
										local dropPosition = _position + _vector3
										-- create the physical item
										local _binding_1 = createPhysicalItem(item, dropPosition)
										local model = _binding_1.model
										local prompt = _binding_1.prompt
										-- connect the trigger to the prompt
										prompt.Triggered:Connect(function(otherPlayer)
											Signals.AddItem:Fire(otherPlayer, item)
											model:Destroy()
										end)
									end
								end
								-- Destroy the part
								part:Destroy()
							end
						end
					end
				end
			end
		end
	end,
	deploy = function(context)
		print("Deploying")
	end,
	fire = function(context)
		print("Firing")
	end,
	heal = function(context)
		print("Healing")
	end,
	build = function(context)
		print("Building")
	end,
}
--[[
	Statically define, dynamically point to behavior (e.g. swing, shoot, etc.)
	dynamic dispatch Tool
]]
local DynamicTool
do
	local super = BaseComponent
	DynamicTool = setmetatable({}, {
		__tostring = function()
			return "DynamicTool"
		end,
		__index = super,
	})
	DynamicTool.__index = DynamicTool
	function DynamicTool.new(...)
		local self = setmetatable({}, DynamicTool)
		return self:constructor(...) or self
	end
	function DynamicTool:constructor()
		super.constructor(self)
		self.isReleased = false
		self.fireConnected = false
		self.lastActionTime = {}
	end
	function DynamicTool:onStart()
		-- If you wish to have more logic during tool start
		print("Dynamic Tool component started")
		local tool = self.instance
		tool:GetPropertyChangedSignal("Parent"):Connect(function()
			self:handleTool(tool)
		end)
	end
	function DynamicTool:handleTool(tool)
		local _result = tool.Parent
		if _result ~= nil then
			_result = _result:IsA("Model")
		end
		local _condition = _result
		if _condition then
			_condition = Players:GetPlayerFromCharacter(tool.Parent)
		end
		if _condition then
			for _, part in ipairs(tool:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
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
				ToolPickupEvent:SendToPlayer(player, player, tool)
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
					local _arg0 = function(c)
						return c.name == tool.Name
					end
					-- ▼ ReadonlyArray.find ▼
					local _result_1
					for _i, _v in ipairs(ToolDataConfig) do
						if _arg0(_v, _i - 1, ToolDataConfig) == true then
							_result_1 = _v
							break
						end
					end
					-- ▲ ReadonlyArray.find ▲
					local config = _result_1
					if config then
						for _, action in ipairs(config.actions) do
							local func = FunctionMap[action.functionId]
							print("Function: ", func)
							if func and not cooldownManager:isActionOnCooldown(action, player) then
								local context = {
									lastActionTime = self.lastActionTime,
									player = player,
									action = action,
									tool = self.instance,
								}
								func(context)
								cooldownManager:updateCooldown(action, player)
							end
						end
					end
				end)
				self.fireConnected = true
			end
		end
	end
end
-- (Flamework) DynamicTool metadata
Reflect.defineMetadata(DynamicTool, "identifier", "game/src/systems/InventorySystem/services/tool-system-service@DynamicTool")
Reflect.defineMetadata(DynamicTool, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(DynamicTool, "$c:init@Component", Component, { {
	instanceGuard = t.instanceIsA("Tool"),
	attributes = {},
} })
local ToolBootloaderService
do
	ToolBootloaderService = setmetatable({}, {
		__tostring = function()
			return "ToolBootloaderService"
		end,
	})
	ToolBootloaderService.__index = ToolBootloaderService
	function ToolBootloaderService.new(...)
		local self = setmetatable({}, ToolBootloaderService)
		return self:constructor(...) or self
	end
	function ToolBootloaderService:constructor()
	end
	function ToolBootloaderService:onInit()
		print("ToolBootloader Service Initialized")
		self:loadTools()
	end
	function ToolBootloaderService:loadTools()
		for _, config in ipairs(ToolDataConfig) do
			self:loadTool(config)
		end
	end
	function ToolBootloaderService:loadTool(config)
		local _result = ServerStorage:FindFirstChild(config.tool)
		if _result ~= nil then
			_result = _result:Clone()
		end
		local toolItem = _result
		if toolItem then
			toolItem.Name = config.name
			toolItem.Parent = Workspace
			-- Add the component
			local components = Flamework.resolveDependency("$c:init@Components")
			components:addComponent(toolItem, "game/src/systems/InventorySystem/services/tool-system-service@DynamicTool")
			print("Added component to", config.name)
		end
	end
end
-- (Flamework) ToolBootloaderService metadata
Reflect.defineMetadata(ToolBootloaderService, "identifier", "game/src/systems/InventorySystem/services/tool-system-service@ToolBootloaderService")
Reflect.defineMetadata(ToolBootloaderService, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(ToolBootloaderService, "$:flamework@Service", Service, { {} })
return {
	FunctionMap = FunctionMap,
	DynamicTool = DynamicTool,
	default = ToolBootloaderService,
}
