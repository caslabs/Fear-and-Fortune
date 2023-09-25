local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LOADING_SCREEN"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
screenGui.DisplayOrder = -99999


local MapImage = Instance.new("ImageLabel")
MapImage.Size = UDim2.new(1, 0, 1,0)
MapImage.BackgroundTransparency = 0
MapImage.AnchorPoint = Vector2.new(0, 0)
MapImage.Position = UDim2.new(0, 0, 0, 0)
MapImage.BackgroundColor3 = Color3.new(0,0,0)
MapImage.Parent = screenGui

ReplicatedFirst:RemoveDefaultLoadingScreen()
if not game:IsLoaded() then
 game.Loaded:Wait()
end
