-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local GameFlowSystemController
do
	GameFlowSystemController = setmetatable({}, {
		__tostring = function()
			return "GameFlowSystemController"
		end,
	})
	GameFlowSystemController.__index = GameFlowSystemController
	function GameFlowSystemController.new(...)
		local self = setmetatable({}, GameFlowSystemController)
		return self:constructor(...) or self
	end
	function GameFlowSystemController:constructor(lifeMechanic, hudController, musicSystem)
		self.lifeMechanic = lifeMechanic
		self.hudController = hudController
		self.musicSystem = musicSystem
	end
	function GameFlowSystemController:onInit()
	end
	function GameFlowSystemController:onStart()
		print("GameFlowSystem Controller started")
		-- Connect to the livesChanged signal
		self.lifeMechanic.livesChanged:Connect(function(lives)
			if lives <= 0 then
				self:transitionToSpectating()
			end
		end)
	end
	function GameFlowSystemController:transitionToSpectating()
		print("Transitioning to spectating...")
		-- Spectating Experience
		self.hudController:switchToSpectateHUD()
	end
	function GameFlowSystemController:transitionToPlaying()
		print("Transitioning to playing...")
		-- TODO: Somehow the player has more lives...
		-- Enable Respawn
		-- Transition to PlayHUD()
	end
end
-- (Flamework) GameFlowSystemController metadata
Reflect.defineMetadata(GameFlowSystemController, "identifier", "tutorial/src/systems/GameFlowSystem/controller/game-flow-controller@GameFlowSystemController")
Reflect.defineMetadata(GameFlowSystemController, "flamework:parameters", { "tutorial/src/mechanics/PlayerMechanics/LifeMechanic/controller/life-controller@LifeMechanic", "tutorial/src/mechanics/PlayerMechanics/UIMechanic/controller/hud-controller@HUDController", "tutorial/src/systems/AudioSystem/MusicSystem/controller/music-controller@MusicSystemController" })
Reflect.defineMetadata(GameFlowSystemController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(GameFlowSystemController, "$:flamework@Controller", Controller, {})
return {
	default = GameFlowSystemController,
}
