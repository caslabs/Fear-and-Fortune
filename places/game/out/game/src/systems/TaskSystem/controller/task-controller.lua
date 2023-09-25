-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local UserInputService = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local TaskSystemController
do
	TaskSystemController = setmetatable({}, {
		__tostring = function()
			return "TaskSystemController"
		end,
	})
	TaskSystemController.__index = TaskSystemController
	function TaskSystemController.new(...)
		local self = setmetatable({}, TaskSystemController)
		return self:constructor(...) or self
	end
	function TaskSystemController:constructor()
	end
	function TaskSystemController:onInit()
	end
	function TaskSystemController:onStart()
		local completeObjective = Remotes.Client:Get("CompleteObjectiveEvent")
		local sendMessage = Remotes.Client:Get("SendMessage")
		print("TaskSystem Controller started")
		UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.T then
				local _exp = completeObjective:CallServerAsync()
				local _arg0 = function() end
				_exp:andThen(_arg0)
			end
		end)
		sendMessage:Connect(function(message)
			print(message)
		end)
	end
end
-- (Flamework) TaskSystemController metadata
Reflect.defineMetadata(TaskSystemController, "identifier", "game/src/systems/TaskSystem/controller/task-controller@TaskSystemController")
Reflect.defineMetadata(TaskSystemController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(TaskSystemController, "$:flamework@Controller", Controller, {})
return {
	default = TaskSystemController,
}
