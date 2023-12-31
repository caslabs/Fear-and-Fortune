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
	SoundKeys.UI_QUEUE_ENTER = 2
	_inverse[2] = "UI_QUEUE_ENTER"
	SoundKeys.UI_QUEUE_EXIT = 3
	_inverse[3] = "UI_QUEUE_EXIT"
	SoundKeys.UI_COUNTDOWN = 4
	_inverse[4] = "UI_COUNTDOWN"
	SoundKeys.UI_BACKPACK = 5
	_inverse[5] = "UI_BACKPACK"
	SoundKeys.SFX_TYPEWRITER = 6
	_inverse[6] = "SFX_TYPEWRITER"
	SoundKeys.SFX_INTRO_WALKIETALKIE = 7
	_inverse[7] = "SFX_INTRO_WALKIETALKIE"
	SoundKeys.SFX_SNOW_AMBIENCE = 8
	_inverse[8] = "SFX_SNOW_AMBIENCE"
	SoundKeys.SFX_SNOW_AMBIENCE_2 = 9
	_inverse[9] = "SFX_SNOW_AMBIENCE_2"
	SoundKeys.SFX_STAMINA_LOW_BREATHING = 10
	_inverse[10] = "SFX_STAMINA_LOW_BREATHING"
	SoundKeys.SFX_DEPLOY_MASK = 11
	_inverse[11] = "SFX_DEPLOY_MASK"
	SoundKeys.SFX_GAS_MASK_BREATHING = 12
	_inverse[12] = "SFX_GAS_MASK_BREATHING"
	SoundKeys.SFX_UNDEPLOY_MASK = 13
	_inverse[13] = "SFX_UNDEPLOY_MASK"
	SoundKeys.SFX_AIR_GASP = 14
	_inverse[14] = "SFX_AIR_GASP"
	SoundKeys.DIALOGUE_INTRO = 15
	_inverse[15] = "DIALOGUE_INTRO"
	SoundKeys.SFX_SNOW_AMBIENCE_MASK = 16
	_inverse[16] = "SFX_SNOW_AMBIENCE_MASK"
	SoundKeys.SFX_WHISPHER = 17
	_inverse[17] = "SFX_WHISPHER"
	SoundKeys.SFX_EARTHQUAKE = 18
	_inverse[18] = "SFX_EARTHQUAKE"
	SoundKeys.SFX_AIR_GASP_LONG = 19
	_inverse[19] = "SFX_AIR_GASP_LONG"
	SoundKeys.SFX_THUNDER = 20
	_inverse[20] = "SFX_THUNDER"
	SoundKeys.SFX_EL_GOBLINO = 21
	_inverse[21] = "SFX_EL_GOBLINO"
	SoundKeys.SFX_MR_KITTEN = 22
	_inverse[22] = "SFX_MR_KITTEN"
	SoundKeys.SFX_SELL = 23
	_inverse[23] = "SFX_SELL"
	SoundKeys.SFX_TRADE = 24
	_inverse[24] = "SFX_TRADE"
	SoundKeys.SFX_FAIL = 25
	_inverse[25] = "SFX_FAIL"
end
local SoundData = {
	[SoundKeys.UI_CLOSE] = "6895079853",
	[SoundKeys.UI_QUEUE_ENTER] = "7278182233",
	[SoundKeys.UI_QUEUE_EXIT] = "9119720940",
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
	[SoundKeys.SFX_THUNDER] = "6734393210",
	[SoundKeys.UI_COUNTDOWN] = "2610939724",
	[SoundKeys.UI_BACKPACK] = "6876127372",
	[SoundKeys.SFX_EL_GOBLINO] = "5881854931",
	[SoundKeys.SFX_MR_KITTEN] = "3136676504",
	[SoundKeys.SFX_SELL] = "13868761623",
	[SoundKeys.SFX_TRADE] = "13868761623",
	[SoundKeys.SFX_FAIL] = "13868761623",
}
return {
	SoundKeys = SoundKeys,
	SoundData = SoundData,
}
