-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local CrouchService
do
	CrouchService = setmetatable({}, {
		__tostring = function()
			return "CrouchService"
		end,
	})
	CrouchService.__index = CrouchService
	function CrouchService.new(...)
		local self = setmetatable({}, CrouchService)
		return self:constructor(...) or self
	end
	function CrouchService:constructor()
	end
	function CrouchService:onInit()
		print("CrouchService initialized")
	end
	function CrouchService:onStart()
		Players.PlayerAdded:Connect(function(player)
			player:SetAttribute("isCrouching", false)
		end)
		local isCrouchingEvent = Remotes.Server:Get("IsCrouching")
		isCrouchingEvent:Connect(function(player, isCrouching)
			-- Update the player's crouching state
			player:SetAttribute("isCrouching", isCrouching)
		end)
		print("CrouchService started")
	end
end
-- (Flamework) CrouchService metadata
Reflect.defineMetadata(CrouchService, "identifier", "game/src/mechanics/PlayerMechanics/StealthMechanic/services/crouch-service@CrouchService")
Reflect.defineMetadata(CrouchService, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(CrouchService, "$:flamework@Service", Service, { {} })
return {
	default = CrouchService,
}
