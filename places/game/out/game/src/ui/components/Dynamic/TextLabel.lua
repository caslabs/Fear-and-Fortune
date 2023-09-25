-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local TextService = TS.import(script, TS.getModule(script, "@rbxts", "services")).TextService
-- A function that updates the size of a text label
local function updateContentSize(textLabel)
	local function resizeLabel()
		local labelSize = TextService:GetTextSize(textLabel.Text, textLabel.TextSize, textLabel.Font, Vector2.new(500, textLabel.AbsoluteSize.Y))
		textLabel.Size = UDim2.fromOffset(labelSize.X, textLabel.AbsoluteSize.Y)
	end
	textLabel:GetPropertyChangedSignal("Text"):Connect(resizeLabel)
	resizeLabel()
end
-- TODO: refactor to functional hook. Blocker: didMount()
local AutoTextLabel
do
	AutoTextLabel = Roact.Component:extend("AutoTextLabel")
	function AutoTextLabel:init(props)
		self.ref = Roact.createRef()
	end
	function AutoTextLabel:didMount()
		updateContentSize(self.ref:getValue())
	end
	function AutoTextLabel:render()
		local _attributes = {}
		for _k, _v in pairs(self.props) do
			_attributes[_k] = _v
		end
		_attributes[Roact.Ref] = self.ref
		return Roact.createFragment({
			DynamicTextLabel = Roact.createElement("TextLabel", _attributes),
		})
	end
end
return {
	AutoTextLabel = AutoTextLabel,
}
