-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local TaskManager = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "TaskSystem", "TaskManager").TaskManager
local CompleteObjectiveEvent = Remotes.Server:Get("CompleteObjectiveEvent")
local TaskSystemService
do
	TaskSystemService = setmetatable({}, {
		__tostring = function()
			return "TaskSystemService"
		end,
	})
	TaskSystemService.__index = TaskSystemService
	function TaskSystemService.new(...)
		local self = setmetatable({}, TaskSystemService)
		return self:constructor(...) or self
	end
	function TaskSystemService:constructor()
		self.taskManager = TaskManager.new()
	end
	function TaskSystemService:onStart()
		print("TaskSystem Service Started")
	end
	function TaskSystemService:startNextObjective()
		self.taskManager:startNextObjective()
	end
end
-- (Flamework) TaskSystemService metadata
Reflect.defineMetadata(TaskSystemService, "identifier", "game/src/systems/TaskSystem/services/task-service@TaskSystemService")
Reflect.defineMetadata(TaskSystemService, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(TaskSystemService, "$:flamework@Service", Service, { {} })
return {
	default = TaskSystemService,
}
