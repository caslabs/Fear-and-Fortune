-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local ItemPopup = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "NotificationManager", "notification")
local DialogueBox = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "DialogueManager", "dialogue-box")
local _sound_manager = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "sound-manager")
local Dialogue = _sound_manager.Dialogue
local SoundManager = _sound_manager.SoundManager
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local DialogueManager
do
	DialogueManager = setmetatable({}, {
		__tostring = function()
			return "DialogueManager"
		end,
	})
	DialogueManager.__index = DialogueManager
	function DialogueManager.new(...)
		local self = setmetatable({}, DialogueManager)
		return self:constructor(...) or self
	end
	function DialogueManager:constructor(dialogues)
		self.dialogues = dialogues
		self.currentDialogue = nil
		self.currentLineIndex = -1
		-- Initialize any necessary resources
		self.soundManager = SoundManager:getInstance()
	end
	function DialogueManager:startDialogue(dialogueId)
		local _dialogues = self.dialogues
		local _arg0 = function(d)
			return d.id == dialogueId
		end
		-- ▼ ReadonlyArray.find ▼
		local _result
		for _i, _v in ipairs(_dialogues) do
			if _arg0(_v, _i - 1, _dialogues) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local dialogue = _result
		if dialogue then
			self.currentDialogue = dialogue
			self.currentLineIndex = 0
			local character = dialogue.character1.name
			local line = dialogue.lines[self.currentLineIndex + 1]
			print("About to be Mounted")
			local CHARACTERS_PER_SECOND = 10
			local unmountDelay = #self.currentDialogue.lines[self.currentLineIndex + 1] / CHARACTERS_PER_SECOND
			local totalDelay = unmountDelay + 5
			-- TODO: Poorly Optimized. Keeps calling it!
			local handle = Roact.mount(Roact.createFragment({
				DialogPopup = Roact.createElement("ScreenGui", {
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
				}, {
					Roact.createElement(DialogueBox, {
						title = character,
						description = line,
						image = "",
					}),
				}),
			}), PlayerGui)
			print("Mounted")
			self.soundManager:LoadSound({
				fileName = Dialogue[dialogueId],
				soundName = dialogueId,
				volume = 10,
			})
			self.soundManager:PlaySound(dialogueId)
			local _exp = TS.Promise.delay(totalDelay)
			local _arg0_1 = function()
				Roact.unmount(handle)
			end
			_exp:andThen(_arg0_1)
			local advanceLines
			advanceLines = function()
				local _exp_1 = self.currentLineIndex
				local _result_1 = self.currentDialogue
				if _result_1 ~= nil then
					_result_1 = #_result_1.lines
				end
				local _condition = _result_1
				if _condition == nil then
					_condition = 0
				end
				if _exp_1 < _condition - 1 then
					self.currentLineIndex += 1
					local line = self.currentDialogue.lines[self.currentLineIndex + 1]
					TS.Promise.delay(1):andThen(advanceLines)
					local handle = Roact.mount(Roact.createFragment({
						DialogPopup = Roact.createElement("ScreenGui", {
							IgnoreGuiInset = true,
							ResetOnSpawn = false,
						}, {
							Roact.createElement(ItemPopup, {
								title = "Test",
								description = line,
								image = "",
							}),
						}),
					}), PlayerGui)
					print("Mounted")
					local _exp_2 = TS.Promise.delay(5)
					local _arg0_2 = function()
						Roact.unmount(handle)
					end
					_exp_2:andThen(_arg0_2)
				else
					self:endDialogue()
				end
			end
			TS.Promise.delay(1):andThen(advanceLines)
		else
			warn("Dialogue with id '" .. (dialogueId .. "' not found."))
		end
	end
	function DialogueManager:advanceDialogue()
		local _condition = self.currentDialogue
		if _condition then
			local _exp = self.currentLineIndex
			local _condition_1 = #self.currentDialogue.lines
			if _condition_1 == nil then
				_condition_1 = 0
			end
			_condition = _exp < _condition_1 - 1
		end
		if _condition then
			self.currentLineIndex += 1
			local line = self.currentDialogue.lines[self.currentLineIndex + 1]
			local handle = Roact.mount(Roact.createFragment({
				DialogPopup = Roact.createElement("ScreenGui", {
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
				}, {
					Roact.createElement(ItemPopup, {
						title = "Test",
						description = line,
						image = "",
					}),
				}),
			}), PlayerGui)
			print("Mounted")
			local _exp = TS.Promise.delay(5)
			local _arg0 = function()
				Roact.unmount(handle)
			end
			_exp:andThen(_arg0)
		else
			print("No dialogue to advance or already at the end of the dialogue.")
		end
	end
	function DialogueManager:endDialogue()
		if self.currentDialogue then
			print("Dialogue ended.")
			self.currentDialogue = nil
			self.currentLineIndex = -1
		else
			print("No dialogue to end.")
		end
	end
end
return {
	DialogueManager = DialogueManager,
}
