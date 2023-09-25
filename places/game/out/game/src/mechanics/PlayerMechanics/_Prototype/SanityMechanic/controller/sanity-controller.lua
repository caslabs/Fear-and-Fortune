-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
-- client/controller/sanity-mechanic-controller.ts
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local DecreaseSanityEvent = Remotes.Client:Get("DecreaseSanityEvent")
local SanityMechanicController
do
	SanityMechanicController = setmetatable({}, {
		__tostring = function()
			return "SanityMechanicController"
		end,
	})
	SanityMechanicController.__index = SanityMechanicController
	function SanityMechanicController.new(...)
		local self = setmetatable({}, SanityMechanicController)
		return self:constructor(...) or self
	end
	function SanityMechanicController:constructor()
	end
	function SanityMechanicController:onInit()
	end
	function SanityMechanicController:onStart()
		print("SanityMechanic Controller started")
		-- TODO: Spamming H (or updating to the Sanity Component under HUD will lag the player)
		--[[
			ContextActionService.BindAction(
			"DecreaseSanity",
			(_, state) => {
			if (state === Enum.UserInputState.Begin) {
			// Fire the DecreaseSanityEvent to the server game state
			DecreaseSanityEvent.SendToServer(Players.LocalPlayer);
			}
			},
			false,
			Enum.KeyCode.H,
			);
		]]
	end
end
-- (Flamework) SanityMechanicController metadata
Reflect.defineMetadata(SanityMechanicController, "identifier", "game/src/mechanics/PlayerMechanics/_Prototype/SanityMechanic/controller/sanity-controller@SanityMechanicController")
Reflect.defineMetadata(SanityMechanicController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(SanityMechanicController, "$:flamework@Controller", Controller, { {} })
return {
	default = SanityMechanicController,
}
