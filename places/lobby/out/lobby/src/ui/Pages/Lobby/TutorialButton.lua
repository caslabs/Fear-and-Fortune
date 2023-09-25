-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local _Context_LobbyHUD = TS.import(script, script.Parent.Parent.Parent, "routers", "Lobby", "Context-LobbyHUD")
local Context = _Context_LobbyHUD.Context
local Pages = _Context_LobbyHUD.Pages
-- Opens Friend Social Service GUI
local TutorialButton = function(props, _param)
	local useState = _param.useState
	local buttonText, setButtonText = useState("Play Tutorial")
	return Roact.createElement(Context.Consumer, {
		render = function(value)
			return Roact.createFragment({
				TutorialButton = Roact.createElement("Frame", {
					Size = UDim2.fromScale(0.1, 0.045),
					Position = UDim2.new(0.34, 0, 0.011, 0),
					AnchorPoint = Vector2.new(0, 0),
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
						Text = buttonText,
						FontSize = Enum.FontSize.Size8,
						Size = UDim2.fromScale(1, 1),
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						ZIndex = 5,
						BackgroundTransparency = 0.5,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						[Roact.Event.MouseButton1Click] = function()
							-- Open Tutorial Panel
							local index = Pages.tutorial
							if value.viewIndex == index then
								value.setPage(1)
							else
								value.setPage(index)
							end
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
		end,
	})
end
local default = Hooks.new(Roact)(TutorialButton)
return {
	default = default,
}
