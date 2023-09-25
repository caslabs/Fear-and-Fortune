-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local CurrencyMechanicController
do
	CurrencyMechanicController = setmetatable({}, {
		__tostring = function()
			return "CurrencyMechanicController"
		end,
	})
	CurrencyMechanicController.__index = CurrencyMechanicController
	function CurrencyMechanicController.new(...)
		local self = setmetatable({}, CurrencyMechanicController)
		return self:constructor(...) or self
	end
	function CurrencyMechanicController:constructor()
	end
	function CurrencyMechanicController:onStart()
		print("CurrencyMechanic Controller started")
	end
end
-- (Flamework) CurrencyMechanicController metadata
Reflect.defineMetadata(CurrencyMechanicController, "identifier", "lobby/src/mechanics/PlayerMechanics/CurrencyMechanic/controller/currency-controller@CurrencyMechanicController")
Reflect.defineMetadata(CurrencyMechanicController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(CurrencyMechanicController, "$:flamework@Controller", Controller, { {
	loadOrder = 99999,
} })
return {
	CurrencyMechanicController = CurrencyMechanicController,
}
