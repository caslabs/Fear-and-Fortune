-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Hooks = TS.import(script, TS.getModule(script, "@rbxts", "roact-hooks").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
-- PlayerItem.ts
local player = Players.LocalPlayer
local InvitePlayerToPartyEvent = Remotes.Client:Get("InvitePlayerToParty")
local PlayerItem = function(props, _param)
	local useState = _param.useState
	local invite, setInvite = useState("Invite")
	return Roact.createFragment({
		[props.name] = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundTransparency = 1,
		}, {
			Roact.createElement("TextLabel", {
				Text = props.name,
				Size = UDim2.fromScale(0.7, 1),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			}),
			Roact.createElement("TextButton", {
				Text = invite,
				Size = UDim2.fromScale(0.3, 1),
				TextSize = 15,
				Position = UDim2.fromScale(0.7, 0),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.SourceSansBold,
				Visible = props.isHost,
				[Roact.Event.MouseButton1Click] = function()
					local playerToInvite = Players:GetPlayerByUserId(props.player.UserId)
					if playerToInvite then
						InvitePlayerToPartyEvent:SendToServer(playerToInvite.UserId)
					end
					setInvite("Sent!")
					-- Revert the button text after 2 seconds
					wait(2)
					setInvite("Invite")
				end,
			}),
		}),
	})
end
local default = Hooks.new(Roact)(PlayerItem)
return {
	default = default,
}
