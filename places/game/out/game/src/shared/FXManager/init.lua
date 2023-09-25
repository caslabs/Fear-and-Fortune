-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local fxTemplates = {
	glitch = {
		assetIds = { 434633166, 434633194, 434633220, 434633258, 434639717 },
		duration = 0.1,
	},
	dark = {
		assetIds = { 987654, 321098, 765432 },
		duration = 0.8,
	},
}
local FXManager
do
	FXManager = setmetatable({}, {
		__tostring = function()
			return "FXManager"
		end,
	})
	FXManager.__index = FXManager
	function FXManager.new(...)
		local self = setmetatable({}, FXManager)
		return self:constructor(...) or self
	end
	function FXManager:constructor()
	end
	function FXManager:getInstance()
		if not FXManager.instance then
			FXManager.instance = FXManager.new()
		end
		return FXManager.instance
	end
	function FXManager:playFX(eventData)
		local _templateId = eventData.templateId
		local template = fxTemplates[_templateId]
		if not template then
			warn('FX template with ID "' .. (eventData.templateId .. '" not found.'))
			return nil
		end
		local player = Players.LocalPlayer
		local playerGui = player:WaitForChild("PlayerGui")
		-- Create a new ScreenGui to display the images
		local screenGui = Instance.new("ScreenGui")
		screenGui.Parent = playerGui
		screenGui.ResetOnSpawn = false
		-- Create a series of ImageLabels to display the assets
		local _assetIds = template.assetIds
		local _arg0 = function(assetId)
			local imageLabel = Instance.new("ImageLabel")
			imageLabel.Parent = screenGui
			imageLabel.BackgroundTransparency = 1
			imageLabel.Size = UDim2.new(1, 0, 1, 0)
			imageLabel.Position = UDim2.new(0, 0, 0, 0)
			imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			imageLabel.Image = "rbxassetid://" .. tostring(assetId)
			imageLabel.Visible = false
			return imageLabel
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#_assetIds)
		for _k, _v in ipairs(_assetIds) do
			_newValue[_k] = _arg0(_v, _k - 1, _assetIds)
		end
		-- ▲ ReadonlyArray.map ▲
		local imageLabels = _newValue
		-- Play the sequence of images with the given duration between frames
		local currentIndex = 0
		local playNextImage
		playNextImage = function()
			if currentIndex < #imageLabels then
				-- Hide the previous image and show the next one
				if currentIndex > 0 then
					imageLabels[currentIndex - 1 + 1].Visible = false
				end
				imageLabels[currentIndex + 1].Visible = true
				-- Schedule the next image to be shown after the specified duration
				currentIndex += 1
				wait(template.duration)
				playNextImage()
			else
				-- All images have been shown, clean up and exit
				screenGui:Destroy()
			end
		end
		-- Start the sequence with the first image
		imageLabels[1].Visible = true
		playNextImage()
		print("FX played")
	end
end
return {
	FXManager = FXManager,
}
