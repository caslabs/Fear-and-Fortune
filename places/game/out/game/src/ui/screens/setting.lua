-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Pages = TS.import(script, script.Parent.Parent, "Context").Pages
local Panel = TS.import(script, script.Parent.Parent, "Panels", "Panel").Panel
--[[
	Load from SettingMechanic
]]
local Setting = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local soundVolume, setSoundVolume = useState("10")
	local ambienceVolume, setAmbienceVolume = useState("10")
	local musicVolume, setMusicVolume = useState("10")
	local fov, setFov = useState("70")
	local textboxRef = Roact.createRef()
	return Roact.createFragment({
		Setting = Roact.createElement(Panel, {
			index = Pages.setting,
			visible = props.visible,
		}, {
			Roact.createElement("TextButton", {
				Modal = true,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 0),
			}),
			Setting = Roact.createElement("Frame", {
				Size = UDim2.new(0.4, 0, 0.7, 0),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BorderSizePixel = 0,
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(26, 26, 26),
			}, {
				Roact.createElement("ScrollingFrame", {
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ScrollBarThickness = 6,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				}, {
					Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						Padding = UDim.new(0, 4),
					}),
					Roact.createElement("TextLabel", {
						Text = "Audio",
						Size = UDim2.new(1, 0, 0, 30),
						FontSize = Enum.FontSize.Size24,
					}),
					Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 30),
						Position = UDim2.new(0, 0, 0.1, 0),
					}, {
						Roact.createElement("TextLabel", {
							Text = "Music",
							Size = UDim2.new(0.6, 0, 1, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
						}),
						Roact.createElement("TextBox", {
							Text = musicVolume,
							Size = UDim2.fromScale(0.2, 0.12),
							Position = UDim2.fromScale(0.3, 0.4),
							TextSize = 12,
							Font = Enum.Font.SourceSansBold,
							TextColor3 = Color3.fromRGB(200, 200, 200),
							BackgroundTransparency = 0.5,
							BackgroundColor3 = Color3.fromRGB(40, 40, 40),
							ClearTextOnFocus = true,
							[Roact.Ref] = textboxRef,
							TextWrapped = true,
						}),
					}),
					Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 30),
						Position = UDim2.new(0, 0, 0.1, 0),
					}, {
						Roact.createElement("TextLabel", {
							Text = "Sound",
							Size = UDim2.new(0.6, 0, 1, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
						}),
						Roact.createElement("TextBox", {
							Text = soundVolume,
							Size = UDim2.fromScale(0.2, 0.12),
							Position = UDim2.fromScale(0.3, 0.4),
							TextSize = 12,
							Font = Enum.Font.SourceSansBold,
							TextColor3 = Color3.fromRGB(200, 200, 200),
							BackgroundTransparency = 0.5,
							BackgroundColor3 = Color3.fromRGB(40, 40, 40),
							ClearTextOnFocus = true,
							[Roact.Ref] = textboxRef,
							TextWrapped = true,
						}),
					}),
					Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 30),
						Position = UDim2.new(0, 0, 0.1, 0),
					}, {
						Roact.createElement("TextLabel", {
							Text = "Ambience",
							Size = UDim2.new(0.6, 0, 1, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
						}),
						Roact.createElement("TextBox", {
							Text = ambienceVolume,
							Size = UDim2.fromScale(0.2, 0.12),
							Position = UDim2.fromScale(0.3, 0.4),
							TextSize = 12,
							Font = Enum.Font.SourceSansBold,
							TextColor3 = Color3.fromRGB(200, 200, 200),
							BackgroundTransparency = 0.5,
							BackgroundColor3 = Color3.fromRGB(40, 40, 40),
							ClearTextOnFocus = true,
							[Roact.Ref] = textboxRef,
							TextWrapped = true,
						}),
					}),
					Roact.createElement("TextLabel", {
						Text = "Game",
						Size = UDim2.new(1, 0, 0, 30),
						FontSize = Enum.FontSize.Size24,
					}),
					Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 30),
						Position = UDim2.new(0, 0, 0.1, 0),
					}, {
						Roact.createElement("TextLabel", {
							Text = "FOV",
							Size = UDim2.new(0.6, 0, 1, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
						}),
						Roact.createElement("TextBox", {
							Text = fov,
							Size = UDim2.fromScale(0.2, 0.12),
							Position = UDim2.fromScale(0.3, 0.4),
							TextSize = 12,
							Font = Enum.Font.SourceSansBold,
							TextColor3 = Color3.fromRGB(200, 200, 200),
							BackgroundTransparency = 0.5,
							BackgroundColor3 = Color3.fromRGB(40, 40, 40),
							ClearTextOnFocus = true,
							[Roact.Ref] = textboxRef,
							TextWrapped = true,
						}),
					}),
				}),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(Setting)
return {
	default = default,
}
