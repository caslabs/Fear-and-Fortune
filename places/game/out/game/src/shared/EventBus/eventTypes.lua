-- Compiled with roblox-ts v1.3.3
local GameEventType
do
	local _inverse = {}
	GameEventType = setmetatable({}, {
		__index = _inverse,
	})
	GameEventType.RandomDialogue = 0
	_inverse[0] = "RandomDialogue"
	GameEventType.JumpScare = 1
	_inverse[1] = "JumpScare"
	GameEventType.PlayerEnteredArea = 2
	_inverse[2] = "PlayerEnteredArea"
	GameEventType.Cutscene = 3
	_inverse[3] = "Cutscene"
	GameEventType.FX = 4
	_inverse[4] = "FX"
	GameEventType.PostProcessing = 5
	_inverse[5] = "PostProcessing"
	GameEventType.Notification = 6
	_inverse[6] = "Notification"
	GameEventType.AwardBadge = 7
	_inverse[7] = "AwardBadge"
	GameEventType.PlayerJoined = 8
	_inverse[8] = "PlayerJoined"
	GameEventType.PlayerLeft = 9
	_inverse[9] = "PlayerLeft"
	GameEventType.StartGame = 10
	_inverse[10] = "StartGame"
	GameEventType.GameInProgress = 11
	_inverse[11] = "GameInProgress"
	GameEventType.EndGame = 12
	_inverse[12] = "EndGame"
	GameEventType.WinGame = 13
	_inverse[13] = "WinGame"
	GameEventType.LoseGame = 14
	_inverse[14] = "LoseGame"
	GameEventType.ReturnToLobby = 15
	_inverse[15] = "ReturnToLobby"
end
return {
	GameEventType = GameEventType,
}
