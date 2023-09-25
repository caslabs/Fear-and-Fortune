export enum SoundKeys {
	UI_CLOSE,
	UI_OPEN,
	UI_QUEUE_ENTER,
	UI_QUEUE_EXIT,
	UI_COUNTDOWN,
	UI_BACKPACK,
	SFX_TYPEWRITER,
	SFX_INTRO_WALKIETALKIE,
	SFX_SNOW_AMBIENCE,
	SFX_SNOW_AMBIENCE_2,
	SFX_STAMINA_LOW_BREATHING,
	SFX_DEPLOY_MASK,
	SFX_GAS_MASK_BREATHING,
	SFX_UNDEPLOY_MASK,
	SFX_AIR_GASP,
	DIALOGUE_INTRO,
	SFX_SNOW_AMBIENCE_MASK,
	SFX_WHISPHER,
	SFX_EARTHQUAKE,
	SFX_AIR_GASP_LONG,
	SFX_THUNDER,
	SFX_EL_GOBLINO,
	SFX_MR_KITTEN,
	SFX_SELL,
	SFX_TRADE,
	SFX_FAIL,
	// Add as many as needed...
}

export const SoundData: Map<SoundKeys, string> = new Map([
	[SoundKeys.UI_CLOSE, "6895079853"],
	[SoundKeys.UI_QUEUE_ENTER, "7278182233"],
	[SoundKeys.UI_QUEUE_EXIT, "9119720940"],
	[SoundKeys.SFX_TYPEWRITER, "9120299508"],
	[SoundKeys.SFX_INTRO_WALKIETALKIE, "13868838209"],
	[SoundKeys.SFX_SNOW_AMBIENCE, "167123203"],
	[SoundKeys.SFX_SNOW_AMBIENCE_MASK, "13868761623"],
	[SoundKeys.SFX_SNOW_AMBIENCE_2, "6670092634"],
	[SoundKeys.SFX_STAMINA_LOW_BREATHING, "13868760316"],
	[SoundKeys.SFX_DEPLOY_MASK, "9043349702"],
	[SoundKeys.SFX_UNDEPLOY_MASK, "9043349702"],
	[SoundKeys.SFX_AIR_GASP, "13868761724"],
	[SoundKeys.SFX_AIR_GASP_LONG, "13870675570"],
	[SoundKeys.SFX_WHISPHER, "13869003757"],
	[SoundKeys.SFX_EARTHQUAKE, "9114224721"],
	[SoundKeys.SFX_THUNDER, "6734393210"],
	[SoundKeys.UI_COUNTDOWN, "2610939724"],
	[SoundKeys.UI_BACKPACK, "6876127372"],
	[SoundKeys.SFX_EL_GOBLINO, "5881854931"],
	[SoundKeys.SFX_MR_KITTEN, "3136676504"],
	[SoundKeys.SFX_SELL, "13868761623"],
	[SoundKeys.SFX_TRADE, "13868761623"],
	[SoundKeys.SFX_FAIL, "13868761623"],
	// Add as many as needed...
]);

//rbxasset://textures/particles/sparkles_main.dds