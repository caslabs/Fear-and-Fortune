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
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local RedRuneComponent
do
	local super = BaseComponent
	RedRuneComponent = setmetatable({}, {
		__tostring = function()
			return "RedRuneComponent"
		end,
		__index = super,
	})
	RedRuneComponent.__index = RedRuneComponent
	function RedRuneComponent.new(...)
		local self = setmetatable({}, RedRuneComponent)
		return self:constructor(...) or self
	end
	function RedRuneComponent:constructor(...)
		super.constructor(self, ...)
	end
	function RedRuneComponent:onStart()
		print("Red Rune Tool Component Initiated")
		local tool = self.instance
		local ToolPickupEvent = Remotes.Server:Get("ToolPickupEvent")
		local ToolRemovedEvent = Remotes.Server:Get("ToolRemovedEvent")
		tool.CanBeDropped = true
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
					ToolPickupEvent:SendToPlayer(player, player, tool)
				else
					local _result_1 = playerBackpack
					if _result_1 ~= nil then
						_result_1 = _result_1:FindFirstChild(tool.Name)
					end
					print(_result_1)
					print("Tool is already in the player's backpack.")
				end
				tool.Activated:Connect(function()
					print("Bear Trap Interacted!")
					-- Place the model (bear trap) on the ground in front of the player.
					local _playerCharacter = Players:GetPlayerFromCharacter(tool.Parent)
					if _playerCharacter ~= nil then
						_playerCharacter = _playerCharacter.Character
					end
					local playerCharacter = _playerCharacter
					if playerCharacter and playerCharacter.PrimaryPart then
						local forwardDirection = playerCharacter.PrimaryPart.CFrame.LookVector
						local _position = playerCharacter.PrimaryPart.Position
						local _arg0 = forwardDirection * 5
						local newPosition = _position + _arg0
						-- Raycast down to find the position on the ground.
						local raycastParams = RaycastParams.new()
						raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
						raycastParams.FilterDescendantsInstances = { playerCharacter }
						local raycastResult = Workspace:Raycast(newPosition, Vector3.new(0, -1000, 0), raycastParams)
						local _result_1 = raycastResult
						if _result_1 ~= nil then
							_result_1 = _result_1.Position
						end
						local _condition_1 = _result_1
						if _condition_1 == nil then
							_condition_1 = newPosition
						end
						local groundPosition = _condition_1
						-- Create a new Model from the tool.
						local _result_2 = Workspace:FindFirstChild("ExitPortal")
						if _result_2 ~= nil then
							_result_2 = _result_2:Clone()
						end
						local redRuneModel = _result_2
						if not redRuneModel then
							print("No 'ExitPortal' model found in Workspace.")
							return nil
						end
						redRuneModel.Name = "RedRuneExitPortal"
						redRuneModel.Parent = Workspace
						local _exp = tool:GetChildren()
						local _arg0_1 = function(child)
							if child:IsA("BasePart") then
								child.Parent = redRuneModel
							end
						end
						for _k, _v in ipairs(_exp) do
							_arg0_1(_v, _k - 1, _exp)
						end
						local trapUnion = redRuneModel:FindFirstChild("ExitPortal")
						if trapUnion then
							redRuneModel.PrimaryPart = trapUnion
							-- Add half of the UnionOperation's size to the y-coordinate of the ground position.
							local unionSizeHalf = trapUnion.Size.Y / 2
							local _result_3 = raycastResult
							if _result_3 ~= nil then
								_result_3 = _result_3.Position
							end
							local _condition_2 = _result_3
							if _condition_2 == nil then
								_condition_2 = newPosition
							end
							local _vector3 = Vector3.new(0, unionSizeHalf, 0)
							local groundPosition = _condition_2 + _vector3
							local _result_4 = raycastResult
							if _result_4 ~= nil then
								_result_4 = _result_4.Position
							end
							local _condition_3 = _result_4
							if _condition_3 == nil then
								_condition_3 = newPosition
							end
							local _vector3_1 = Vector3.new(0, 6, 0)
							groundPosition = _condition_3 + _vector3_1
							redRuneModel:SetPrimaryPartCFrame(CFrame.new(groundPosition))
							-- then add +5 to the y-coordinate of the ground position.
							print("Red Rune Model Placed")
							-- TODO: is this good? Play 3D Spatial Sound
							-- Broken, only plays once and then never again...
							local soundID = "13983704227"
							local sound = "rbxassetid://" .. soundID
							local soundInstance = Instance.new("Sound")
							soundInstance.SoundId = sound
							soundInstance.Parent = redRuneModel
							soundInstance.Volume = 7
							soundInstance.MaxDistance = 10
							soundInstance:Play()
							-- Weld the model to the Workspace to keep it in place.
							Make("WeldConstraint", {
								Part0 = redRuneModel.PrimaryPart,
								Part1 = Workspace.Terrain,
								Parent = redRuneModel,
							})
							self:attachTouchFunction(redRuneModel)
							-- Remove the tool from the player's character.
							ToolRemovedEvent:SendToPlayer(player, player, tool)
							tool.Parent = nil
						else
							print("No 'Union' found inside the model.")
						end
					end
				end)
			end
		end)
	end
	function RedRuneComponent:attachTouchFunction(model)
		print("Bear Trap Active Initiated")
		local primaryPart = model.PrimaryPart
		if primaryPart then
			primaryPart.Touched:Connect(function(part) end)
		end
	end
end
-- (Flamework) RedRuneComponent metadata
Reflect.defineMetadata(RedRuneComponent, "identifier", "game/src/entities/Resources/IronWood/services/redrune-service@RedRuneComponent")
Reflect.defineMetadata(RedRuneComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(RedRuneComponent, "$c:init@Component", Component, { {
	tag = "RedRuneToolTrigger",
	instanceGuard = t.instanceIsA("Tool"),
	attributes = {},
} })
return {
	RedRuneComponent = RedRuneComponent,
}
