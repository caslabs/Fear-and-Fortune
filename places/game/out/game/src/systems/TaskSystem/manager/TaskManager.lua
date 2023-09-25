-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local params = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "TaskSystem", "parameters").params
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local sendMessage = Remotes.Server:Get("SendMessage")
-- TODO: Might be useful for Boss System
local TaskManager
do
	TaskManager = setmetatable({}, {
		__tostring = function()
			return "TaskManager"
		end,
	})
	TaskManager.__index = TaskManager
	function TaskManager.new(...)
		local self = setmetatable({}, TaskManager)
		return self:constructor(...) or self
	end
	function TaskManager:constructor()
		self.currentObjective = 1
	end
	function TaskManager:completeObjective()
		-- Get the objective for the current day
		local objective = params.objectives[self.currentObjective + 1]
		sendMessage:SendToAllPlayers("Next Objective: " .. objective)
	end
	function TaskManager:startNextObjective()
		-- Check if there are more objectives
		if self.currentObjective < #params.objectives then
			self:completeObjective()
			self.currentObjective += 1
		else
			sendMessage:SendToAllPlayers("Congratulations, you've completed all objectives and won the game!")
		end
	end
	function TaskManager:failObjective()
		sendMessage:SendToAllPlayers("You failed to complete the objective and lost the game.")
	end
end
return {
	TaskManager = TaskManager,
}
