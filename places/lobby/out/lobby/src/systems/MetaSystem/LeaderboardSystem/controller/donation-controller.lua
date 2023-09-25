-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local DonationSystemController
do
	DonationSystemController = setmetatable({}, {
		__tostring = function()
			return "DonationSystemController"
		end,
	})
	DonationSystemController.__index = DonationSystemController
	function DonationSystemController.new(...)
		local self = setmetatable({}, DonationSystemController)
		return self:constructor(...) or self
	end
	function DonationSystemController:constructor()
	end
	function DonationSystemController:onInit()
		print("DonationSystem Controller initialized")
	end
	function DonationSystemController:onStart()
		print("DonationSystem Controller started")
	end
end
-- (Flamework) DonationSystemController metadata
Reflect.defineMetadata(DonationSystemController, "identifier", "lobby/src/systems/MetaSystem/LeaderboardSystem/controller/donation-controller@DonationSystemController")
Reflect.defineMetadata(DonationSystemController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(DonationSystemController, "$:flamework@Controller", Controller, { {} })
return {
	default = DonationSystemController,
}
