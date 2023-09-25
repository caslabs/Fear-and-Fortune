-- Compiled with roblox-ts v1.3.3
local SoundSystem
do
	SoundSystem = setmetatable({}, {
		__tostring = function()
			return "SoundSystem"
		end,
	})
	SoundSystem.__index = SoundSystem
	function SoundSystem.new(...)
		local self = setmetatable({}, SoundSystem)
		return self:constructor(...) or self
	end
	function SoundSystem:constructor()
	end
end
return {
	SoundSystem = SoundSystem,
}
