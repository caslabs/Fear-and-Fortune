-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BehaviorTreeNode = TS.import(script, game:GetService("ServerScriptService"), "SystemServices", "AISystem", "BehaviorTree", "NodeTypes", "BehaviorTreeNode").BehaviorTreeNode
local SequenceNode
do
	local super = BehaviorTreeNode
	SequenceNode = setmetatable({}, {
		__tostring = function()
			return "SequenceNode"
		end,
		__index = super,
	})
	SequenceNode.__index = SequenceNode
	function SequenceNode.new(...)
		local self = setmetatable({}, SequenceNode)
		return self:constructor(...) or self
	end
	function SequenceNode:constructor(children)
		super.constructor(self)
		self.children = children
	end
	function SequenceNode:execute()
		for _, child in ipairs(self.children) do
			if not child:execute() then
				return false
			end
		end
		return true
	end
end
return {
	SequenceNode = SequenceNode,
}
