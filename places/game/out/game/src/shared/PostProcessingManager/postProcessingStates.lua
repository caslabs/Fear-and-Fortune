-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Lighting = _services.Lighting
local Players = _services.Players
local Workspace = _services.Workspace
local BlackoutState
do
	BlackoutState = setmetatable({}, {
		__tostring = function()
			return "BlackoutState"
		end,
	})
	BlackoutState.__index = BlackoutState
	function BlackoutState.new(...)
		local self = setmetatable({}, BlackoutState)
		return self:constructor(...) or self
	end
	function BlackoutState:constructor()
	end
	function BlackoutState:apply()
		-- Set up the post-processing properties for a blackout effect
		Lighting.Ambient = Color3.new(0, 0, 0)
		Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
		Lighting.Brightness = 0
		local colorCorrection = Instance.new("ColorCorrectionEffect")
		colorCorrection.Saturation = -1
		colorCorrection.Parent = Lighting
	end
end
local DefaultState
do
	DefaultState = setmetatable({}, {
		__tostring = function()
			return "DefaultState"
		end,
	})
	DefaultState.__index = DefaultState
	function DefaultState.new(...)
		local self = setmetatable({}, DefaultState)
		return self:constructor(...) or self
	end
	function DefaultState:constructor()
	end
	function DefaultState:apply()
	end
end
local JumpscareState
do
	JumpscareState = setmetatable({}, {
		__tostring = function()
			return "JumpscareState"
		end,
	})
	JumpscareState.__index = JumpscareState
	function JumpscareState.new(...)
		local self = setmetatable({}, JumpscareState)
		return self:constructor(...) or self
	end
	function JumpscareState:constructor()
	end
	function JumpscareState:apply()
		-- Set up the post-processing properties for a jumpscare effect
		Lighting.Brightness = 1
		local colorCorrection = Instance.new("ColorCorrectionEffect")
		colorCorrection.Saturation = 0
		colorCorrection.TintColor = Color3.new(1, 0.5, 0.5)
		colorCorrection.Parent = Lighting
		local bloom = Instance.new("BloomEffect")
		bloom.Intensity = 1.5
		bloom.Size = 48
		bloom.Parent = Lighting
		local _exp = TS.Promise.delay(1.5)
		local _arg0 = function()
			-- Adjust the delay to match the jumpscare duration
			colorCorrection:Destroy()
		end
		_exp:andThen(_arg0)
	end
end
local ZoomState
do
	ZoomState = setmetatable({}, {
		__tostring = function()
			return "ZoomState"
		end,
	})
	ZoomState.__index = ZoomState
	function ZoomState.new(...)
		local self = setmetatable({}, ZoomState)
		return self:constructor(...) or self
	end
	function ZoomState:constructor()
	end
	function ZoomState:apply()
		local player = Players.LocalPlayer
		local camera = Workspace.CurrentCamera
		-- Set up the post-processing properties for a jumpscare effect with zoom
		if player and camera then
			-- Save the original FieldOfView
			-- Zoom in slightly
			camera.FieldOfView = 120
		end
	end
end
local JumpscareZoomState
do
	JumpscareZoomState = setmetatable({}, {
		__tostring = function()
			return "JumpscareZoomState"
		end,
	})
	JumpscareZoomState.__index = JumpscareZoomState
	function JumpscareZoomState.new(...)
		local self = setmetatable({}, JumpscareZoomState)
		return self:constructor(...) or self
	end
	function JumpscareZoomState:constructor()
	end
	function JumpscareZoomState:apply()
		local player = Players.LocalPlayer
		local camera = Workspace.CurrentCamera
		local character = player.Character
		local _humanoid = character
		if _humanoid ~= nil then
			_humanoid = _humanoid:FindFirstChild("Humanoid")
		end
		local humanoid = _humanoid
		-- TODO: Temporarily Player Heatlh Damage
		-- Set up the post-processing properties for a jumpscare effect with zoom and red tint
		Lighting.Brightness = 1
		local colorCorrection = Instance.new("ColorCorrectionEffect")
		colorCorrection.Saturation = 0
		colorCorrection.TintColor = Color3.new(1, 0.5, 0.5)
		colorCorrection.Parent = Lighting
		local bloom = Instance.new("BloomEffect")
		bloom.Intensity = 1.5
		bloom.Size = 48
		bloom.Parent = Lighting
		if humanoid and humanoid:IsA("Humanoid") then
			-- It's a player! Subtract health.
			print("SPOOKED Player!")
			humanoid.Health -= 10
			-- Find the Player instance associated with the character model
			local player = Players:GetPlayerFromCharacter(character)
			-- Guard - if player is alive, prevent error of fidning attribute of a non-existent player
			-- If the player was found, set the attribute
			if player then
				-- Make sure the player instance is still valid
				if player:IsA("Player") then
					player:SetAttribute("LastDamageByBanshee", true)
				end
				-- Save the original FieldOfView
				local originalFOV = 70
				-- Zoom in slightly
				camera.FieldOfView = 30
				local _exp = TS.Promise.delay(1)
				local _arg0 = function()
					camera.FieldOfView = originalFOV
				end
				_exp:andThen(_arg0)
			end
		end
		local _exp = TS.Promise.delay(1)
		local _arg0 = function()
			colorCorrection:Destroy()
			bloom:Destroy()
		end
		_exp:andThen(_arg0)
		print("[POST PROCESSING] JUMPSCARE")
	end
end
local NormalState
do
	NormalState = setmetatable({}, {
		__tostring = function()
			return "NormalState"
		end,
	})
	NormalState.__index = NormalState
	function NormalState.new(...)
		local self = setmetatable({}, NormalState)
		return self:constructor(...) or self
	end
	function NormalState:constructor()
	end
	function NormalState:apply()
		-- Set up the post-processing properties for a jumpscare effect
		Lighting.Brightness = 0
		local colorCorrection = Instance.new("ColorCorrectionEffect")
		colorCorrection.Saturation = 0
		colorCorrection.Name = "ColorCorrectionEffect"
		colorCorrection.Parent = Lighting
		local bloom = Instance.new("BloomEffect")
		bloom.Intensity = 0
		bloom.Size = 0
		bloom.Parent = Lighting
	end
end
return {
	BlackoutState = BlackoutState,
	DefaultState = DefaultState,
	JumpscareState = JumpscareState,
	ZoomState = ZoomState,
	JumpscareZoomState = JumpscareZoomState,
	NormalState = NormalState,
}
