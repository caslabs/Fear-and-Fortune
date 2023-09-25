-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, TS.getModule(script, "@flamework", "core").out).Reflect
local Service = TS.import(script, TS.getModule(script, "@flamework", "core").out).Service
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local CellState
do
	local _inverse = {}
	CellState = setmetatable({}, {
		__index = _inverse,
	})
	CellState.Wall = 0
	_inverse[0] = "Wall"
	CellState.Empty = 1
	_inverse[1] = "Empty"
	CellState.Path = 2
	_inverse[2] = "Path"
	CellState.End = 3
	_inverse[3] = "End"
end
local IsometricMazeGeneration
do
	IsometricMazeGeneration = setmetatable({}, {
		__tostring = function()
			return "IsometricMazeGeneration"
		end,
	})
	IsometricMazeGeneration.__index = IsometricMazeGeneration
	function IsometricMazeGeneration.new(...)
		local self = setmetatable({}, IsometricMazeGeneration)
		return self:constructor(...) or self
	end
	function IsometricMazeGeneration:constructor()
		self.MAZE_WIDTH = 10
		self.MAZE_LENGTH = 10
		self.MAZE_HEIGHT = 20
		self.maze = {}
	end
	function IsometricMazeGeneration:onInit()
	end
	function IsometricMazeGeneration:onStart()
		self:generateMaze()
	end
	function IsometricMazeGeneration:generateMaze()
		print("Starting maze generation...")
		-- Initialize maze with all cells being walls
		self.maze = table.create(self.MAZE_HEIGHT)
		do
			local y = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					y += 1
				else
					_shouldIncrement = true
				end
				if not (y < self.MAZE_HEIGHT) then
					break
				end
				self.maze[y + 1] = table.create(self.MAZE_WIDTH)
				do
					local x = 0
					local _shouldIncrement_1 = false
					while true do
						if _shouldIncrement_1 then
							x += 1
						else
							_shouldIncrement_1 = true
						end
						if not (x < self.MAZE_WIDTH) then
							break
						end
						self.maze[y + 1][x + 1] = table.create(self.MAZE_LENGTH)
						do
							local z = 0
							local _shouldIncrement_2 = false
							while true do
								if _shouldIncrement_2 then
									z += 1
								else
									_shouldIncrement_2 = true
								end
								if not (z < self.MAZE_LENGTH) then
									break
								end
								local block = Instance.new("Part")
								block.Size = Vector3.new(5, 5, 5)
								block.Position = Vector3.new(x * 5, y * 5, z * 5)
								block.Anchored = true
								block.BrickColor = BrickColor.new("Institutional white")
								block.Transparency = 1
								block.Parent = Workspace
								self.maze[y + 1][x + 1][z + 1] = {
									part = block,
									state = CellState.Wall,
								}
							end
						end
					end
				end
			end
		end
		-- Generate a vertical path from base to peak
		local verticalX = math.floor(self.MAZE_WIDTH / 2)
		local verticalZ = math.floor(self.MAZE_LENGTH / 2)
		do
			local y = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					y += 1
				else
					_shouldIncrement = true
				end
				if not (y < self.MAZE_HEIGHT) then
					break
				end
				self.maze[y + 1][verticalX + 1][verticalZ + 1] = {
					part = self.maze[y + 1][verticalX + 1][verticalZ + 1].part,
					state = CellState.Path,
				}
				self.maze[y + 1][verticalX + 1][verticalZ + 1].part.BrickColor = BrickColor.new("Bright green")
				self.maze[y + 1][verticalX + 1][verticalZ + 1].part.Transparency = 0
			end
		end
		-- Generate branching paths on each level
		do
			local y = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					y += 1
				else
					_shouldIncrement = true
				end
				if not (y < self.MAZE_HEIGHT) then
					break
				end
				self:createPath(self.maze[y + 1][verticalX + 1][verticalZ + 1])
			end
		end
		print("Maze generation complete!")
	end
	function IsometricMazeGeneration:createPath(startCell)
		local stack = {}
		table.insert(stack, startCell)
		startCell.state = CellState.Path
		startCell.part.BrickColor = BrickColor.new("Bright green")
		local iterations = 0
		while #stack > 0 do
			iterations += 1
			if iterations % 1000 == 0 then
				wait()
			end
			local cell = stack[#stack - 1 + 1]
			-- Find unvisited neighboring cells
			local _exp = self:getNeighbors(cell)
			local _arg0 = function(neighbor)
				return neighbor.state == CellState.Wall
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in ipairs(_exp) do
				if _arg0(_v, _k - 1, _exp) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			local unvisited = _newValue
			if #unvisited > 0 then
				-- Select a random unvisited neighbor
				local nextCell = unvisited[math.floor(math.random() * #unvisited) + 1]
				-- Check if there is a wall between the current cell and the chosen cell
				if self:hasWallBetween(cell, nextCell) then
					-- There is a wall, so visit the next cell and destroy the wall
					table.insert(stack, nextCell)
					nextCell.state = CellState.Path
					nextCell.part.BrickColor = BrickColor.new("Bright green")
					nextCell.part.Transparency = 0
					self:destroyWallBetween(cell, nextCell)
				end
			else
				-- No unvisited neighbors, backtrack
				stack[#stack] = nil
			end
		end
	end
	function IsometricMazeGeneration:hasWallBetween(cell1, cell2)
		local midpoint = self:getMidpoint(cell1, cell2)
		if midpoint then
			return midpoint.state == CellState.Wall
		end
		return false
	end
	function IsometricMazeGeneration:destroyWallBetween(cell1, cell2)
		local midpoint = self:getMidpoint(cell1, cell2)
		if midpoint then
			midpoint.state = CellState.Empty
			midpoint.part.BrickColor = BrickColor.new("Mid gray")
			midpoint.part.Transparency = 0
		end
	end
	function IsometricMazeGeneration:getMidpoint(cell1, cell2)
		local pos1 = cell1.part.Position
		local pos2 = cell2.part.Position
		local midpointPos = (pos1 + pos2) / 2
		local x = math.floor(midpointPos.X / 5)
		local y = math.floor(midpointPos.Y / 5)
		local z = math.floor(midpointPos.Z / 5)
		if x >= 0 and (x < self.MAZE_WIDTH and (y >= 0 and (y < self.MAZE_HEIGHT and (z >= 0 and z < self.MAZE_LENGTH)))) then
			if self.maze[y + 1] and (self.maze[y + 1][x + 1] and self.maze[y + 1][x + 1][z + 1]) then
				return self.maze[y + 1][x + 1][z + 1]
			end
		end
		return nil
	end
	function IsometricMazeGeneration:getNeighbors(cell)
		local neighbors = {}
		local x = cell.part.Position.X / 5
		local y = cell.part.Position.Y / 5
		local z = cell.part.Position.Z / 5
		local directions = { {
			dx = -1,
			dy = 0,
			dz = 0,
		}, {
			dx = 1,
			dy = 0,
			dz = 0,
		}, {
			dx = 0,
			dy = -1,
			dz = 0,
		}, {
			dx = 0,
			dy = 1,
			dz = 0,
		}, {
			dx = 0,
			dy = 0,
			dz = -1,
		}, {
			dx = 0,
			dy = 0,
			dz = 1,
		} }
		for _, direction in ipairs(directions) do
			local newX = x + direction.dx
			local newY = y + direction.dy
			local newZ = z + direction.dz
			if newX >= 0 and (newX < self.MAZE_WIDTH and (newY >= 0 and (newY < self.MAZE_HEIGHT and (newZ >= 0 and newZ < self.MAZE_LENGTH)))) then
				local _arg0 = self.maze[newY + 1][newX + 1][newZ + 1]
				table.insert(neighbors, _arg0)
			end
		end
		return neighbors
	end
end
-- (Flamework) IsometricMazeGeneration metadata
Reflect.defineMetadata(IsometricMazeGeneration, "identifier", "tutorial/src/systems/LevelSystem/services/maze-service@IsometricMazeGeneration")
Reflect.defineMetadata(IsometricMazeGeneration, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(IsometricMazeGeneration, "$:flamework@Service", Service, { {} })
return {
	default = IsometricMazeGeneration,
}
