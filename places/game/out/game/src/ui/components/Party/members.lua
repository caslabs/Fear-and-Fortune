-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local GetUserThumbnailAsync = TS.async(function(userId)
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size420x420
	local result = TS.await({ Players:GetUserThumbnailAsync(tonumber(userId), thumbType, thumbSize) })
	return result[1]
end)
-- TODO: going 8 or more makes UI skulls out of place. thankfully it's max 7 for now, looks ok.
-- should be an API that gets the party members ID's
local user_ids = { "11697914", "682379885", "1341618742", "2847222519" }
local PartyMembers = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	-- 1. State Management
	--[[
		This will prevent blocking the main thread while we fetch the thumbnails.
	]]
	local _arg0 = function()
		return nil
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#user_ids)
	for _k, _v in ipairs(user_ids) do
		_newValue[_k] = _arg0(_v, _k - 1, user_ids)
	end
	-- ▲ ReadonlyArray.map ▲
	local thumbnails, setThumbnails = useState(_newValue)
	-- 2. UseEffect for Asynchronous Data Fetching
	useEffect(function()
		-- Use a traditional for-loop to have better control over async operations
		local loadThumbnails = TS.async(function()
			do
				local _i = 0
				local _shouldIncrement = false
				while true do
					local i = _i
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < #user_ids) then
						break
					end
					local id = user_ids[i + 1]
					local thumbnail = TS.await(GetUserThumbnailAsync(id))
					-- eslint-disable-next-line roblox-ts/lua-truthiness
					if thumbnail ~= "" and thumbnail then
						setThumbnails(function(prev)
							local _array = {}
							local _length = #_array
							table.move(prev, 1, #prev, _length + 1, _array)
							local updated = _array
							updated[i + 1] = thumbnail
							return updated
						end)
					end
					_i = i
				end
			end
		end)
		loadThumbnails()
	end, {})
	local _arg0_1 = function(thumbnail, index)
		local _attributes = {
			Size = UDim2.fromOffset(70, 70),
			ZIndex = 3,
		}
		local _condition = thumbnail
		if not (_condition ~= "" and _condition) then
			_condition = "rbxassetid://6127325184"
		end
		_attributes.Image = _condition
		_attributes.LayoutOrder = index
		return Roact.createElement("ImageLabel", _attributes)
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue_1 = table.create(#thumbnails)
	for _k, _v in ipairs(thumbnails) do
		_newValue_1[_k] = _arg0_1(_v, _k - 1, thumbnails)
	end
	-- ▲ ReadonlyArray.map ▲
	local _attributes = {
		Position = UDim2.new(0, 0, 0.8, 0),
		Size = UDim2.new(0.15, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = Color3.fromRGB(75, 75, 75),
		BackgroundTransparency = 1,
	}
	local _children = {
		Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	local _length = #_children
	for _k, _v in ipairs(_newValue_1) do
		_children[_length + _k] = _v
	end
	return Roact.createFragment({
		PartyMembers = Roact.createElement("Frame", _attributes, _children),
	})
end
local default = Hooks.new(Roact)(PartyMembers)
return {
	default = default,
}
