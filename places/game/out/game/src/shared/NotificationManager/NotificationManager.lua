-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Notification = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "NotificationManager", "notification")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local NotificationManager
do
	NotificationManager = setmetatable({}, {
		__tostring = function()
			return "NotificationManager"
		end,
	})
	NotificationManager.__index = NotificationManager
	function NotificationManager.new(...)
		local self = setmetatable({}, NotificationManager)
		return self:constructor(...) or self
	end
	function NotificationManager:constructor()
		self.notificationQueue = {}
		self.notificationActive = false
	end
	function NotificationManager:getInstance()
		if not self.instance then
			self.instance = NotificationManager.new()
		end
		return self.instance
	end
	function NotificationManager:enqueueNotification(data)
		local _notificationQueue = self.notificationQueue
		table.insert(_notificationQueue, data)
		self:processQueue()
	end
	function NotificationManager:processQueue()
		if self.notificationActive or #self.notificationQueue == 0 then
			return nil
		end
		self.notificationActive = true
		local data = table.remove(self.notificationQueue, 1)
		-- TODO: port over QuestUpdatePopup component
		local handle = Roact.mount(Roact.createFragment({
			ItemPopup = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
			}, {
				Roact.createElement(Notification, {
					title = data.title,
					description = data.description,
					image = "rbxassetid://" .. data.image,
				}),
			}),
		}), PlayerGui)
		wait(5)
		Roact.unmount(handle)
		self.notificationActive = false
		self:processQueue()
	end
end
return {
	NotificationManager = NotificationManager,
}
