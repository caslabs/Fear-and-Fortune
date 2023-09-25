-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local BaseComponent = TS.import(script, TS.getModule(script, "@flamework", "components").out).BaseComponent
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local EventManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "EventManager").EventManager
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local AIController
do
	local super = BaseComponent
	AIController = setmetatable({}, {
		__tostring = function()
			return "AIController"
		end,
		__index = super,
	})
	AIController.__index = AIController
	function AIController.new(...)
		local self = setmetatable({}, AIController)
		return self:constructor(...) or self
	end
	function AIController:constructor()
		super.constructor(self)
		self.eventManager = EventManager:getInstance()
	end
	function AIController:onStart()
		local stopJumpScareZoomEvent = Remotes.Client:Get("StopJumpScareZoom")
		local playJumpScareZoomEvent = Remotes.Client:Get("PlayJumpScareZoom")
		playJumpScareZoomEvent:Connect(function()
			self.eventManager:dispatchEvent(GameEventType.PostProcessing, {
				state = "zoom",
			})
		end)
		stopJumpScareZoomEvent:Connect(function()
			-- TODO: Doesn't work
			self.eventManager:dispatchEvent(GameEventType.PostProcessing, {
				state = "default",
			})
			local player = Players.LocalPlayer
			local camera = Workspace.CurrentCamera
			if player and camera then
				-- Zoom in slightly
				camera.FieldOfView = 70
			end
		end)
	end
end
-- (Flamework) AIController metadata
Reflect.defineMetadata(AIController, "identifier", "game/src/entities/Structures/ExitPortal/controller/ai-controller@AIController")
Reflect.defineMetadata(AIController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(AIController, "$:flamework@Controller", Controller, { {} })
return {
	AIController = AIController,
}
