-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BehaviorTreeNode = TS.import(script, game:GetService("ServerScriptService"), "SystemServices", "AISystem", "BehaviorTree", "NodeTypes", "BehaviorTreeNode").BehaviorTreeNode
local ActionNode
do
	local super = BehaviorTreeNode
	ActionNode = setmetatable({}, {
		__tostring = function()
			return "ActionNode"
		end,
		__index = super,
	})
	ActionNode.__index = ActionNode
	function ActionNode.new(...)
		local self = setmetatable({}, ActionNode)
		return self:constructor(...) or self
	end
	function ActionNode:constructor(action)
		super.constructor(self)
		self.action = action
	end
	function ActionNode:execute()
		return self.action()
	end
end
return {
	ActionNode = ActionNode,
}
