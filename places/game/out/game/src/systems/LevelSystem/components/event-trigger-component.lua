-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
-- client/components/LandmarkComponent.ts
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local Workspace = _services.Workspace
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local SoundSystemController = TS.import(script, script.Parent.Parent.Parent, "SystemsController", "SoundSystem", "sound-system-controller").default
local MusicSystemController = TS.import(script, script.Parent.Parent.Parent, "SystemsController", "MusicSystem", "music-controller").default
local CameraShaker = TS.import(script, TS.getModule(script, "@caslabs", "roblox-modified-camera-shaker").CameraShaker)
local DialogueBox = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "DialogueSystem", "dialogue-box")
local SoundKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "SoundSystem", "SoundData").SoundKeys
local MusicKeys = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "MusicSystem", "MusicData").MusicKeys
local Signals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "signals").Signals
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame = camera.CFrame * shakeCFrame
	return camera.CFrame
end)
local EventTriggerComponent
do
	local super = BaseComponent
	EventTriggerComponent = setmetatable({}, {
		__tostring = function()
			return "EventTriggerComponent"
		end,
		__index = super,
	})
	EventTriggerComponent.__index = EventTriggerComponent
	function EventTriggerComponent.new(...)
		local self = setmetatable({}, EventTriggerComponent)
		return self:constructor(...) or self
	end
	function EventTriggerComponent:constructor()
		super.constructor(self)
		self.playersInZone = {}
		self.notifiedPlayers = {}
		self.debounce = false
	end
	function EventTriggerComponent:onStart()
		print("EventTrigger Component Initiated")
		self.instance.Touched:Connect(function(part)
			return self:onTouch(part)
		end)
		self.instance.TouchEnded:Connect(function(part)
			return self:onTouchEnd(part)
		end)
	end
	function EventTriggerComponent:onTouch(part)
		local player = Players:GetPlayerFromCharacter(part.Parent)
		if player and (not (self.playersInZone[player] ~= nil) and not (self.notifiedPlayers[player] ~= nil)) then
			self.playersInZone[player] = true
			self.notifiedPlayers[player] = true
			if not self.debounce then
				self.debounce = true
				self:onEvent(player)
				print("Triggering Event")
				local _exp = TS.Promise.delay(1)
				local _arg0 = function()
					self.debounce = false
					return self.debounce
				end
				_exp:andThen(_arg0)
			end
		end
	end
	function EventTriggerComponent:onTouchEnd(part)
		local player = Players:GetPlayerFromCharacter(part.Parent)
		if player then
			self.playersInZone[player] = nil
		end
	end
	EventTriggerComponent.onEvent = TS.async(function(self, player)
		-- TODO: TEMP, need an event manager to handle these if statements
		if self.attributes.ID == "JUMPSCARE" then
			camShake:Start()
			-- TODO: temporarily hack - cannot access SoundSystem, must use remote events.
			SoundSystemController:playSound(SoundKeys.SFX_EARTHQUAKE, 10)
			-- TODO: Should use the NotificationManager
			-- ?!?! Dialogue
			local handle = Roact.mount(Roact.createFragment({
				DialogueBoxScreen = Roact.createElement("ScreenGui", {
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
				}, {
					Roact.createElement(DialogueBox, {
						title = "",
						description = "You: I'm not alone here....",
						image = "",
					}),
				}),
			}), PlayerGui)
			camShake:Shake(CameraShaker.Presets.Explosion)
			TS.await(TS.Promise.delay(5))
			camShake:Stop()
		elseif self.attributes.ID == "WHISPHER" then
			SoundSystemController:playSound(SoundKeys.SFX_WHISPHER, 10)
			print("WHISPHER")
			Signals.enableJumpScareEvent:Fire()
		elseif self.attributes.ID == "TIK_TOK" then
			MusicSystemController:playMusic(MusicKeys.TIK_TOK)
		end
	end)
end
-- (Flamework) EventTriggerComponent metadata
Reflect.defineMetadata(EventTriggerComponent, "identifier", "game/src/systems/LevelSystem/components/event-trigger-component@EventTriggerComponent")
Reflect.defineMetadata(EventTriggerComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(EventTriggerComponent, "$c:init@Component", Component, { {
	tag = "EventTrigger",
	instanceGuard = t.instanceIsA("BasePart"),
	attributes = {
		ID = t.string,
	},
} })
return {
	EventTriggerComponent = EventTriggerComponent,
}
