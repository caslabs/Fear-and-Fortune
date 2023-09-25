-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local TweenService = TS.import(script, TS.getModule(script, "@rbxts", "services")).TweenService
local PostProcessingManager
do
	PostProcessingManager = setmetatable({}, {
		__tostring = function()
			return "PostProcessingManager"
		end,
	})
	PostProcessingManager.__index = PostProcessingManager
	function PostProcessingManager.new(...)
		local self = setmetatable({}, PostProcessingManager)
		return self:constructor(...) or self
	end
	function PostProcessingManager:constructor()
		self.templates = {}
	end
	function PostProcessingManager:getInstance()
		if not PostProcessingManager.instance then
			PostProcessingManager.instance = PostProcessingManager.new()
		end
		return PostProcessingManager.instance
	end
	function PostProcessingManager:createTemplate(templateName, state, properties)
		local _templates = self.templates
		local _arg1 = {
			state = state,
			properties = properties,
		}
		_templates[templateName] = _arg1
	end
	function PostProcessingManager:updateState(templateName, transitionType)
		if transitionType == nil then
			transitionType = "instant"
		end
		local template = self.templates[templateName]
		if not template then
			print("Unknown post-processing template:", templateName)
			return nil
		end
		template.state:apply()
		if transitionType == "instant" then
			self:applyInstant(template.properties)
		elseif transitionType == "smooth" then
			self:applySmooth(template.properties)
		else
			print("Unknown transition type:", transitionType)
		end
	end
	function PostProcessingManager:applyInstant(properties)
		local _arg0 = function(value, key)
			if key == "Brightness" then
				game:GetService("Lighting").Brightness = value
			end
			-- Add more properties here as needed
		end
		for _k, _v in pairs(properties) do
			_arg0(_v, _k, properties)
		end
	end
	function PostProcessingManager:applySmooth(properties)
		print("Applying smooth transition")
		local _arg0 = function(value, key)
			if key == "Brightness" then
				local lighting = game:GetService("Lighting")
				local currentValue = lighting.Brightness
				local transitionTime = 5
				TweenService:Create(lighting, TweenInfo.new(transitionTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
					Brightness = value,
				}):Play()
			end
			-- Add more properties here as needed
		end
		for _k, _v in pairs(properties) do
			_arg0(_v, _k, properties)
		end
	end
end
return {
	PostProcessingManager = PostProcessingManager,
}
