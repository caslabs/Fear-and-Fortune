-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local Make = TS.import(script, TS.getModule(script, "@rbxts", "make"))
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local DialogueBox = TS.import(script, game:GetService("ReplicatedStorage"), "SystemsManager", "DialogueSystem", "dialogue-box")
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local NPCComponent
do
	local super = BaseComponent
	NPCComponent = setmetatable({}, {
		__tostring = function()
			return "NPCComponent"
		end,
		__index = super,
	})
	NPCComponent.__index = NPCComponent
	function NPCComponent.new(...)
		local self = setmetatable({}, NPCComponent)
		return self:constructor(...) or self
	end
	function NPCComponent:constructor(...)
		super.constructor(self, ...)
	end
	function NPCComponent:onStart()
		local agentModel = self.instance
		local humanoidRootPart = agentModel:FindFirstChild("Torso")
		print("NPC-1 Component Initiated")
		print("NPC-1 Component Initiated on " .. (self.instance.Name .. (" (" .. (self.instance.ClassName .. ")"))))
		if not t.instanceIsA("BasePart")(humanoidRootPart) then
			print("Unable to find HumanoidRootPart in the NPC-1 model")
			return nil
		end
		print("Found part:", humanoidRootPart.Name)
		local prompt = self:attachProximityPrompt(humanoidRootPart)
		print("NPC-1 prompt enabled")
		self.maid:GiveTask(prompt.Triggered:Connect(function()
			-- Trigger Random Dialogue event
			-- TODO: design database for random dialogues
			local handle = Roact.mount(Roact.createFragment({
				DialogueBoxScreen = Roact.createElement("ScreenGui", {
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
				}, {
					Roact.createElement(DialogueBox, {
						title = "",
						description = "Hello, fellow adventurer...",
						image = "",
					}),
				}),
			}), PlayerGui)
			wait(5)
			Roact.unmount(handle)
		end))
	end
	function NPCComponent:attachProximityPrompt(humanoidRootPart)
		return Make("ProximityPrompt", {
			ObjectText = "The Stange One",
			ActionText = "Talk",
			Parent = humanoidRootPart,
		})
	end
end
-- (Flamework) NPCComponent metadata
Reflect.defineMetadata(NPCComponent, "identifier", "tutorial/src/systems/NarrartiveSystem/CharacterSystem/NPCSystem/components/npc-1@NPCComponent")
Reflect.defineMetadata(NPCComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(NPCComponent, "$c:init@Component", Component, { {
	tag = "NPC-1Trigger",
	instanceGuard = t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model")),
	attributes = {},
} })
return {
	NPCComponent = NPCComponent,
}
