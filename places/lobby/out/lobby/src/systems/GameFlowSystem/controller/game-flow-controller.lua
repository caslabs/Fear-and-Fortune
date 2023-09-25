-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local StarterPlayer = _services.StarterPlayer
local StarterGui = _services.StarterGui
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local GameFlowController
do
	GameFlowController = setmetatable({}, {
		__tostring = function()
			return "GameFlowController"
		end,
	})
	GameFlowController.__index = GameFlowController
	function GameFlowController.new(...)
		local self = setmetatable({}, GameFlowController)
		return self:constructor(...) or self
	end
	function GameFlowController:constructor()
	end
	function GameFlowController:onStart()
		local player = Players.LocalPlayer
		local PlayerGui = player:WaitForChild("PlayerGui")
		PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeLeft
		StarterGui:SetCore("ResetButtonCallback", false)
		StarterPlayer.EnableMouseLockOption = false
		-- TODO: Disable Reset Button
		-- StarterGui.SetCore(Enum.CoreGuiType., false);
		-- Badge: Joining for the first time
		Signals.playerFirstJoinSignal:Fire(player)
		print("GameFlowSystem Controller Started")
	end
end
-- (Flamework) GameFlowController metadata
Reflect.defineMetadata(GameFlowController, "identifier", "lobby/src/systems/GameFlowSystem/controller/game-flow-controller@GameFlowController")
Reflect.defineMetadata(GameFlowController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(GameFlowController, "$:flamework@Service", Service, { {
	loadOrder = 0,
} })
return {
	default = GameFlowController,
}
