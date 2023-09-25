-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- sanity-manager.ts
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
-- TODO: We did not use the SanityManager. We used the SanityMechanicService instead.
-- So, would a Manager be useful? Or just a Service? to manage states?
local SanityManager
do
	SanityManager = setmetatable({}, {
		__tostring = function()
			return "SanityManager"
		end,
	})
	SanityManager.__index = SanityManager
	function SanityManager.new(...)
		local self = setmetatable({}, SanityManager)
		return self:constructor(...) or self
	end
	function SanityManager:constructor()
		-- Each player has a "sanity" meter that starts at 100 and decreases over time
		self.playerSanity = {}
		Players.PlayerAdded:Connect(function(player)
			return self:initializePlayer(player)
		end)
	end
	function SanityManager:initializePlayer(player)
		self.playerSanity[player] = 100
	end
	function SanityManager:decreaseSanity(player, amount)
		local currentSanity = self.playerSanity[player]
		if currentSanity ~= nil then
			currentSanity = math.max(0, currentSanity - amount)
			local _playerSanity = self.playerSanity
			local _currentSanity = currentSanity
			_playerSanity[player] = _currentSanity
			print("[INFO] Player: " .. (player.Name .. (", Sanity: " .. tostring(currentSanity))))
		end
	end
	function SanityManager:getSanity(player)
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		local _condition = self.playerSanity[player]
		if not (_condition ~= 0 and (_condition == _condition and _condition)) then
			_condition = 100
		end
		return _condition
	end
end
return {
	SanityManager = SanityManager,
}
