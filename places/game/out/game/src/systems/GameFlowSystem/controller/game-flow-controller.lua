-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local StarterGui = TS.import(script, TS.getModule(script, "@rbxts", "services")).StarterGui
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local PostEventScreen = TS.import(script, script.Parent.Parent.Parent, "ui", "screens", "post-event-screen").default
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UpdateExpeditionCountEvent = Remotes.Client:Get("UpdateExpeditionCount")
local GameFlowSystemController
do
	GameFlowSystemController = setmetatable({}, {
		__tostring = function()
			return "GameFlowSystemController"
		end,
	})
	GameFlowSystemController.__index = GameFlowSystemController
	function GameFlowSystemController.new(...)
		local self = setmetatable({}, GameFlowSystemController)
		return self:constructor(...) or self
	end
	function GameFlowSystemController:constructor(lifeMechanic, hudController, musicSystem)
		self.lifeMechanic = lifeMechanic
		self.hudController = hudController
		self.musicSystem = musicSystem
	end
	function GameFlowSystemController:onInit()
	end
	function GameFlowSystemController:onStart()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
		StarterGui:SetCore("ResetButtonCallback", false)
		-- Connect to the livesChanged signal
		self.lifeMechanic.livesChanged:Connect(function(lives)
			if lives <= 0 then
			end
		end)
		Signals.PlayerDied:Connect(function()
			self:transitionToSpectating()
			-- TODO: temporarily hack to show lobby if choose to stay
			local lobbyButton = Roact.mount(Roact.createFragment({
				LobbyScreen = Roact.createElement("ScreenGui", {
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
				}, {
					LobbyButton = Roact.createElement("TextButton", {
						Text = "Return To Lobby",
						LayoutOrder = 2,
						FontSize = Enum.FontSize.Size8,
						Size = UDim2.fromScale(0.15, 0.15),
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.new(0.5, 0, -0.001, 10),
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						ZIndex = 5,
						BackgroundTransparency = 0.5,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						[Roact.Event.MouseButton1Click] = function()
							local ExtractToLobbyEvent = Remotes.Client:Get("ExtractToLobby")
							ExtractToLobbyEvent:SendToServer(Player)
							print("Extracting to lobby button triggered...")
						end,
					}),
				}),
			}), PlayerGui)
		end)
		-- If Exit Portal is touched, transition to spectating
		Signals.ExitPortalTouched:Connect(function()
			self:transitionToSpectating()
			-- TODO: Show different Exit screen based on the amount of players
			-- If there is only one player, show the "No one's here" Screen
			-- If there is more than one player, show the "Spectate option" Screen
			-- TODO: Quick hack, make dedicated Context System for Spectating HUD
			local handle = Roact.mount(Roact.createFragment({
				ExitScreen = Roact.createElement("ScreenGui", {
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
				}, {
					Roact.createElement(PostEventScreen),
				}),
			}), PlayerGui)
			Signals.OnExitScreenClosed:Wait()
			-- TODO: Tell Server to increment successful_expedition
			Roact.unmount(handle)
			-- TODO: temporarily hack to show lobby if choose to stay
			local lobbyButton = Roact.mount(Roact.createFragment({
				LobbyScreen = Roact.createElement("ScreenGui", {
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
				}, {
					LobbyButton = Roact.createElement("TextButton", {
						Text = "Return To Lobby",
						LayoutOrder = 2,
						FontSize = Enum.FontSize.Size8,
						Size = UDim2.fromScale(0.15, 0.15),
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.new(0.5, 0, -0.001, 10),
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						ZIndex = 5,
						BackgroundTransparency = 0.5,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						[Roact.Event.MouseButton1Click] = function()
							local ExtractToLobbyEvent = Remotes.Client:Get("ExtractToLobby")
							ExtractToLobbyEvent:SendToServer(Player)
							print("Extracting to lobby button triggered...")
						end,
					}),
				}),
			}), PlayerGui)
		end)
		print("GameFlowSystem Controller started")
	end
	function GameFlowSystemController:transitionToSpectating()
		print("Transitioning to spectating...")
		-- Spectating Experience
		self.hudController:switchToSpectateHUD()
	end
	function GameFlowSystemController:transitionToPlaying()
		print("Transitioning to playing...")
		-- TODO: Somehow the player has more lives...
		-- Enable Respawn
		-- Transition to PlayHUD()
	end
end
-- (Flamework) GameFlowSystemController metadata
Reflect.defineMetadata(GameFlowSystemController, "identifier", "game/src/systems/GameFlowSystem/controller/game-flow-controller@GameFlowSystemController")
Reflect.defineMetadata(GameFlowSystemController, "flamework:parameters", { "game/src/mechanics/PlayerMechanics/LifeMechanic/controller/life-controller@LifeMechanic", "game/src/mechanics/PlayerMechanics/UIMechanic/controller/hud-controller@HUDController", "game/src/systems/AudioSystem/MusicSystem/controller/music-controller@MusicSystemController" })
Reflect.defineMetadata(GameFlowSystemController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(GameFlowSystemController, "$:flamework@Controller", Controller, {})
return {
	default = GameFlowSystemController,
}
