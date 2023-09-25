-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local InventorySystemController
do
	InventorySystemController = setmetatable({}, {
		__tostring = function()
			return "InventorySystemController"
		end,
	})
	InventorySystemController.__index = InventorySystemController
	function InventorySystemController.new(...)
		local self = setmetatable({}, InventorySystemController)
		return self:constructor(...) or self
	end
	function InventorySystemController:constructor()
	end
	function InventorySystemController:onStart()
		print("IventorySystem Controller started")
	end
end
-- (Flamework) InventorySystemController metadata
Reflect.defineMetadata(InventorySystemController, "identifier", "lobby/src/systems/InventorySystem/controller/inventory-controller@InventorySystemController")
Reflect.defineMetadata(InventorySystemController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(InventorySystemController, "$:flamework@Controller", Controller, { {
	loadOrder = 99999,
} })
return {
	InventorySystemController = InventorySystemController,
}
