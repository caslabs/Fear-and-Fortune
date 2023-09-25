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
local BansheeTrapComponent
do
	local super = BaseComponent
	BansheeTrapComponent = setmetatable({}, {
		__tostring = function()
			return "BansheeTrapComponent"
		end,
		__index = super,
	})
	BansheeTrapComponent.__index = BansheeTrapComponent
	function BansheeTrapComponent.new(...)
		local self = setmetatable({}, BansheeTrapComponent)
		return self:constructor(...) or self
	end
	function BansheeTrapComponent:constructor(...)
		super.constructor(self, ...)
	end
	function BansheeTrapComponent:onStart()
		print("Banshee Trap Tool Component Initiated")
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
					print("Banshee Trap Interacted!")
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
						local _result_2 = Workspace:FindFirstChild("BansheeTrap")
						if _result_2 ~= nil then
							_result_2 = _result_2:Clone()
						end
						local bansheeTrapModel = _result_2
						if not bansheeTrapModel then
							print("No 'BansheeTrap' model found in Workspace.")
							return nil
						end
						bansheeTrapModel.Name = "BansheeTrap"
						bansheeTrapModel.Parent = Workspace
						local trapUnion = bansheeTrapModel:FindFirstChild("BansheeTrap")
						if trapUnion then
							bansheeTrapModel.PrimaryPart = trapUnion
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
							bansheeTrapModel:SetPrimaryPartCFrame(CFrame.new(groundPosition))
							-- Weld the model to the Workspace to keep it in place.
							Make("WeldConstraint", {
								Part0 = bansheeTrapModel.PrimaryPart,
								Part1 = Workspace.Terrain,
								Parent = bansheeTrapModel,
							})
							self:attachTouchFunction(bansheeTrapModel)
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
	function BansheeTrapComponent:attachTouchFunction(model)
		print("Banshee Trap Active Initiated")
		local primaryPart = model.PrimaryPart
		if primaryPart then
			primaryPart.Touched:Connect(function(part)
				print("Touched event triggered!")
				-- Check if the touched part belongs to a model named "Banshee"
				local _result = part.Parent
				if _result ~= nil then
					_result = _result.Name
				end
				if _result == "Banshee" then
					print("Banshee touched!")
					local _result_1 = part.Parent
					if _result_1 ~= nil then
						_result_1 = _result_1:FindFirstChild("Humanoid")
					end
					if _result_1 then
						local humanoid = part.Parent:FindFirstChild("Humanoid")
						humanoid:TakeDamage(humanoid.MaxHealth)
					end
				else
					print("Non-Banshee model touched, ignoring...")
				end
			end)
		end
	end
end
-- (Flamework) BansheeTrapComponent metadata
Reflect.defineMetadata(BansheeTrapComponent, "identifier", "game/src/entities/Resources/IronWood/services/bansheetrap-service@BansheeTrapComponent")
Reflect.defineMetadata(BansheeTrapComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(BansheeTrapComponent, "$c:init@Component", Component, { {
	tag = "BansheeTrapTool",
	instanceGuard = t.instanceIsA("Tool"),
	attributes = {},
} })
return {
	BansheeTrapComponent = BansheeTrapComponent,
}
