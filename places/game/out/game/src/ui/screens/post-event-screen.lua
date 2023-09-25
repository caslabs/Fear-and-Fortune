-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local player = Players.LocalPlayer
local ExtractToLobbyEvent = Remotes.Client:Get("ExtractToLobby")
-- Shows the notice board upon on joined in lobby place
local PostEventScreen = function(props, _param)
	local useState = _param.useState
	return Roact.createFragment({
		PostEventScreen = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(504, 360),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(70, 70, 70),
		}, {
			Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 6),
			}),
			Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
			}),
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ScrollBarThickness = 6,
				AutomaticCanvasSize = "Y",
				CanvasSize = UDim2.fromScale(0, 1),
			}, {
				Roact.createElement("UIListLayout", {
					SortOrder = "LayoutOrder",
					HorizontalAlignment = "Center",
					FillDirection = "Vertical",
					Padding = UDim.new(0.05, 0),
				}),
				Title = Roact.createElement("TextLabel", {
					Text = "You can safely leave the game now!",
					TextSize = 24,
					Font = Enum.Font.Garamond,
					ZIndex = 999,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0.2),
					LayoutOrder = -1,
					TextColor3 = Color3.fromRGB(255, 255, 255),
				}),
				SubTitle = Roact.createElement("TextLabel", {
					Text = "Stop Spectating and Return To Lobby?",
					TextSize = 20,
					Font = Enum.Font.Garamond,
					ZIndex = 999,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0.2),
					LayoutOrder = 0,
					TextColor3 = Color3.fromRGB(255, 255, 255),
				}),
				LobbyButton = Roact.createElement("TextButton", {
					Text = "Return To Lobby",
					LayoutOrder = 2,
					FontSize = Enum.FontSize.Size8,
					Size = UDim2.fromScale(0.3, 0.2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					ZIndex = 5,
					BackgroundTransparency = 0.5,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					[Roact.Event.MouseButton1Click] = function()
						ExtractToLobbyEvent:SendToServer(player)
						print("Extracting to lobby button triggered...")
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
				SpectatingButtton = Roact.createElement("TextButton", {
					Text = "Keep Spectating",
					LayoutOrder = 1,
					FontSize = Enum.FontSize.Size8,
					Size = UDim2.fromScale(0.3, 0.2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					ZIndex = 5,
					BackgroundTransparency = 0.5,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					[Roact.Event.MouseButton1Click] = function()
						Signals.OnExitScreenClosed:Fire()
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
			Close = Roact.createElement("TextButton", {
				Text = "",
				Size = UDim2.fromOffset(40, 40),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				[Roact.Event.MouseButton1Click] = function()
					Signals.OnExitScreenClosed:Fire()
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
					Image = "http://www.roblox.com/asset/?id=5107150301",
					Size = UDim2.fromScale(1, 1),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
				}),
			}),
		}),
	})
end
local default = Hooks.new(Roact)(PostEventScreen)
return {
	default = default,
}
