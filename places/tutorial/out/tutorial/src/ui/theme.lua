-- Compiled with roblox-ts v1.3.3
-- Front End Configs for UI
-- TODO: Dark Mode Feature?
-- TODO: UI overhaul based on a global theme;
-- https://www.npmjs.com/package/@rbxts/rich-text-stream
local Theme = {}
do
	local _container = Theme
	-- Palette
	local White = Color3.new(1, 1, 1)
	_container.White = White
	local Black = Color3.new(0, 0, 0)
	_container.Black = Black
	-- Typography
	local FontPrimary = Enum.Font.GothamBlack
	_container.FontPrimary = FontPrimary
	local FontSecondary = Enum.Font.GothamBlack
	_container.FontSecondary = FontSecondary
	local FontNormal = Enum.Font.Gotham
	_container.FontNormal = FontNormal
end
local default = Theme
return {
	default = default,
}
