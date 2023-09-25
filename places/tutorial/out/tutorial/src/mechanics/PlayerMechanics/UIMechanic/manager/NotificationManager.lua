-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, TS.getModule(script, "@rbxts", "roact").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Notification = TS.import(script, game:GetService("ReplicatedStorage"), "MechanicsManager", "NotificationsManager", "notification")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
-- TODO: We haven't used this yet, but we will need to use this to queue notifications
-- As it will overlap the notifications. We should queue them and then display them one at a time
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
	function NotificationManager:enqueueNotification()
		local _ = #self.notificationQueue
		self:processQueue()
	end
	function NotificationManager:processQueue()
		-- If a notification is active or the queue is empty, do nothing
		if self.notificationActive or #self.notificationQueue == 0 then
			return nil
		end
		-- Set the flag to true as we are about to display a notification
		self.notificationActive = true
		-- Get the next notification in the queue
		local data = table.remove(self.notificationQueue, 1)
		-- Play the current notification
		local handle = Roact.mount(Roact.createFragment({
			Land = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
			}, {
				Roact.createElement(Notification, {
					title = "Sherpa's Village",
				}),
			}),
		}), PlayerGui)
		wait(5)
		Roact.unmount(handle)
		-- Process the next item in the queue
		self.notificationActive = false
		self:processQueue()
	end
end
return {
	NotificationManager = NotificationManager,
}
