-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local CreditScreen = TS.import(script, script.Parent.Parent.Parent, "screens", "credit-screen")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
-- Credit Screen Button
local CreditsButton = function(props, _param)
	local useState = _param.useState
	local buttonText, setButtonText = useState("Invite Friends")
	return Roact.createFragment({
		CreditScreenButton = Roact.createElement("Frame", {
			Size = UDim2.fromScale(0.15, 0.035),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 0,
			BorderColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 1,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		}, {
			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = "Vertical",
				VerticalAlignment = "Top",
				SortOrder = "LayoutOrder",
			}),
			Button = Roact.createElement("TextButton", {
				Text = "Credits",
				FontSize = Enum.FontSize.Size8,
				TextSize = 8,
				Size = UDim2.fromScale(1, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				ZIndex = 5,
				BackgroundTransparency = 0.5,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				[Roact.Event.MouseButton1Click] = function()
					-- Credits
					local handle = Roact.mount(Roact.createFragment({
						ExitScreen = Roact.createElement("ScreenGui", {
							IgnoreGuiInset = true,
							ResetOnSpawn = false,
						}, {
							Roact.createElement(CreditScreen),
						}),
					}), PlayerGui)
					Signals.OnCreditScreenExit:Wait()
					Roact.unmount(handle)
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
			}),
		}),
	})
end
local default = Hooks.new(Roact)(CreditsButton)
return {
	default = default,
}
