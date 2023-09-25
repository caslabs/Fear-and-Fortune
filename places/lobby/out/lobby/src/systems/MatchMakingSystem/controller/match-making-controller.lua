-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local EventFlowController
do
	EventFlowController = setmetatable({}, {
		__tostring = function()
			return "EventFlowController"
		end,
	})
	EventFlowController.__index = EventFlowController
	function EventFlowController.new(...)
		local self = setmetatable({}, EventFlowController)
		return self:constructor(...) or self
	end
	function EventFlowController:constructor(hudController, cameraMechanic)
		self.hudController = hudController
		self.cameraMechanic = cameraMechanic
	end
	function EventFlowController:onStart()
		print("Match Making Controller started")
	end
end
-- (Flamework) EventFlowController metadata
Reflect.defineMetadata(EventFlowController, "identifier", "lobby/src/systems/MatchMakingSystem/controller/match-making-controller@EventFlowController")
Reflect.defineMetadata(EventFlowController, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/UIMechanic/controller/hud-controller@HUDController", "lobby/src/mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller@CameraMechanic" })
Reflect.defineMetadata(EventFlowController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(EventFlowController, "$:flamework@Controller", Controller, { {
	loadOrder = 99999,
} })
return {
	EventFlowController = EventFlowController,
}
