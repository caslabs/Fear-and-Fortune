-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ClassController
do
	ClassController = setmetatable({}, {
		__tostring = function()
			return "ClassController"
		end,
	})
	ClassController.__index = ClassController
	function ClassController.new(...)
		local self = setmetatable({}, ClassController)
		return self:constructor(...) or self
	end
	function ClassController:constructor(hudController, cameraMechanic)
		self.hudController = hudController
		self.cameraMechanic = cameraMechanic
	end
	function ClassController:onStart()
		print("ClassSystem Controller started")
	end
end
-- (Flamework) ClassController metadata
Reflect.defineMetadata(ClassController, "identifier", "lobby/src/systems/ProfessionSystem/controller/_class-controller@ClassController")
Reflect.defineMetadata(ClassController, "flamework:parameters", { "lobby/src/mechanics/PlayerMechanics/UIMechanic/controller/hud-controller@HUDController", "lobby/src/mechanics/PlayerMechanics/CameraMechanic/controller/camera-controller@CameraMechanic" })
Reflect.defineMetadata(ClassController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(ClassController, "$:flamework@Controller", Controller, { {
	loadOrder = 99999,
} })
return {
	ClassController = ClassController,
}
