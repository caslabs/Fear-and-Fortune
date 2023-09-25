-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
-- sanity-manager.ts
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local DecreaseSanityEvent = Remotes.Server:Get("DecreaseSanityEvent")
local UpdateSanityEvent = Remotes.Server:Get("UpdateSanityEvent")
local SanityMechanicService
do
	SanityMechanicService = setmetatable({}, {
		__tostring = function()
			return "SanityMechanicService"
		end,
	})
	SanityMechanicService.__index = SanityMechanicService
	function SanityMechanicService.new(...)
		local self = setmetatable({}, SanityMechanicService)
		return self:constructor(...) or self
	end
	function SanityMechanicService:constructor()
		self.playerSanity = {}
	end
	function SanityMechanicService:onStart()
		print("SanityMechanic Service started")
		Players.PlayerAdded:Connect(function(player)
			return self:initializePlayer(player)
		end)
		-- Decrease Sanity Event will trigger the decreaseSanity which will update the player's sanity
		DecreaseSanityEvent:Connect(function(player)
			self:decreaseSanity(player, 10)
		end)
	end
	function SanityMechanicService:initializePlayer(player)
		self.playerSanity[player] = 100
	end
	function SanityMechanicService:decreaseSanity(player, amount)
		local currentSanity = self.playerSanity[player]
		if currentSanity ~= nil then
			currentSanity = math.max(0, currentSanity - amount)
			local _playerSanity = self.playerSanity
			local _currentSanity = currentSanity
			_playerSanity[player] = _currentSanity
			print("Player: " .. (player.Name .. (", Sanity: " .. tostring(currentSanity))))
			UpdateSanityEvent:SendToPlayer(player, player, currentSanity)
		end
	end
	function SanityMechanicService:getSanity(player)
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		local _condition = self.playerSanity[player]
		if not (_condition ~= 0 and (_condition == _condition and _condition)) then
			_condition = 100
		end
		return _condition
	end
end
-- (Flamework) SanityMechanicService metadata
Reflect.defineMetadata(SanityMechanicService, "identifier", "tutorial/src/mechanics/PlayerMechanics/_Prototype/SanityMechanic/services/sanity-service@SanityMechanicService")
Reflect.defineMetadata(SanityMechanicService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(SanityMechanicService, "$:flamework@Service", Service, { {} })
return {
	SanityMechanicService = SanityMechanicService,
}
