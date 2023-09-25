-- Compiled with roblox-ts v1.3.3
--[[
	the Blackboard system's primary goal is flexibility.
	It allows different parts of your AI to share knowledge and
	make decisions based on shared or global data.
	For example, if a player is hidden (crouch), then all should
	AIs checks if a player is visible, unless overwrite (maybe AIs that can see hidden)
]]
local Blackboard
do
	Blackboard = setmetatable({}, {
		__tostring = function()
			return "Blackboard"
		end,
	})
	Blackboard.__index = Blackboard
	function Blackboard.new(...)
		local self = setmetatable({}, Blackboard)
		return self:constructor(...) or self
	end
	function Blackboard:constructor()
		self.data = {}
	end
	function Blackboard:set(key, value)
		self.data[key] = value
	end
	function Blackboard:get(key)
		return self.data[key]
	end
	function Blackboard:has(key)
		return self.data[key] ~= nil
	end
	function Blackboard:clear(key)
		self.data[key] = nil
	end
end
return nil
