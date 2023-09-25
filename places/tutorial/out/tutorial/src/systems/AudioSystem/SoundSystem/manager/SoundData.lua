-- Compiled with roblox-ts v1.3.3
local SoundKeys
do
	local _inverse = {}
	SoundKeys = setmetatable({}, {
		__index = _inverse,
	})
	SoundKeys.UI_CLOSE = 0
	_inverse[0] = "UI_CLOSE"
	SoundKeys.UI_OPEN = 1
	_inverse[1] = "UI_OPEN"
	SoundKeys.SFX_TYPEWRITER = 2
	_inverse[2] = "SFX_TYPEWRITER"
	SoundKeys.SFX_INTRO_WALKIETALKIE = 3
	_inverse[3] = "SFX_INTRO_WALKIETALKIE"
	SoundKeys.SFX_SNOW_AMBIENCE = 4
	_inverse[4] = "SFX_SNOW_AMBIENCE"
	SoundKeys.SFX_SNOW_AMBIENCE_2 = 5
	_inverse[5] = "SFX_SNOW_AMBIENCE_2"
	SoundKeys.SFX_STAMINA_LOW_BREATHING = 6
	_inverse[6] = "SFX_STAMINA_LOW_BREATHING"
	SoundKeys.SFX_DEPLOY_MASK = 7
	_inverse[7] = "SFX_DEPLOY_MASK"
	SoundKeys.SFX_GAS_MASK_BREATHING = 8
	_inverse[8] = "SFX_GAS_MASK_BREATHING"
	SoundKeys.SFX_UNDEPLOY_MASK = 9
	_inverse[9] = "SFX_UNDEPLOY_MASK"
	SoundKeys.SFX_AIR_GASP = 10
	_inverse[10] = "SFX_AIR_GASP"
	SoundKeys.DIALOGUE_INTRO = 11
	_inverse[11] = "DIALOGUE_INTRO"
	SoundKeys.SFX_SNOW_AMBIENCE_MASK = 12
	_inverse[12] = "SFX_SNOW_AMBIENCE_MASK"
	SoundKeys.SFX_WHISPHER = 13
	_inverse[13] = "SFX_WHISPHER"
	SoundKeys.SFX_EARTHQUAKE = 14
	_inverse[14] = "SFX_EARTHQUAKE"
	SoundKeys.SFX_AIR_GASP_LONG = 15
	_inverse[15] = "SFX_AIR_GASP_LONG"
	SoundKeys.DIALOGUE_1 = 16
	_inverse[16] = "DIALOGUE_1"
	SoundKeys.DIALOGUE_2 = 17
	_inverse[17] = "DIALOGUE_2"
	SoundKeys.DIALOGUE_3 = 18
	_inverse[18] = "DIALOGUE_3"
	SoundKeys.DIALOGUE_4 = 19
	_inverse[19] = "DIALOGUE_4"
end
local SoundData = {
	[SoundKeys.UI_CLOSE] = "6895079853",
	[SoundKeys.SFX_TYPEWRITER] = "9120299508",
	[SoundKeys.SFX_INTRO_WALKIETALKIE] = "13868838209",
	[SoundKeys.SFX_SNOW_AMBIENCE] = "167123203",
	[SoundKeys.SFX_SNOW_AMBIENCE_MASK] = "13868761623",
	[SoundKeys.SFX_SNOW_AMBIENCE_2] = "6670092634",
	[SoundKeys.SFX_STAMINA_LOW_BREATHING] = "13868760316",
	[SoundKeys.SFX_DEPLOY_MASK] = "9043349702",
	[SoundKeys.SFX_UNDEPLOY_MASK] = "9043349702",
	[SoundKeys.SFX_AIR_GASP] = "13868761724",
	[SoundKeys.SFX_AIR_GASP_LONG] = "13870675570",
	[SoundKeys.SFX_WHISPHER] = "13869003757",
	[SoundKeys.SFX_EARTHQUAKE] = "9114224721",
	[SoundKeys.DIALOGUE_1] = "13964704831",
	[SoundKeys.DIALOGUE_2] = "13964704471",
	[SoundKeys.DIALOGUE_3] = "13964704121",
	[SoundKeys.DIALOGUE_4] = "13964704675",
}
return {
	SoundKeys = SoundKeys,
	SoundData = SoundData,
}
