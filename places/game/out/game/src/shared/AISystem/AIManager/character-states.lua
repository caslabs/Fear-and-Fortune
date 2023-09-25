-- Compiled with roblox-ts v1.3.3
-- shared/PlayerStates.ts
local PlayerStates
do
	local _inverse = {}
	PlayerStates = setmetatable({}, {
		__index = _inverse,
	})
	PlayerStates.Normal = 0
	_inverse[0] = "Normal"
	PlayerStates.Sprinting = 1
	_inverse[1] = "Sprinting"
	PlayerStates.Chasing = 2
	_inverse[2] = "Chasing"
	PlayerStates.Crouching = 3
	_inverse[3] = "Crouching"
	PlayerStates.Hiding = 4
	_inverse[4] = "Hiding"
	PlayerStates.Hacked = 5
	_inverse[5] = "Hacked"
end
local default = PlayerStates
return {
	default = default,
}
