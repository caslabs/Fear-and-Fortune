-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
-- TODO: This component uses Context from lobby. Needs to be independent.
local Context = TS.import(script, script.Parent.Parent.Parent.Parent, "routers", "Lobby", "Context-LobbyHUD").Context
-- Blur Panel for NoticeBoard
local BlurPanel = function(props, _param)
	local useState = _param.useState
	local panelVisible, setPanelVisible = useState(false)
	return Roact.createElement(Context.Consumer, {
		render = function(value)
			if panelVisible == true and value.viewIndex ~= props.index then
				setPanelVisible(false)
			elseif panelVisible == false and value.viewIndex == props.index then
				setPanelVisible(true)
			end
			local _attributes = {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
			}
			local _condition = props.opacity
			if _condition == nil then
				_condition = 0.5
			end
			_attributes.BackgroundTransparency = _condition
			_attributes.BorderSizePixel = 0
			_attributes.BackgroundColor3 = Color3.new(30, 30, 30)
			local _condition_1 = props.visible
			if _condition_1 == nil then
				_condition_1 = panelVisible
			end
			_attributes.Visible = _condition_1
			local _children = {}
			local _length = #_children
			local _child = props[Roact.Children]
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
				["BlurPanel-NoticeBoard"] = Roact.createElement("Frame", _attributes, _children),
			})
		end,
	})
end
local default = Hooks.new(Roact)(BlurPanel)
return {
	default = default,
}
