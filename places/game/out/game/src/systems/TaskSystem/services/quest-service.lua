-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _quest = TS.import(script, game:GetService("ServerScriptService"), "SystemServices", "TaskSystem", "quest")
local QUEST_DATABASE = _quest.QUEST_DATABASE
local Quest = _quest.Quest
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
--[[
	This Quest System operates under DAG system
	works well for Linear, Open, and Pre-Req Quests
]]
local QuestSystemService
do
	QuestSystemService = setmetatable({}, {
		__tostring = function()
			return "QuestSystemService"
		end,
	})
	QuestSystemService.__index = QuestSystemService
	function QuestSystemService.new(...)
		local self = setmetatable({}, QuestSystemService)
		return self:constructor(...) or self
	end
	function QuestSystemService:constructor()
		self.quests = {}
		self.observers = {}
	end
	function QuestSystemService:onStart()
		self:loadQuestsFromDatabase(QUEST_DATABASE)
		print("QuestSystem Service Started")
	end
	function QuestSystemService:loadQuestsFromDatabase(data)
		for _, questData in ipairs(data.quests) do
			local quest = Quest.new(questData.id, questData.name, "")
			quest.prerequisites = questData.prerequisites
			local _quests = self.quests
			local _id = quest.id
			_quests[_id] = quest
		end
	end
	function QuestSystemService:addQuestObserver(observer)
		local _observers = self.observers
		table.insert(_observers, observer)
	end
	function QuestSystemService:completeQuest(id)
		local quest = self.quests[id]
		if not quest then
			print("Quest not found.")
			return nil
		end
		local _prerequisites = quest.prerequisites
		local _arg0 = function(prereqId)
			local _result = self.quests[prereqId]
			if _result ~= nil then
				_result = _result.completed
			end
			return _result
		end
		-- ▼ ReadonlyArray.every ▼
		local _result = true
		for _k, _v in ipairs(_prerequisites) do
			if not _arg0(_v, _k - 1, _prerequisites) then
				_result = false
				break
			end
		end
		-- ▲ ReadonlyArray.every ▲
		local prerequisitesCompleted = _result
		if not prerequisitesCompleted then
			print("Cannot complete " .. (quest.name .. " yet. Prerequisites not met."))
			return nil
		end
		quest.completed = true
		print(quest.name .. " completed!")
		for _, observer in ipairs(self.observers) do
			observer:onQuestCompleted(id)
		end
	end
end
-- (Flamework) QuestSystemService metadata
Reflect.defineMetadata(QuestSystemService, "identifier", "game/src/systems/TaskSystem/services/quest-service@QuestSystemService")
Reflect.defineMetadata(QuestSystemService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(QuestSystemService, "$:flamework@Service", Service, { {} })
local GameEvent
do
	local _inverse = {}
	GameEvent = setmetatable({}, {
		__index = _inverse,
	})
	GameEvent.SpawnBoss = 0
	_inverse[0] = "SpawnBoss"
	GameEvent.OpenGate = 1
	_inverse[1] = "OpenGate"
	GameEvent.PlayCutscene = 2
	_inverse[2] = "PlayCutscene"
end
local EVENT_DATABASE = {
	fightBoss = { GameEvent.SpawnBoss },
}
local GameEventHandler
do
	GameEventHandler = setmetatable({}, {
		__tostring = function()
			return "GameEventHandler"
		end,
	})
	GameEventHandler.__index = GameEventHandler
	function GameEventHandler.new(...)
		local self = setmetatable({}, GameEventHandler)
		return self:constructor(...) or self
	end
	function GameEventHandler:constructor()
	end
	function GameEventHandler:onQuestCompleted(questId)
		local eventsToTrigger = EVENT_DATABASE[questId]
		if eventsToTrigger then
			for _, gameEvent in ipairs(eventsToTrigger) do
				repeat
					if gameEvent == (GameEvent.SpawnBoss) then
						print("Spawning the boss...")
						-- Call the function to spawn the boss
						break
					end
				until true
			end
		end
	end
end
return {
	default = QuestSystemService,
}
