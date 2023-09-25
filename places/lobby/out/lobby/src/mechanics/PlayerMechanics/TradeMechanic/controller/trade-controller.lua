-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TradeMechanicController
do
	TradeMechanicController = setmetatable({}, {
		__tostring = function()
			return "TradeMechanicController"
		end,
	})
	TradeMechanicController.__index = TradeMechanicController
	function TradeMechanicController.new(...)
		local self = setmetatable({}, TradeMechanicController)
		return self:constructor(...) or self
	end
	function TradeMechanicController:constructor()
	end
	function TradeMechanicController:onStart()
		print("TradeMechanic Controller started")
	end
end
-- (Flamework) TradeMechanicController metadata
Reflect.defineMetadata(TradeMechanicController, "identifier", "lobby/src/mechanics/PlayerMechanics/TradeMechanic/controller/trade-controller@TradeMechanicController")
Reflect.defineMetadata(TradeMechanicController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(TradeMechanicController, "$:flamework@Controller", Controller, { {
	loadOrder = 99999,
} })
return {
	TradeMechanicController = TradeMechanicController,
}
