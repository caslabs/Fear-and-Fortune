-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
-- TODO: Input State
local TextInput = function(props, _param)
	local useState = _param.useState
	local input, setInput = useState("")
	local _attributes = {
		[Roact.Ref] = props.someRef,
	}
	for _k, _v in pairs(props.onTextChange) do
		_attributes[Roact.Change[_k]] = _v
	end
	_attributes.PlaceholderText = "Enter Friend Name"
	_attributes.PlaceholderColor3 = Color3.new(0.4, 0.4, 0.4)
	return Roact.createElement("TextBox", _attributes)
end
local default = Hooks.new(Roact)(TextInput)
return {
	default = default,
}
