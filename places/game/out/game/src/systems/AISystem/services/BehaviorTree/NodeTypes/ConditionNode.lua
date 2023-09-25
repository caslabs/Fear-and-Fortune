-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BehaviorTreeNode = TS.import(script, game:GetService("ServerScriptService"), "SystemServices", "AISystem", "BehaviorTree", "NodeTypes", "BehaviorTreeNode").BehaviorTreeNode
local ConditionNode
do
	local super = BehaviorTreeNode
	ConditionNode = setmetatable({}, {
		__tostring = function()
			return "ConditionNode"
		end,
		__index = super,
	})
	ConditionNode.__index = ConditionNode
	function ConditionNode.new(...)
		local self = setmetatable({}, ConditionNode)
		return self:constructor(...) or self
	end
	function ConditionNode:constructor(condition)
		super.constructor(self)
		self.condition = condition
	end
	function ConditionNode:execute()
		return self.condition()
	end
end
return {
	ConditionNode = ConditionNode,
}
