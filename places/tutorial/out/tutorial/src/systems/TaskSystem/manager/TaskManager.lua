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
		self.currentDay = 1
	end
	function TaskManager:startDay()
		-- Get the objective for the current day
		local objective = params.objectives[self.currentDay - 1 + 1]
		sendMessage:SendToAllPlayers("Day " .. (tostring(self.currentDay) .. (": " .. objective)))
	end
	function TaskManager:completeObjective()
		-- Check if there are more objectives
		if self.currentDay < #params.objectives then
			self:startDay()
			self.currentDay += 1
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
