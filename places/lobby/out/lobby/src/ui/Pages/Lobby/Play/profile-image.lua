-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local function GetUserThumbnailAsync(userId)
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size420x420
	return Players:GetUserThumbnailAsync(tonumber(userId), thumbType, thumbSize)
end
local ProfileImage = function(props, _param)
	local useEffect = _param.useEffect
	local useState = _param.useState
	return Roact.createFragment({
		["GridImageComponent-Image-4"] = Roact.createElement("Frame", {
			Size = UDim2.fromScale(0.1, 0.1),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(245, 245, 245),
		}, {
			Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.fromScale(0.85, 0.85),
				Position = UDim2.fromScale(0.5, 0.05),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.27, 0.23, 0.23),
				BorderSizePixel = 0,
				Image = (GetUserThumbnailAsync(tostring(props.data.UserId))),
			}, {
				Roact.createElement("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 0.8,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(60, 72, 0),
				}),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(ProfileImage)
return {
	default = default,
}
