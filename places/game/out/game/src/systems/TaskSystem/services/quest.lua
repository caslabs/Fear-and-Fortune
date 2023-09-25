-- Compiled with roblox-ts v1.3.3
local Quest
do
	Quest = setmetatable({}, {
		__tostring = function()
			return "Quest"
		end,
	})
	Quest.__index = Quest
	function Quest.new(...)
		local self = setmetatable({}, Quest)
		return self:constructor(...) or self
	end
	function Quest:constructor(id, name, description)
		self.prerequisites = {}
		self.completed = false
		self.id = id
		self.name = name
		self.description = description
	end
end
local QUEST_DATABASE = {
	quests = { {
		id = "ignite",
		name = "Ignite 5 candles",
		prerequisites = {},
	}, {
		id = "openDoor",
		name = "Open Captain's Door",
		prerequisites = { "ignite" },
	}, {
		id = "takeBook",
		name = "Take Book",
		prerequisites = { "openDoor" },
	}, {
		id = "takeGun",
		name = "Take Gun",
		prerequisites = { "openDoor" },
	}, {
		id = "takeSword",
		name = "Take Sword",
		prerequisites = { "openDoor" },
	}, {
		id = "fightBoss",
		name = "Fight Boss",
		prerequisites = { "takeBook", "takeGun", "takeSword" },
	} },
}
return {
	Quest = Quest,
	QUEST_DATABASE = QUEST_DATABASE,
}
