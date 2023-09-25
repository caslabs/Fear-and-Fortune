-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
-- client/components/LandmarkComponent.ts
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local DialogueBox = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "DialogueSystem", "dialogue-box")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local DialogueTriggerComponent
do
	local super = BaseComponent
	DialogueTriggerComponent = setmetatable({}, {
		__tostring = function()
			return "DialogueTriggerComponent"
		end,
		__index = super,
	})
	DialogueTriggerComponent.__index = DialogueTriggerComponent
	function DialogueTriggerComponent.new(...)
		local self = setmetatable({}, DialogueTriggerComponent)
		return self:constructor(...) or self
	end
	function DialogueTriggerComponent:constructor()
		super.constructor(self)
		self.playersInZone = {}
		self.notifiedPlayers = {}
		self.debounce = false
	end
	function DialogueTriggerComponent:onStart()
		print("DialogueTrigger Component Initiated")
		self.instance.Touched:Connect(function(part)
			return self:onTouch(part)
		end)
		self.instance.TouchEnded:Connect(function(part)
			return self:onTouchEnd(part)
		end)
	end
	function DialogueTriggerComponent:onTouch(part)
		local player = Players:GetPlayerFromCharacter(part.Parent)
		if player and (not (self.playersInZone[player] ~= nil) and not (self.notifiedPlayers[player] ~= nil)) then
			self.playersInZone[player] = true
			self.notifiedPlayers[player] = true
			if not self.debounce then
				self.debounce = true
				self:showNotification(player)
				print("Dialogue Box Showing Notification")
				local _exp = TS.Promise.delay(1)
				local _arg0 = function()
					self.debounce = false
					return self.debounce
				end
				_exp:andThen(_arg0)
			end
		end
	end
	function DialogueTriggerComponent:onTouchEnd(part)
		local player = Players:GetPlayerFromCharacter(part.Parent)
		if player then
			self.playersInZone[player] = nil
		end
	end
	function DialogueTriggerComponent:showNotification(player)
		-- TODO: TEMP, need an event manager to handle these if statements
		if self.attributes.dialogue == "?!?!" then
		end
		local _exp = TS.Promise.delay(0.1)
		local _arg0 = function()
			local handle = Roact.mount(Roact.createFragment({
				DialogueBoxScreen = Roact.createElement("ScreenGui", {
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
				}, {
					Roact.createElement(DialogueBox, {
						title = "",
						description = self.attributes.dialogue,
						image = "",
					}),
				}),
			}), PlayerGui)
			wait(5)
			Roact.unmount(handle)
		end
		_exp:andThen(_arg0)
	end
end
-- (Flamework) DialogueTriggerComponent metadata
Reflect.defineMetadata(DialogueTriggerComponent, "identifier", "tutorial/src/systems/NarrartiveSystem/DialogueSystem/components/dialogue-trigger-component@DialogueTriggerComponent")
Reflect.defineMetadata(DialogueTriggerComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(DialogueTriggerComponent, "$c:init@Component", Component, { {
	tag = "DialogueTrigger",
	instanceGuard = t.instanceIsA("BasePart"),
	attributes = {
		dialogue = t.string,
	},
} })
return {
	DialogueTriggerComponent = DialogueTriggerComponent,
}
