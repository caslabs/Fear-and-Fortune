-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
-- TODO: Fix the naming convention and system structure
-- TODO: Call Sound, rather than spawn sound
local sound = Instance.new("Sound", game.Workspace)
sound.SoundId = "rbxassetid://6895079853"
sound.Volume = 1
-- A generic toggle on the side of the screen used to open an associated panel
local Toggle = function(props, _param)
	local useState = _param.useState
	return Roact.createFragment({
		Toggle = Roact.createElement("TextButton", {
			Text = props.caption,
			Size = props.size or UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			LayoutOrder = props.layout,
			BackgroundTransparency = 0.7,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			[Roact.Event.MouseButton1Click] = function()
				sound:Play()
				props.onClick()
			end,
		}, {
			Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 6),
			}),
			Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6),
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
			}),
			Icon = Roact.createElement("ImageLabel", {
				Image = props.image,
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
			}),
		}),
	})
end
local default = Hooks.new(Roact)(Toggle)
return {
	default = default,
}
