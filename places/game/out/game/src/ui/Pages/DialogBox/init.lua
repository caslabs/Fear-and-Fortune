-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local _Context = TS.import(script, script.Parent.Parent, "Context")
local Context = _Context.Context
local Pages = _Context.Pages
local Panel = TS.import(script, script.Parent.Parent, "Panels", "Panel").Panel
local setIsCurrentlyOpen = TS.import(script, script.Parent, "Shop", "shop-manager").setIsCurrentlyOpen
local CloseShop = TS.import(script, script.Parent.Parent, "Panels", "Close-Shop").default
-- TODO: Designing a Dialog Tree - Graph ADT
-- see https://developer.roblox.com/en-us/articles/Designing-a-Dialog-Tree
local DialogBox = function(props, _param)
	local useState = _param.useState
	local useEffect = _param.useEffect
	local text, setText = useState("")
	local fullText, setFullText = useState("What can I do for you?")
	print("DialogBox initialized")
	-- TODO: Polish text animation
	useEffect(function()
		task.spawn(function()
			local _exp = string.split(fullText, "")
			local _arg0 = function(char)
				task.wait(0.015)
				setText(function(prev)
					return prev .. char
				end)
			end
			for _k, _v in ipairs(_exp) do
				_arg0(_v, _k - 1, _exp)
			end
		end)
	end, {})
	return Roact.createElement(Context.Consumer, {
		render = function(value)
			return Roact.createFragment({
				Shop = Roact.createElement(Panel, {
					index = Pages.dialog,
					visible = props.visible,
				}, {
					DialogBox = Roact.createElement("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(70, 70, 70),
						BorderSizePixel = 0,
						Position = UDim2.new(0.5, 0, 0.6, 0),
						Size = UDim2.new(0, 504, 0, 150),
					}, {
						["1"] = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 6),
						}),
						["2"] = Roact.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, 12),
							PaddingLeft = UDim.new(0, 12),
							PaddingRight = UDim.new(0, 12),
							PaddingTop = UDim.new(0, 12),
						}),
						Roact.createElement(CloseShop),
						DialogText = Roact.createElement("Frame", {
							AnchorPoint = Vector2.new(0, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 1, 0),
							Size = UDim2.new(1, 0, 1, -46),
						}, {
							ScrollignFrame = Roact.createElement("ScrollingFrame", {
								BackgroundTransparency = 1,
								CanvasPosition = Vector2.new(0, 20),
								CanvasSize = UDim2.new(0, 468, 0, 150),
								HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
								LayoutOrder = 1,
								ScrollBarThickness = 10,
								ScrollingDirection = Enum.ScrollingDirection.Y,
								Size = UDim2.new(1, 0, 0.8, 0),
							}, {
								ShopDialog = Roact.createElement("TextButton", {
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									Font = Enum.Font.SourceSans,
									LayoutOrder = 0,
									Size = UDim2.new(0, 200, 0, 30),
									Text = "Show me your goodies",
									TextColor3 = Color3.fromRGB(0, 0, 0),
									TextSize = 14,
									[Roact.Event.MouseButton1Click] = function()
										-- TODO: Clicking the shop toggle button should close the dialog box? Only makes the blurry effect.
										local index = Pages.merchant
										value.setPage(index)
									end,
								}),
								ChatDialog = Roact.createElement("TextButton", {
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									Font = Enum.Font.SourceSans,
									LayoutOrder = 1,
									Size = UDim2.new(0, 200, 0, 30),
									Text = "What's the top news today?",
									[Roact.Event.MouseButton1Click] = function()
										-- TODO: Prototype of chat box sequence. Double Click initializes and Spam Clicking results in a bug.
										task.spawn(function()
											local _exp = string.split(fullText, "")
											local _arg0 = function(char)
												task.wait(0.015)
												setText(function(prev)
													return prev .. char
												end)
											end
											for _k, _v in ipairs(_exp) do
												_arg0(_v, _k - 1, _exp)
											end
										end)
									end,
									TextColor3 = Color3.fromRGB(0, 0, 0),
									TextSize = 14,
								}),
								AboutDialog = Roact.createElement("TextButton", {
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									Font = Enum.Font.SourceSans,
									LayoutOrder = 2,
									Size = UDim2.new(0, 200, 0, 30),
									Text = "Who are you again?",
									TextColor3 = Color3.fromRGB(0, 0, 0),
									TextSize = 14,
								}),
								Roact.createElement("UIListLayout", {
									Padding = UDim.new(0, 2),
									SortOrder = Enum.SortOrder.LayoutOrder,
								}),
								GoodbyeDialogue = Roact.createElement("TextButton", {
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									Font = Enum.Font.SourceSans,
									LayoutOrder = 999,
									Size = UDim2.new(0, 200, 0, 30),
									Text = "Goodbye",
									TextColor3 = Color3.fromRGB(0, 0, 0),
									TextSize = 14,
									[Roact.Event.MouseButton1Click] = function()
										value.setPage(Pages.none)
										setIsCurrentlyOpen(false)
										-- sound.Play();
									end,
								}),
							}),
							Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								Font = Enum.Font.SourceSans,
								Size = UDim2.new(1, 0, 0.3, 0),
								Text = text,
								TextColor3 = Color3.fromRGB(0, 0, 0),
								TextSize = 25,
								TextXAlignment = Enum.TextXAlignment.Left,
							}),
							Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
							}),
						}),
					}),
				}),
			})
		end,
	})
end
local default = Hooks.new(Roact)(DialogBox)
return {
	default = default,
}
