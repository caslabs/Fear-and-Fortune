-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local characters = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "DialogueManager", "characters").characters
local dialogues = { {
	id = "D1",
	type = "CharacterToCharacter",
	character1 = characters[1],
	character2 = characters[2],
	lines = { "I need to get this gate working." },
}, {
	id = "D2",
	type = "CharacterToCharacter",
	character1 = characters[1],
	character2 = characters[2],
	lines = { "I got the gate working!" },
}, {
	id = "S1",
	type = "CharacterToCharacter",
	character1 = characters[2],
	character2 = characters[1],
	lines = { "...Heeds my words, adventurer. Now cometh the time of reckoning of the gods." },
} }
return {
	dialogues = dialogues,
}
