export enum SoundKeys {
	UI_CLOSE,
	UI_OPEN,
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
	SFX_PORTAL_EXIT,
	SFX_DAY_1,
	SFX_INTRO,
	SFX_CRAFT,
	SFX_CHASING_1,
	SFX_FAIL,
	SFX_RIFLE_SHOT,
	// Add as many as needed...
}

export const SoundData: Map<SoundKeys, string> = new Map([
	[SoundKeys.UI_CLOSE, "6895079853"],
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
	[SoundKeys.SFX_PORTAL_EXIT, "13983704227"],
	[SoundKeys.SFX_DAY_1, "14005679798"],
	[SoundKeys.SFX_INTRO, "14005756404"],
	[SoundKeys.SFX_CRAFT, "321581454"],
	[SoundKeys.SFX_CHASING_1, "14031275784"],
	[SoundKeys.SFX_FAIL, "13868761623"], //TODO: Add FAIL SFX
	[SoundKeys.SFX_RIFLE_SHOT, "7935556153"],
	// Add as many as needed...
]);

//rbxasset://textures/particles/sparkles_main.dds
