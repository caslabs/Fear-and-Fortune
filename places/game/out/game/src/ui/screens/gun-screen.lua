-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Player = Players.LocalPlayer
local GunScreen = function(props, _param)
	local useState = _param.useState
	local _binding = props
	local ammo = _binding.ammo
	local maxAmmo = _binding.maxAmmo
	return Roact.createFragment({
		GunScreen = Roact.createElement("ScreenGui", {
			DisplayOrder = 9999999,
		}, {
			AmmoIndicator = Roact.createElement("TextLabel", {
				Size = UDim2.new(0.2, 0, 0.1, 0),
				Position = UDim2.new(0, 20, 1, -50),
				TextScaled = true,
				Font = Enum.Font.SourceSansBold,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Text = tostring(ammo) .. ("/" .. tostring(maxAmmo)),
				AnchorPoint = Vector2.new(0, 1),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(GunScreen)
return {
	GunScreen = GunScreen,
	default = default,
}
