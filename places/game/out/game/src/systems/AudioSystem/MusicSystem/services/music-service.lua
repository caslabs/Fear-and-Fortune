-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local MusicSystemService
do
	MusicSystemService = setmetatable({}, {
		__tostring = function()
			return "MusicSystemService"
		end,
	})
	MusicSystemService.__index = MusicSystemService
	function MusicSystemService.new(...)
		local self = setmetatable({}, MusicSystemService)
		return self:constructor(...) or self
	end
	function MusicSystemService:constructor()
	end
	function MusicSystemService:onStart()
		print("MusicSystem Service Started")
		local playMusic = Remotes.Server:Get("PlayMusic")
		local requestMusicPlay = Remotes.Server:Get("RequestMusicPlay")
		-- Send Music to all players
		requestMusicPlay:Connect(function(player)
			print("Playing requested music from player " .. player.Name)
			-- playMusic.SendToAllPlayers("9047504196");
		end)
	end
end
-- (Flamework) MusicSystemService metadata
Reflect.defineMetadata(MusicSystemService, "identifier", "game/src/systems/AudioSystem/MusicSystem/services/music-service@MusicSystemService")
Reflect.defineMetadata(MusicSystemService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(MusicSystemService, "$:flamework@Service", Service, { {} })
return {
	default = MusicSystemService,
}
