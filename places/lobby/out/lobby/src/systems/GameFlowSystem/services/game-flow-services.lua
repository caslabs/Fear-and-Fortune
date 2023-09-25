-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local UserInputService = _services.UserInputService
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local GetHumanoidDescriptionFromUserIdEvent = Remotes.Server:Get("GetHumanoidDescriptionFromUserId")
local GameFlowServices
do
	GameFlowServices = setmetatable({}, {
		__tostring = function()
			return "GameFlowServices"
		end,
	})
	GameFlowServices.__index = GameFlowServices
	function GameFlowServices.new(...)
		local self = setmetatable({}, GameFlowServices)
		return self:constructor(...) or self
	end
	function GameFlowServices:constructor()
	end
	function GameFlowServices:onStart()
		local disablePlayerControls = Remotes.Server:Get("disablePlayerControls")
		disablePlayerControls:Connect(function(player)
			player.DevTouchMovementMode = Enum.DevTouchMovementMode.Scriptable
		end)
		UserInputService.JumpRequest:Connect(function()
			local _result = Players.LocalPlayer.Character
			if _result ~= nil then
				_result = _result:FindFirstChildOfClass("Humanoid")
				if _result ~= nil then
					_result:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end
		end)
		GetHumanoidDescriptionFromUserIdEvent:SetCallback(function(player)
			print("Player: ", player)
			if not player then
				error("Player not found!")
			end
			local desc = Players:GetHumanoidDescriptionFromUserId(player.UserId)
			print("Returning description: ", desc)
			return "bruh"
		end)
		Players.PlayerAdded:Connect(TS.async(function(player)
			-- Wait for the character to load
			player.CharacterAdded:Connect(function(character)
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.WalkSpeed = 0
					humanoid.JumpPower = 0
					humanoid.JumpHeight = 0
					humanoid.AutoJumpEnabled = false
					humanoid.AutoRotate = false
				end
			end)
		end))
		print("GameFlowSystem Service Started")
	end
end
-- (Flamework) GameFlowServices metadata
Reflect.defineMetadata(GameFlowServices, "identifier", "lobby/src/systems/GameFlowSystem/services/game-flow-services@GameFlowServices")
Reflect.defineMetadata(GameFlowServices, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(GameFlowServices, "$:flamework@Service", Service, { {
	loadOrder = 9999,
} })
return {
	default = GameFlowServices,
}
