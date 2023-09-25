-- Compiled with roblox-ts v1.3.3
-- Prototype
--[[
	My philosophy is that everything you can pick up can be a tool
	Known types
	- Ritual Table (Portable Gear on Hand)
	- Crafting Table (Portable Gear on Hand)
	- Tools
	-  - Weapons
	-   - Melee
	-   - Ranged
	- - Resource Gathering Tools
	-   - Hatchet
	-   - Pickaxe
]]
local ToolDataConfig = { {
	id = "axe_001",
	name = "AxeToolTrigger",
	model_id = "Axe",
	tool = "Axe",
	actions = { {
		type = "swing",
		functionId = "swing",
		cooldownBehavior = {
			duration = 1,
			lastSwingTime = {},
		},
		collisions = { {
			type = "IronWoodTree",
			soundId = { "159798328" },
			amount = 3,
		}, {
			type = "WoodTree",
			soundId = { "159798328" },
			amount = 3,
		} },
		animationId = "567480700O",
		soundId = "some_sound_id",
	} },
} }
local CooldownManager
do
	CooldownManager = setmetatable({}, {
		__tostring = function()
			return "CooldownManager"
		end,
	})
	CooldownManager.__index = CooldownManager
	function CooldownManager.new(...)
		local self = setmetatable({}, CooldownManager)
		return self:constructor(...) or self
	end
	function CooldownManager:constructor()
	end
	function CooldownManager:isActionOnCooldown(action, player)
		local cooldownBehavior = action.cooldownBehavior
		if not cooldownBehavior then
			return false
		end
		local lastSwing = cooldownBehavior.lastSwingTime[player]
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		if not (lastSwing ~= 0 and (lastSwing == lastSwing and lastSwing)) then
			return false
		end
		local currentTime = tick()
		return currentTime - lastSwing < cooldownBehavior.duration
	end
	function CooldownManager:updateCooldown(action, player)
		if action.cooldownBehavior then
			local _lastSwingTime = action.cooldownBehavior.lastSwingTime
			local _arg1 = tick()
			_lastSwingTime[player] = _arg1
		end
	end
end
return {
	ToolDataConfig = ToolDataConfig,
	CooldownManager = CooldownManager,
}
