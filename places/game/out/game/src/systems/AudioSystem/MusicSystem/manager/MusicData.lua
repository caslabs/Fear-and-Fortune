-- Compiled with roblox-ts v1.3.3
local MusicKeys
do
	local _inverse = {}
	MusicKeys = setmetatable({}, {
		__index = _inverse,
	})
	MusicKeys.INTRODUCTION_MUSIC = 0
	_inverse[0] = "INTRODUCTION_MUSIC"
	MusicKeys.DEATH_MUSIC = 1
	_inverse[1] = "DEATH_MUSIC"
	MusicKeys.TIK_TOK = 2
	_inverse[2] = "TIK_TOK"
end
local MusicData = {
	[MusicKeys.INTRODUCTION_MUSIC] = "13868762411",
	[MusicKeys.DEATH_MUSIC] = "13874999247",
	[MusicKeys.TIK_TOK] = "13871000866",
}
return {
	MusicKeys = MusicKeys,
	MusicData = MusicData,
}
