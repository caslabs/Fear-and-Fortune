-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local RunService = _services.RunService
local Workspace = _services.Workspace
local Players = _services.Players
local Remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local playerLocationEvent = Remotes.Server:Get("PlayerLocationEvent")
-- Checks if a point is in a region
local function isPointInRegion3(point, region)
	local _position = region.CFrame.Position
	local _arg0 = region.Size / 2
	local min = _position - _arg0
	local _position_1 = region.CFrame.Position
	local _arg0_1 = region.Size / 2
	local max = _position_1 + _arg0_1
	return point.X >= min.X and (point.X <= max.X and (point.Y >= min.Y and (point.Y <= max.Y and (point.Z >= min.Z and point.Z <= max.Z))))
end
local characterHeightWithJumpBuffer = 50
local LevelSystemService
do
	LevelSystemService = setmetatable({}, {
		__tostring = function()
			return "LevelSystemService"
		end,
	})
	LevelSystemService.__index = LevelSystemService
	function LevelSystemService.new(...)
		local self = setmetatable({}, LevelSystemService)
		return self:constructor(...) or self
	end
	function LevelSystemService:constructor()
		self.playerCurrentSegment = {}
		self.segments = {}
	end
	function LevelSystemService:onInit()
		local LevelSegmentModel = game:GetService("ServerStorage"):FindFirstChild("LevelSegment")
		if not LevelSegmentModel then
			warn("LevelSegmentModel not found in ServerStorage")
			return nil
		end
		-- TODO: very hacky, fix later - had to hard-code the positions for now.
		-- Will change when I have a assets for the levels
		local currentPosition = Vector3.new(-368.221, 285.817, 1595.267)
		local segmentDepth = 698.999 - 584.438
		local overlap = 10
		-- TODO: Make this data-driven. For now, it creates 10 LevelSegments in a row.
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < 10) then
					break
				end
				-- Add Level Segments to the workspace
				local newSegment = LevelSegmentModel:Clone()
				newSegment.Name = "LevelSegment" .. tostring(i + 1)
				newSegment:SetPrimaryPartCFrame(CFrame.new(currentPosition))
				newSegment.Parent = Workspace
				local cframe, size = newSegment:GetBoundingBox()
				-- Create a region part 'Partitioning' per LevelSegment
				local regionPart = Instance.new("Part")
				regionPart.Size = Vector3.new(size.X, size.Y + characterHeightWithJumpBuffer, size.Z + overlap)
				regionPart.Position = Vector3.new(cframe.Position.X, cframe.Position.Y + characterHeightWithJumpBuffer / 2, cframe.Position.Z + overlap / 2)
				regionPart.Transparency = 1
				regionPart.Anchored = true
				regionPart.CanCollide = false
				regionPart.Parent = newSegment
				-- Add the LevelSegment and regionPart to the segments array
				local _segments = self.segments
				local _arg0 = {
					model = newSegment,
					regionPart = regionPart,
					players = {},
				}
				table.insert(_segments, _arg0)
				-- Update the current position, to create the next LevelSegment
				local _currentPosition = currentPosition
				local _vector3 = Vector3.new(0, 0, segmentDepth)
				currentPosition = _currentPosition + _vector3
				-- TODO: A bit of a hack, but we also define a region 'partioning' for our built in Tutorial Node
				local TutorialNodeModel = Workspace:FindFirstChild("TutorialNode")
				if not TutorialNodeModel then
					warn("TutorialNodeModel not found in Workspace")
					return nil
				end
				-- TODO: A bit of a hack, but we also define a region 'partioning' for our built in Tutorial Node
				local BaseCampNodeModel = Workspace:FindFirstChild("BaseCampNode")
				if not BaseCampNodeModel then
					warn("BaseCampNodeModel not found in Workspace")
					return nil
				end
				-- Add TutorialNode Region Partioning to the segments array
				local cframe1, size2 = TutorialNodeModel:GetBoundingBox()
				local tutorialNode = Instance.new("Part")
				tutorialNode.Size = Vector3.new(size2.X, size2.Y + characterHeightWithJumpBuffer, size2.Z)
				tutorialNode.Position = cframe1.Position
				tutorialNode.Transparency = 1
				tutorialNode.Anchored = true
				tutorialNode.CanCollide = false
				tutorialNode.Parent = TutorialNodeModel
				local _segments_1 = self.segments
				local _arg0_1 = {
					model = TutorialNodeModel,
					regionPart = tutorialNode,
					players = {},
				}
				table.insert(_segments_1, _arg0_1)
				-- Add BaseCamp Region
				local cframe2, size3 = BaseCampNodeModel:GetBoundingBox()
				local baseCampNode = Instance.new("Part")
				baseCampNode.Size = Vector3.new(size3.X, size3.Y + characterHeightWithJumpBuffer, size3.Z)
				baseCampNode.Position = cframe2.Position
				baseCampNode.Transparency = 1
				baseCampNode.Anchored = true
				baseCampNode.CanCollide = false
				baseCampNode.Parent = BaseCampNodeModel
				local _segments_2 = self.segments
				local _arg0_2 = {
					model = BaseCampNodeModel,
					regionPart = baseCampNode,
					players = {},
				}
				table.insert(_segments_2, _arg0_2)
			end
		end
	end
	function LevelSystemService:onStart()
		-- Check if the player is in a segment via a simple space partioning system using states
		RunService.Heartbeat:Connect(function()
			for _, player in ipairs(Players:GetPlayers()) do
				local character = player.Character
				if not character then
					continue
				end
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					continue
				end
				-- Track the current segment for the player
				local newSegment = nil
				-- Space Partioning System
				-- Check if the player is in any of the segments
				for _1, segment in ipairs(self.segments) do
					-- Create a region for the segment
					local _position = segment.regionPart.Position
					local _arg0 = segment.regionPart.Size / 2
					local _exp = _position - _arg0
					local _position_1 = segment.regionPart.Position
					local _arg0_1 = segment.regionPart.Size / 2
					local region = Region3.new(_exp, _position_1 + _arg0_1)
					-- Check if the player is in the region via our collision point box check
					if isPointInRegion3(humanoidRootPart.Position, region) then
						newSegment = segment.model.Name
						if not (table.find(segment.players, player) ~= nil) then
							local _players = segment.players
							table.insert(_players, player)
						end
						break
					else
						if table.find(segment.players, player) ~= nil then
							-- If the player was in the segment, but is no longer, remove them from the segment
							local _players = segment.players
							local _arg0_2 = function(p)
								return p ~= player
							end
							-- ▼ ReadonlyArray.filter ▼
							local _newValue = {}
							local _length = 0
							for _k, _v in ipairs(_players) do
								if _arg0_2(_v, _k - 1, _players) == true then
									_length += 1
									_newValue[_length] = _v
								end
							end
							-- ▲ ReadonlyArray.filter ▲
							segment.players = _newValue
						end
					end
				end
				-- TODO: A bit hard coded, but works for playtesting
				-- If the player is not in any segment, check the tutorial node
				if newSegment == nil then
					-- If player is not in any segment, check the tutorial node
					local tutorialNode = Workspace:FindFirstChild("TutorialNode")
					if tutorialNode then
						local cframe, size = tutorialNode:GetBoundingBox()
						local _position = cframe.Position
						local _arg0 = size / 2
						local _exp = _position - _arg0
						local _position_1 = cframe.Position
						local _arg0_1 = size / 2
						local tutorialRegion = Region3.new(_exp, _position_1 + _arg0_1)
						if isPointInRegion3(humanoidRootPart.Position, tutorialRegion) then
							newSegment = tutorialNode.Name
						end
					end
				end
				-- eslint-disable-next-line roblox-ts/lua-truthiness
				local _condition = newSegment
				if not (_condition ~= "" and _condition) then
					_condition = "None"
				end
				newSegment = _condition
				-- Send the player location event to the player, to which handles any events
				if self.playerCurrentSegment[player] ~= newSegment then
					local _playerCurrentSegment = self.playerCurrentSegment
					local _newSegment = newSegment
					_playerCurrentSegment[player] = _newSegment
					local _segments = self.segments
					local _arg0 = function(s)
						return s.model.Name == newSegment
					end
					-- ▼ ReadonlyArray.find ▼
					local _result
					for _i, _v in ipairs(_segments) do
						if _arg0(_v, _i - 1, _segments) == true then
							_result = _v
							break
						end
					end
					-- ▲ ReadonlyArray.find ▲
					local segmentModel = _result
					if segmentModel ~= nil then
						playerLocationEvent:SendToPlayer(player, player, newSegment, segmentModel)
						print(self.playerCurrentSegment)
					end
					print(self.playerCurrentSegment)
				end
			end
		end)
		print("LevelSystem Service started")
	end
end
-- (Flamework) LevelSystemService metadata
Reflect.defineMetadata(LevelSystemService, "identifier", "game/src/systems/LevelSystem/services/level-service@LevelSystemService")
Reflect.defineMetadata(LevelSystemService, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(LevelSystemService, "$:flamework@Service", Service, { {} })
return {
	default = LevelSystemService,
}
