-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local Workspace = _services.Workspace
local RunService = _services.RunService
local _components = TS.import(script, TS.getModule(script, "@flamework", "components").out)
local Component = _components.Component
local BaseComponent = _components.BaseComponent
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
-- TODO: Experimental
local RadioComponent
do
	local super = BaseComponent
	RadioComponent = setmetatable({}, {
		__tostring = function()
			return "RadioComponent"
		end,
		__index = super,
	})
	RadioComponent.__index = RadioComponent
	function RadioComponent.new(...)
		local self = setmetatable({}, RadioComponent)
		return self:constructor(...) or self
	end
	function RadioComponent:constructor(taskSystem)
		super.constructor(self)
		self.taskSystem = taskSystem
		self.staringStartTime = {}
		self.previousStaringState = {}
		self.players = {}
	end
	function RadioComponent:onStart()
		self.players = Players:GetPlayers()
		Players.PlayerAdded:Connect(function(player)
			local _players = self.players
			table.insert(_players, player)
			return #_players
		end)
		Players.PlayerRemoving:Connect(function(player)
			local _players = self.players
			local _arg0 = function(p)
				return p ~= player
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in ipairs(_players) do
				if _arg0(_v, _k - 1, _players) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self.players = _newValue
			self.previousStaringState[player] = nil
			self.staringStartTime[player] = nil
		end)
		RunService.Heartbeat:Connect(function()
			return self:update()
		end)
		print("Radio Component Started")
	end
	function RadioComponent:update()
		local _players = self.players
		local _arg0 = function(player)
			if player.Character then
				local head = player.Character:FindFirstChild("Head")
				if head then
					local cameraPosition = head.Position
					local direction = head.CFrame.LookVector
					if cameraPosition and direction then
						local ray = Ray.new(cameraPosition, direction * 100)
						local ignoreList = { player.Character }
						local params = RaycastParams.new()
						params.FilterDescendantsInstances = ignoreList
						params.FilterType = Enum.RaycastFilterType.Blacklist
						local result = Workspace:Raycast(ray.Origin, ray.Direction, params)
						if result and result.Instance:IsDescendantOf(self.instance) then
							-- player is staring at the radio
							if not self.previousStaringState[player] then
								print("Player is staring at the radio")
								self.previousStaringState[player] = true
							end
							if not (self.staringStartTime[player] ~= nil) then
								local _staringStartTime = self.staringStartTime
								local _arg1 = tick()
								_staringStartTime[player] = _arg1
							elseif tick() - self.staringStartTime[player] >= 10 then
								-- player has been staring at the radio for 10 seconds
								print("Radio ACTIVATED")
								self.staringStartTime[player] = nil
								self.taskSystem:startNextObjective()
							end
						else
							-- player is not staring at the radio
							if self.previousStaringState[player] then
								print("Player is not staring at the radio")
								self.previousStaringState[player] = false
							end
							self.staringStartTime[player] = nil
						end
					else
						error("Camera position or direction not found")
					end
				else
					error("Head not found")
				end
			else
				error("Character not found")
			end
		end
		for _k, _v in ipairs(_players) do
			_arg0(_v, _k - 1, _players)
		end
	end
end
-- (Flamework) RadioComponent metadata
Reflect.defineMetadata(RadioComponent, "identifier", "game/src/entities/Resources/IronWood/services/radio-component-service@RadioComponent")
Reflect.defineMetadata(RadioComponent, "flamework:parameters", { "game/src/systems/TaskSystem/services/task-service@TaskSystemService" })
Reflect.defineMetadata(RadioComponent, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(RadioComponent, "$c:init@Component", Component, { {
	tag = "RadioTrigger",
	instanceGuard = t.instanceIsA("Model"),
	attributes = {},
} })
return {
	RadioComponent = RadioComponent,
}
