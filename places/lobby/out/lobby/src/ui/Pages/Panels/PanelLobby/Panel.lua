-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Context = TS.import(script, script.Parent.Parent.Parent.Parent, "routers", "Lobby", "Context-LobbyHUD").Context
-- Panel is a full-screen size frame that allows you to toggle visibility
-- for your toggles
local Panel
do
	Panel = Roact.Component:extend("Panel")
	function Panel:init(props)
		self:setState({
			panelVisible = false,
		})
	end
	function Panel:render()
		return Roact.createElement(Context.Consumer, {
			render = function(value)
				if self.state.panelVisible == true and value.viewIndex ~= self.props.index then
					self:setState({
						panelVisible = false,
					})
				elseif self.state.panelVisible == false and value.viewIndex == self.props.index then
					self:setState({
						panelVisible = true,
					})
				end
				local _attributes = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.new(30, 30, 30),
				}
				local _condition = self.props.visible
				if _condition == nil then
					_condition = self.state.panelVisible
				end
				_attributes.Visible = _condition
				local _children = {}
				local _length = #_children
				local _child = self.props[Roact.Children]
				if _child then
					for _k, _v in pairs(_child) do
						if type(_k) == "number" then
							_children[_length + _k] = _v
						else
							_children[_k] = _v
						end
					end
				end
				return Roact.createFragment({
					Panel = Roact.createElement("Frame", _attributes, _children),
				})
			end,
		})
	end
end
return {
	Panel = Panel,
}
