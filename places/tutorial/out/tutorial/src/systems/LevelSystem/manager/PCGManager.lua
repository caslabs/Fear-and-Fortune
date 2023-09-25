-- Compiled with roblox-ts v1.3.3
local PCGManager
do
	PCGManager = setmetatable({}, {
		__tostring = function()
			return "PCGManager"
		end,
	})
	PCGManager.__index = PCGManager
	function PCGManager.new(...)
		local self = setmetatable({}, PCGManager)
		return self:constructor(...) or self
	end
	function PCGManager:constructor()
	end
end
return {
	PCGManager = PCGManager,
}
