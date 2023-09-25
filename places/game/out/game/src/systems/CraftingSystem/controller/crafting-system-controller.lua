-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local CraftSystemController
do
	CraftSystemController = setmetatable({}, {
		__tostring = function()
			return "CraftSystemController"
		end,
	})
	CraftSystemController.__index = CraftSystemController
	function CraftSystemController.new(...)
		local self = setmetatable({}, CraftSystemController)
		return self:constructor(...) or self
	end
	function CraftSystemController:constructor()
	end
	function CraftSystemController:onInit()
		print("CraftSystemController initialized")
	end
	function CraftSystemController:onStart()
		print("CraftSystemController started")
	end
end
-- (Flamework) CraftSystemController metadata
Reflect.defineMetadata(CraftSystemController, "identifier", "game/src/systems/CraftingSystem/controller/crafting-system-controller@CraftSystemController")
Reflect.defineMetadata(CraftSystemController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(CraftSystemController, "$:flamework@Controller", Controller, { {} })
return {
	default = CraftSystemController,
}
