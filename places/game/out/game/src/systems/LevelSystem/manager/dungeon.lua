-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
--[[
	*
	* Dungeon generator
	* Dungeon generator module for Roblox.
	* @author EgoMoose
	* @link N/A
	* @date 12/02/2016
]]
-- Setup
local cardinal = {
	north = Vector2.new(0, 1),
	east = Vector2.new(1, 0),
	south = Vector2.new(0, -1),
	west = Vector2.new(-1, 0),
}
local enums = {
	empty = 0,
	hall = 1,
	room = 2,
	junction = 3,
}
-- Classes
local Tile
do
	Tile = setmetatable({}, {
		__tostring = function()
			return "Tile"
		end,
	})
	Tile.__index = Tile
	function Tile.new(...)
		local self = setmetatable({}, Tile)
		return self:constructor(...) or self
	end
	function Tile:constructor(pos, enumVal, region)
		self.position = pos
		self.enum = enumVal
		self.region = region
		self.directions = {
			north = false,
			east = false,
			south = false,
			west = false,
		}
	end
end
local Tiles
do
	Tiles = setmetatable({}, {
		__tostring = function()
			return "Tiles"
		end,
	})
	Tiles.__index = Tiles
	function Tiles.new(...)
		local self = setmetatable({}, Tiles)
		return self:constructor(...) or self
	end
	function Tiles:constructor()
		self.tiles = {}
	end
	function Tiles:setTiles(origin, enumVal, region, width, height)
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		local _condition = width
		if not (_condition ~= 0 and (_condition == _condition and _condition)) then
			_condition = 0
		end
		width = _condition
		-- eslint-disable-next-line roblox-ts/lua-truthiness
		local _condition_1 = height
		if not (_condition_1 ~= 0 and (_condition_1 == _condition_1 and _condition_1)) then
			_condition_1 = 0
		end
		height = _condition_1
		do
			local x = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					x += 1
				else
					_shouldIncrement = true
				end
				if not (x <= width) then
					break
				end
				do
					local y = 0
					local _shouldIncrement_1 = false
					while true do
						if _shouldIncrement_1 then
							y += 1
						else
							_shouldIncrement_1 = true
						end
						if not (y <= height) then
							break
						end
						local _vector2 = Vector2.new(x, y)
						local pos = origin + _vector2
						local key = tostring(pos)
						if not self.tiles[key] then
							self.tiles[key] = Tile.new(pos, enumVal, region)
						else
							local tile = self.tiles[key]
							tile.position = pos
							tile.enum = enumVal
							tile.region = region
							tile.directions = {
								north = false,
								east = false,
								south = false,
								west = false,
							}
						end
					end
				end
			end
		end
	end
	function Tiles:getEnum(pos)
		local tile = self.tiles[tostring(pos)]
		if tile then
			return tile.enum
		end
	end
	function Tiles:getAllTiles(enumVal)
		local tiles = {}
		for pos, tile in pairs(self.tiles) do
			-- eslint-disable-next-line roblox-ts/lua-truthiness
			if (TS.instanceof(tile, Tile) and tile.enum == enumVal) or not (enumVal ~= 0 and (enumVal == enumVal and enumVal)) then
				table.insert(tiles, tile)
			end
		end
		return tiles
	end
	function Tiles:getTiles(enumVal)
		local tiles = {}
		for pos, tile in pairs(self.tiles) do
			if TS.instanceof(tile, Tile) and tile.enum == enumVal then
				table.insert(tiles, tile)
			end
		end
		return tiles
	end
	function Tiles:getTile(pos)
		return self.tiles[tostring(pos)]
	end
	function Tiles:getAllTilesIgnore(enumVal)
		local tiles = {}
		for pos, tile in pairs(self.tiles) do
			if TS.instanceof(tile, Tile) and tile.enum ~= enumVal then
				table.insert(tiles, tile)
			end
		end
		return tiles
	end
end
-- Class Rectangle and DungeonGen will be converted in a subsequent step
local Rectangle
do
	Rectangle = setmetatable({}, {
		__tostring = function()
			return "Rectangle"
		end,
	})
	Rectangle.__index = Rectangle
	function Rectangle.new(...)
		local self = setmetatable({}, Rectangle)
		return self:constructor(...) or self
	end
	function Rectangle:constructor(x, y, width, height)
		self.position = Vector2.new(x, y)
		self.size = Vector2.new(width, height)
		local _exp = self.position
		local _position = self.position
		local _vector2 = Vector2.new(width, 0)
		local _exp_1 = _position + _vector2
		local _position_1 = self.position
		local _vector2_1 = Vector2.new(0, height)
		local _exp_2 = _position_1 + _vector2_1
		local _position_2 = self.position
		local _size = self.size
		self.corners = { _exp, _exp_1, _exp_2, _position_2 + _size }
	end
	function Rectangle:dot2d(a, b)
		return a.X * b.X + a.Y * b.Y
	end
	function Rectangle:getAxis(c1, c2)
		local axis = {}
		local _exp = c1[2]
		local _arg0 = c1[1]
		axis[1] = _exp - _arg0
		local _exp_1 = c1[2]
		local _arg0_1 = c1[3]
		axis[2] = _exp_1 - _arg0_1
		local _exp_2 = c2[1]
		local _arg0_2 = c2[4]
		axis[3] = _exp_2 - _arg0_2
		local _exp_3 = c2[1]
		local _arg0_3 = c2[2]
		axis[4] = _exp_3 - _arg0_3
		return axis
	end
	function Rectangle:collidesWith(other)
		local scalars = {}
		local axis = Rectangle:getAxis(self.corners, other.corners)
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #axis) then
					break
				end
				for _, set in ipairs({ self.corners, other.corners }) do
					scalars[i + 1] = {}
					for _1, point in ipairs(set) do
						local v = Rectangle:dot2d(point, axis[i + 1])
						local _exp = scalars[i + 1]
						table.insert(_exp, v)
					end
				end
				-- TODO: Dungeon Generation does not work; need more research
				local s1max = math.max(unpack(scalars[1]))
				local s1min = math.min(unpack(scalars[1]))
				local s2max = math.max(unpack(scalars[2]))
				local s2min = math.min(unpack(scalars[2]))
				if s2min > s1max or s2max < s1min then
					return false
				end
			end
		end
		return true
	end
end
-- DungeonGen will be converted in a subsequent step.
local DungeonGen
do
	DungeonGen = setmetatable({}, {
		__tostring = function()
			return "DungeonGen"
		end,
	})
	DungeonGen.__index = DungeonGen
	function DungeonGen.new(...)
		local self = setmetatable({}, DungeonGen)
		return self:constructor(...) or self
	end
	function DungeonGen:constructor()
		self.roomSize = 3
		self.enums = enums
		self.lastSeed = 0
		self.windingPercent = 0
		self.attemptRoomNum = 20
		self.loadBuffer = math.huge
		self.genMapDirections = true
		self.seed = function()
			return tick()
		end
		self.bounds = {
			width = 100,
			height = 100,
		}
		self.currentRegion = 0
		self.tiles = Tiles.new()
	end
	function DungeonGen:newRegion()
		self.currentRegion += 1
	end
	function DungeonGen:boundsContains(pos)
		return not (pos.X > self.bounds.width or (pos.Y > self.bounds.height or (pos.X < 0 or pos.Y < 0)))
	end
	function DungeonGen:canCarve(pos, direction)
		local _fn = self
		local _arg0 = direction * 3
		local _condition = _fn:boundsContains(pos + _arg0)
		if _condition then
			local _fn_1 = self.tiles
			local _arg0_1 = direction * 2
			_condition = _fn_1:getEnum(pos + _arg0_1) == 0
		end
		return _condition
	end
	function DungeonGen:createRooms()
		local rooms = {}
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < self.attemptRoomNum) then
					break
				end
				local size = math.random(self.roomSize) * 2 + 1
				local rectangularity = math.random(1 + math.floor(size / 2)) * 2
				local width = size
				local height = size
				if math.random(2) == 1 then
					width += rectangularity
				else
					height += rectangularity
				end
				local x = math.random(math.floor((self.bounds.width - width) / 2)) * 2 + 1
				local y = math.random(math.floor((self.bounds.height - height) / 2)) * 2 + 1
				local room = Rectangle.new(x, y, width, height)
				local overlapping = false
				for _, other in ipairs(rooms) do
					if room:collidesWith(other) then
						overlapping = true
						break
					end
				end
				if not overlapping then
					self:newRegion()
					table.insert(rooms, room)
					self.tiles:setTiles(room.position, self.enums.room, self.currentRegion, room.size.X - 1, room.size.Y - 1)
				end
			end
		end
	end
	function DungeonGen:growMaze(pos)
		self.tiles:setTiles(pos, self.enums.hall, self.currentRegion)
		local lastDirection
		local cells = { self.tiles:getTile(pos) }
		-- spanning tree algorithm
		while #cells > 0 do
			local cell = cells[#cells - 1 + 1]
			local potential = {}
			for _element, _element_1 in pairs(cardinal) do
				local direction = { _element, _element_1 }
				if self:canCarve(cell.position, direction) then
					table.insert(potential, direction)
				end
			end
			if #potential > 0 then
				local direction
				local _condition = lastDirection
				if _condition then
					local _lastDirection = lastDirection
					_condition = table.find(potential, _lastDirection) ~= nil
					if _condition then
						_condition = math.random() * 100 > self.windingPercent
					end
				end
				if _condition then
					direction = lastDirection
				else
					direction = potential[math.floor(math.random() * #potential) + 1]
				end
				local _fn = self.tiles
				local _position = cell.position
				local _direction = direction
				_fn:setTiles(_position + _direction, self.enums.hall, self.currentRegion)
				local _fn_1 = self.tiles
				local _position_1 = cell.position
				local _arg0 = direction * 2
				_fn_1:setTiles(_position_1 + _arg0, self.enums.hall, self.currentRegion)
				local _fn_2 = self.tiles
				local _position_2 = cell.position
				local _arg0_1 = direction * 2
				local _arg0_2 = _fn_2:getTile(_position_2 + _arg0_1)
				table.insert(cells, _arg0_2)
				lastDirection = direction
			else
				cells[#cells] = nil
				lastDirection = nil
			end
		end
	end
	function DungeonGen:connectRegions()
		local connectors = {}
		local connectedPoints = {}
		-- collect regions that can be connected
		for _, tile in ipairs(self.tiles:getAllTiles(self.enums.empty)) do
			local regions = {}
			for name, direction in pairs(cardinal) do
				local ntile = self.tiles:getTile(tile.position + direction)
				local _value = ntile and (ntile.enum > 0 and ntile.region)
				if _value ~= 0 and (_value == _value and _value) then
					regions[ntile.region] = true
				end
			end
			local open = {}
			for k, v in pairs(regions) do
				table.insert(open, k)
			end
			if #open == 2 then
				table.insert(connectedPoints, tile)
				connectors[tostring(tile.position)] = open
			end
		end
		-- place our connections/smooth
		while #connectedPoints > 1 do
			local index = math.floor(math.random() * #connectedPoints)
			local tile = connectedPoints[index + 1]
			local region = connectors[tostring(tile.position)]
			self.tiles:setTiles(tile.position, self.enums.junction)
			local _connectedPoints = connectedPoints
			local _arg0 = function(_, i)
				return i ~= index
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in ipairs(_connectedPoints) do
				if _arg0(_v, _k - 1, _connectedPoints) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			connectedPoints = _newValue
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < #connectedPoints) then
						break
					end
					if i ~= index then
						local open = connectors[tostring(connectedPoints[i + 1].position)]
						local _arg0_1 = region[1]
						local _condition = table.find(open, _arg0_1) ~= nil
						if _condition then
							local _arg0_2 = region[2]
							_condition = table.find(open, _arg0_2) ~= nil
						end
						if _condition then
							local _connectedPoints_1 = connectedPoints
							local _arg0_2 = function(_, i)
								return i ~= index
							end
							-- ▼ ReadonlyArray.filter ▼
							local _newValue_1 = {}
							local _length_1 = 0
							for _k, _v in ipairs(_connectedPoints_1) do
								if _arg0_2(_v, _k - 1, _connectedPoints_1) == true then
									_length_1 += 1
									_newValue_1[_length_1] = _v
								end
							end
							-- ▲ ReadonlyArray.filter ▲
							connectedPoints = _newValue_1
						end
					end
				end
			end
			for _, otile in ipairs(self.tiles:getAllTiles(self.enums.junction)) do
				if tile.position == tile.position then
					local _position = otile.position
					local _position_1 = tile.position
					if (_position - _position_1).Magnitude < 1.1 then
						self.tiles:setTiles(otile.position, self.enums.empty)
					end
				end
			end
		end
	end
	function DungeonGen:removeDeadEnds()
		local done = false
		local c = 0
		local maze = self.tiles:getAllTiles(self.enums.hall)
		while not done do
			done = true
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < #maze) then
						break
					end
					local tile = maze[i + 1]
					c += 1
					local exits = 0
					for _, directionVector in pairs(cardinal) do
						local ntile = self.tiles:getTile(tile.position + directionVector)
						-- eslint-disable-next-line roblox-ts/lua-truthiness
						if ntile and ntile.enum ~= self.enums.empty then
							exits += 1
						end
					end
					if c % self.loadBuffer == 0 then
					end
					if exits <= 1 then
						local _maze = maze
						local _arg0 = function(_, i)
							return i ~= i
						end
						-- ▼ ReadonlyArray.filter ▼
						local _newValue = {}
						local _length = 0
						for _k, _v in ipairs(_maze) do
							if _arg0(_v, _k - 1, _maze) == true then
								_length += 1
								_newValue[_length] = _v
							end
						end
						-- ▲ ReadonlyArray.filter ▲
						maze = _newValue
						self.tiles:setTiles(tile.position, self.enums.empty, nil)
						done = false
						break
					end
				end
			end
		end
	end
	function DungeonGen:mapDirections()
		for _, tile in ipairs(self.tiles:getAllTilesIgnore(self.enums.empty)) do
			for name, direction in pairs(cardinal) do
				local ntile = self.tiles:getTile(tile.position + direction)
				-- eslint-disable-next-line roblox-ts/lua-truthiness
				if ntile and ntile.enum ~= self.enums.empty then
					tile.directions[tostring(name)] = true
				end
			end
		end
	end
	function DungeonGen:generate()
		-- Set random seed
		self.lastSeed = self.seed()
		math.randomseed(self.lastSeed)
		-- Generate initial
		self.tiles:setTiles(Vector2.new(0, 0), enums.empty, self.currentRegion, self.bounds.width, self.bounds.height)
		self:createRooms()
		self:newRegion()
		-- Start maze
		for _, tile in ipairs(self.tiles:getAllTiles(enums.empty)) do
			-- Must be odd number position
			local pos = tile.position
			if pos.X % 2 == 1 and (pos.Y % 2 == 1 and tile.enum == enums.empty) then
				self:growMaze(pos)
			end
		end
		-- Smooth and find final
		self:connectRegions()
		self:removeDeadEnds()
		if self.genMapDirections then
			self:mapDirections()
		end
		-- Return tile set
		return self.tiles
	end
end
local default = DungeonGen
return {
	enums = enums,
	default = default,
}
