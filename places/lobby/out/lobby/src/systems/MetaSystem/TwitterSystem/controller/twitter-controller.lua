-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local TwitterSystemController
do
	TwitterSystemController = setmetatable({}, {
		__tostring = function()
			return "TwitterSystemController"
		end,
	})
	TwitterSystemController.__index = TwitterSystemController
	function TwitterSystemController.new(...)
		local self = setmetatable({}, TwitterSystemController)
		return self:constructor(...) or self
	end
	function TwitterSystemController:constructor()
	end
	function TwitterSystemController:onInit()
		print("TwitterSystem Controller initialized")
	end
	function TwitterSystemController:onStart()
		print("TwitterSystem Controller started")
	end
end
-- (Flamework) TwitterSystemController metadata
Reflect.defineMetadata(TwitterSystemController, "identifier", "lobby/src/systems/MetaSystem/TwitterSystem/controller/twitter-controller@TwitterSystemController")
Reflect.defineMetadata(TwitterSystemController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(TwitterSystemController, "$:flamework@Controller", Controller, { {} })
return {
	default = TwitterSystemController,
}
