-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local GameFlowSystemService
do
	GameFlowSystemService = setmetatable({}, {
		__tostring = function()
			return "GameFlowSystemService"
		end,
	})
	GameFlowSystemService.__index = GameFlowSystemService
	function GameFlowSystemService.new(...)
		local self = setmetatable({}, GameFlowSystemService)
		return self:constructor(...) or self
	end
	function GameFlowSystemService:constructor()
	end
	function GameFlowSystemService:onStart()
		print("GameFlowSystem Service Started")
	end
end
-- (Flamework) GameFlowSystemService metadata
Reflect.defineMetadata(GameFlowSystemService, "identifier", "tutorial/src/systems/GameFlowSystem/services/game-flow-service@GameFlowSystemService")
Reflect.defineMetadata(GameFlowSystemService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(GameFlowSystemService, "$:flamework@Service", Service, { {} })
return {
	default = GameFlowSystemService,
}
