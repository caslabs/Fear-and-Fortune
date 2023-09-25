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
local MakeshiftTentComponent
do
	local super = BaseComponent
	MakeshiftTentComponent = setmetatable({}, {
		__tostring = function()
			return "MakeshiftTentComponent"
		end,
		__index = super,
	})
	MakeshiftTentComponent.__index = MakeshiftTentComponent
	function MakeshiftTentComponent.new(...)
		local self = setmetatable({}, MakeshiftTentComponent)
		return self:constructor(...) or self
	end
	function MakeshiftTentComponent:constructor(...)
		super.constructor(self, ...)
	end
	function MakeshiftTentComponent:onStart()
		print("MakeshiftTent Tool Component Initiated")
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
					print("MakeshiftTent Interacted!")
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
						-- let groundPosition = raycastResult?.Position ?? newPosition;
						-- Create a new Model from the tool.
						local _result_1 = Workspace:FindFirstChild("MakeshiftTent")
						if _result_1 ~= nil then
							_result_1 = _result_1:Clone()
						end
						local MakeshiftTentModel = _result_1
						if not MakeshiftTentModel then
							print("No 'MakeshiftTent' model found in Workspace.")
							return nil
						end
						MakeshiftTentModel.Name = "MakeshiftTent"
						MakeshiftTentModel.Parent = Workspace
						local _exp = tool:GetChildren()
						local _arg0_1 = function(child)
							if child:IsA("BasePart") then
								child.Parent = MakeshiftTentModel
							end
						end
						for _k, _v in ipairs(_exp) do
							_arg0_1(_v, _k - 1, _exp)
						end
						local tentBase = (MakeshiftTentModel:FindFirstChild("MakeshiftTent")).PrimaryPart
						-- Add half of the UnionOperation's size to the y-coordinate of the ground position.
						local unionSizeHalf = tentBase.Size.Y / 2
						local _result_2 = raycastResult
						if _result_2 ~= nil then
							_result_2 = _result_2.Position
						end
						local _condition_1 = _result_2
						if _condition_1 == nil then
							_condition_1 = newPosition
						end
						local _vector3 = Vector3.new(0, unionSizeHalf, 0)
						local groundPosition = _condition_1 + _vector3
						MakeshiftTentModel:SetPrimaryPartCFrame(CFrame.new(groundPosition))
						-- then add +5 to the y-coordinate of the ground position.
						print("MakeshiftTent Model Placed")
						-- Weld the model to the Workspace to keep it in place.
						Make("WeldConstraint", {
							Part0 = MakeshiftTentModel.PrimaryPart,
							Part1 = Workspace.Terrain,
							Parent = MakeshiftTentModel,
						})
						self:attachTouchFunction(MakeshiftTentModel)
						-- Remove the tool from the player's character.
						ToolRemovedEvent:SendToPlayer(player, player, tool)
						tool.Parent = nil
					end
				end)
			end
		end)
	end
	function MakeshiftTentComponent:attachTouchFunction(model)
		print("Bear Trap Active Initiated")
		local primaryPart = model.PrimaryPart
		if primaryPart then
			primaryPart.Touched:Connect(function(part) end)
		end
	end
end
-- (Flamework) MakeshiftTentComponent metadata
Reflect.defineMetadata(MakeshiftTentComponent, "identifier", "game/src/entities/Resources/IronWood/services/tent-service@MakeshiftTentComponent")
Reflect.defineMetadata(MakeshiftTentComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(MakeshiftTentComponent, "$c:init@Component", Component, { {
	tag = "MakeshiftTentTool",
	instanceGuard = t.instanceIsA("Tool"),
	attributes = {},
} })
return {
	MakeshiftTentComponent = MakeshiftTentComponent,
}
