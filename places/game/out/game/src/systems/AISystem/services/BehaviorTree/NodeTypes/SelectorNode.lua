-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BehaviorTreeNode = TS.import(script, game:GetService("ServerScriptService"), "SystemServices", "AISystem", "BehaviorTree", "NodeTypes", "BehaviorTreeNode").BehaviorTreeNode
local SelectorNode
do
	local super = BehaviorTreeNode
	SelectorNode = setmetatable({}, {
		__tostring = function()
			return "SelectorNode"
		end,
		__index = super,
	})
	SelectorNode.__index = SelectorNode
	function SelectorNode.new(...)
		local self = setmetatable({}, SelectorNode)
		return self:constructor(...) or self
	end
	function SelectorNode:constructor(children)
		super.constructor(self)
		self.children = children
	end
	function SelectorNode:execute()
		for _, child in ipairs(self.children) do
			if child:execute() then
				return true
			end
		end
		return false
	end
end
return {
	SelectorNode = SelectorNode,
}
