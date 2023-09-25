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
	SoundKeys.SFX_PORTAL_EXIT = 16
	_inverse[16] = "SFX_PORTAL_EXIT"
	SoundKeys.SFX_DAY_1 = 17
	_inverse[17] = "SFX_DAY_1"
	SoundKeys.SFX_INTRO = 18
	_inverse[18] = "SFX_INTRO"
	SoundKeys.SFX_CRAFT = 19
	_inverse[19] = "SFX_CRAFT"
	SoundKeys.SFX_CHASING_1 = 20
	_inverse[20] = "SFX_CHASING_1"
	SoundKeys.SFX_FAIL = 21
	_inverse[21] = "SFX_FAIL"
	SoundKeys.SFX_RIFLE_SHOT = 22
	_inverse[22] = "SFX_RIFLE_SHOT"
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
	[SoundKeys.SFX_PORTAL_EXIT] = "13983704227",
	[SoundKeys.SFX_DAY_1] = "14005679798",
	[SoundKeys.SFX_INTRO] = "14005756404",
	[SoundKeys.SFX_CRAFT] = "321581454",
	[SoundKeys.SFX_CHASING_1] = "14031275784",
	[SoundKeys.SFX_FAIL] = "13868761623",
	[SoundKeys.SFX_RIFLE_SHOT] = "7935556153",
}
return {
	SoundKeys = SoundKeys,
	SoundData = SoundData,
}
