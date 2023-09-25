-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
-- A function that updates the size of the scrolling frame
local function updateContentSize(scrollingFrame)
	local gridLayout = scrollingFrame:FindFirstChildWhichIsA("UIGridStyleLayout")
	if not gridLayout then
		error("No UIGridStyleLayout was found in " .. scrollingFrame:GetFullName())
	end
	local function resizeCanvas()
		scrollingFrame.CanvasSize = UDim2.fromOffset(gridLayout.AbsoluteContentSize.X, gridLayout.AbsoluteContentSize.Y)
	end
	gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeCanvas)
	resizeCanvas()
end
-- TODO: refactor to functional hook. Blocker: didMount()
-- Rescaling scrolling frame written by Overhash
local AutoScrollingFrame
do
	AutoScrollingFrame = Roact.Component:extend("AutoScrollingFrame")
	function AutoScrollingFrame:init(props)
		self.ref = Roact.createRef()
	end
	function AutoScrollingFrame:didMount()
		updateContentSize(self.ref:getValue())
	end
	function AutoScrollingFrame:render()
		local _attributes = {}
		for _k, _v in pairs(self.props) do
			_attributes[_k] = _v
		end
		_attributes[Roact.Ref] = self.ref
		return Roact.createFragment({
			DynamicScrollingFrame = Roact.createElement("ScrollingFrame", _attributes),
		})
	end
end
return {
	AutoScrollingFrame = AutoScrollingFrame,
}
