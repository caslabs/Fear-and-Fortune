-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
-- TODO: going 8 or more makes UI skulls out of place. thankfully it's max 7 for now, looks ok.
local Morale = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local prevMorale, setPrevMorale = useState(props.morale)
	local showOverlay, setShowOverlay = useState(false)
	-- might be useful later - morale checker
	useEffect(function()
		-- check if morale has been increased
		if props.morale > prevMorale then
			setShowOverlay(true)
			-- set a timeout to hide the overlay after a short delay
			local _exp = TS.Promise.delay(2)
			local _arg0 = function()
				return setShowOverlay(false)
			end
			_exp:andThen(_arg0)
		end
		-- update previous morale value
		setPrevMorale(props.morale)
	end, { props.morale })
	local createMoraleIcons = function()
		local minScale = 0.15
		local maxScale = 0.5
		local scale = 1 / props.morale
		-- make sure scale is within the min-max range
		if scale > maxScale then
			scale = maxScale
		end
		if scale < minScale then
			scale = minScale
		end
		local icons = {}
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < props.morale) then
					break
				end
				local _arg0 = Roact.createFragment({
					["MoraleIcon-" .. tostring(i)] = Roact.createElement("ImageLabel", {
						Image = "rbxassetid://6127325184",
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(i * scale, 0, 0.5, 0),
						Size = UDim2.new(scale, 0, 0.5, 0),
						BackgroundTransparency = 1,
						ImageTransparency = 0.5,
					}),
				})
				table.insert(icons, _arg0)
			end
		end
		return icons
	end
	local _attributes = {
		Position = UDim2.new(0.98, 0, 0.99, 0),
		Size = UDim2.new(0.15, 0, 0.15, 0),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
	}
	local _children = {}
	local _length = #_children
	for _k, _v in ipairs(createMoraleIcons()) do
		_children[_length + _k] = _v
	end
	return Roact.createFragment({
		Morale = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(Morale)
return {
	default = default,
}
