-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
-- client/controllers/EventController.ts
local Controller = TS.import(script, TS.getModule(script, "@flamework", "core").out).Controller
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local EventManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "EventManager").EventManager
local GameEventType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "eventTypes").GameEventType
local EventCutsceneManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "events", "eventCutscene").EventCutsceneManager
local EventFx = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "events", "eventFX").EventFx
local EventJumpScareManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "events", "eventJumpscare").EventJumpScareManager
local EventPostProcessing = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "events", "eventPostProcessing").EventPostProcessing
local RandomDialogueManager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "events", "eventDialogue").RandomDialogueManager
local EventNotification = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "EventBus", "events", "eventNotification").EventNotification
local EventController
do
	EventController = setmetatable({}, {
		__tostring = function()
			return "EventController"
		end,
	})
	EventController.__index = EventController
	function EventController.new(...)
		local self = setmetatable({}, EventController)
		return self:constructor(...) or self
	end
	function EventController:constructor()
		self.eventManager = EventManager:getInstance()
		local randomDialogueManager = RandomDialogueManager.new(self.eventManager)
		local eventJumpScareManager = EventJumpScareManager.new(self.eventManager)
		local eventCutsceneManager = EventCutsceneManager.new(self.eventManager)
		local fxManager = EventFx.new(self.eventManager)
		local eventPostProcessing = EventPostProcessing.new(self.eventManager)
		local eventNotification = EventNotification.new(self.eventManager)
	end
	function EventController:onInit()
	end
	function EventController:onStart()
		-- this.initializeInputListeners();
		print("EventController started")
	end
	function EventController:initializeInputListeners()
		Players.LocalPlayer:GetMouse().KeyDown:Connect(function(key)
			if key == "v" or key == "V" then
				-- Example: Trigger a random dialogue event with a dialogueId
				self.eventManager:dispatchEvent(GameEventType.Notification, {
					title = "Example Title",
					description = "This is an example description.",
					image = "1543617734",
				})
			end
		end)
		Players.LocalPlayer:GetMouse().KeyDown:Connect(function(key)
			if key == "l" or key == "L" then
				-- Example: Trigger a random dialogue event with a dialogueId
				self.eventManager:dispatchEvent(GameEventType.RandomDialogue, {
					dialogueId = "D1",
				})
			end
		end)
		Players.LocalPlayer:GetMouse().KeyDown:Connect(function(key)
			if key == "" or key == "" then
				-- Example: Trigger a random dialogue event
				self.eventManager:dispatchEvent(GameEventType.JumpScare, {
					jumpscare = "",
				})
			end
		end)
		Players.LocalPlayer:GetMouse().KeyDown:Connect(function(key)
			if key == "f" or key == "F" then
				-- Trigger a cutscene event with a cutsceneId
				print("Cutscene")
				self.eventManager:dispatchEvent(GameEventType.Cutscene, {
					cutsceneId = "A1Objective2",
				})
			end
		end)
		Players.LocalPlayer:GetMouse().KeyDown:Connect(function(key)
			if key == "j" or key == "J" then
				-- Trigger a cutscene event with a cutsceneId
				self.eventManager:dispatchEvent(GameEventType.FX, {
					fxId = "glitch",
				})
			end
		end)
		Players.LocalPlayer:GetMouse().KeyDown:Connect(function(key)
			if key == "g" or key == "G" then
				-- Trigger a post-processing event with the jumpscare state
				self.eventManager:dispatchEvent(GameEventType.PostProcessing, {
					state = "jumpscare",
				})
			end
		end)
		-- ... other input listeners for triggering events
	end
end
-- (Flamework) EventController metadata
Reflect.defineMetadata(EventController, "identifier", "game/src/mechanics/PlayerMechanics/_Prototype/SelfDamageMechanic/controller/event-controller@EventController")
Reflect.defineMetadata(EventController, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(EventController, "$:flamework@Controller", Controller, { {} })
return {
	default = EventController,
}
