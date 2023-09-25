-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
-- TODO: This component uses Context from lobby. Needs to be independent.
local _Context = TS.import(script, script.Parent.Parent, "Context")
local Context = _Context.Context
local Pages = _Context.Pages
-- Close the page with this button, sets the value to 0 (0 = none)
local Close = function(props, _param)
	local useState = _param.useState
	return Roact.createElement(Context.Consumer, {
		render = function(value)
			return Roact.createFragment({
				Close = Roact.createElement("TextButton", {
					Text = "",
					Size = UDim2.fromOffset(40, 40),
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.fromScale(1, 0),
					BackgroundColor3 = Color3.fromRGB(45, 45, 45),
					[Roact.Event.MouseButton1Click] = function()
						value.setPage(Pages.none)
						-- TODO: Blur should be created here, and not be called in Lighting?
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
			})
		end,
	})
end
local default = Hooks.new(Roact)(Close)
return {
	default = default,
}
