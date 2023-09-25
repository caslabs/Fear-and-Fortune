import { OnStart, Service, OnInit } from "@flamework/core";
import { Workspace } from "@rbxts/services";

enum CellState {
	Wall,
	Empty,
	Path,
	End,
}

interface Cell {
	part: Part;
	state: CellState;
}

@Service({})
export default class IsometricMazeGeneration implements OnStart, OnInit {
	private readonly MAZE_WIDTH = 10;
	private readonly MAZE_LENGTH = 10;
	private readonly MAZE_HEIGHT = 20;

	private maze: Cell[][][] = [];

	public onInit(): void | Promise<void> {}

	public onStart() {
		this.generateMaze();
	}

	private generateMaze() {
		print("Starting maze generation...");

		// Initialize maze with all cells being walls
		this.maze = new Array(this.MAZE_HEIGHT);
		for (let y = 0; y < this.MAZE_HEIGHT; y++) {
			this.maze[y] = new Array(this.MAZE_WIDTH);
			for (let x = 0; x < this.MAZE_WIDTH; x++) {
				this.maze[y][x] = new Array(this.MAZE_LENGTH);
				for (let z = 0; z < this.MAZE_LENGTH; z++) {
					const block = new Instance("Part");
					block.Size = new Vector3(5, 5, 5);
					block.Position = new Vector3(x * 5, y * 5, z * 5);
					block.Anchored = true;
					block.BrickColor = new BrickColor("Institutional white");
					block.Transparency = 1;
					block.Parent = Workspace; // Parent the block to the workspace

					this.maze[y][x][z] = {
						part: block,
						state: CellState.Wall,
					};
				}
			}
		}

		// Generate a vertical path from base to peak
		const verticalX = math.floor(this.MAZE_WIDTH / 2);
		const verticalZ = math.floor(this.MAZE_LENGTH / 2);
		for (let y = 0; y < this.MAZE_HEIGHT; y++) {
			this.maze[y][verticalX][verticalZ] = {
				part: this.maze[y][verticalX][verticalZ].part,
				state: CellState.Path,
			};
			this.maze[y][verticalX][verticalZ].part.BrickColor = new BrickColor("Bright green");
			this.maze[y][verticalX][verticalZ].part.Transparency = 0;
		}

		// Generate branching paths on each level
		for (let y = 0; y < this.MAZE_HEIGHT; y++) {
			this.createPath(this.maze[y][verticalX][verticalZ]);
		}

		print("Maze generation complete!");
	}

	private createPath(startCell: Cell) {
		const stack: Cell[] = [];
		stack.push(startCell);
		startCell.state = CellState.Path;
		startCell.part.BrickColor = new BrickColor("Bright green"); // mark the cell as visited

		let iterations = 0;

		while (stack.size() > 0) {
			iterations++;
			if (iterations % 1000 === 0) {
				wait(); // Yield to other tasks
			}

			const cell = stack[stack.size() - 1];

			// Find unvisited neighboring cells
			const unvisited = this.getNeighbors(cell).filter((neighbor) => neighbor.state === CellState.Wall);

			if (unvisited.size() > 0) {
				// Select a random unvisited neighbor
				const nextCell = unvisited[math.floor(math.random() * unvisited.size())];
				// Check if there is a wall between the current cell and the chosen cell
				if (this.hasWallBetween(cell, nextCell)) {
					// There is a wall, so visit the next cell and destroy the wall
					stack.push(nextCell);
					nextCell.state = CellState.Path;
					nextCell.part.BrickColor = new BrickColor("Bright green");
					nextCell.part.Transparency = 0;

					this.destroyWallBetween(cell, nextCell);
				}
			} else {
				// No unvisited neighbors, backtrack
				stack.pop();
			}
		}
	}

	private hasWallBetween(cell1: Cell, cell2: Cell): boolean {
		const midpoint = this.getMidpoint(cell1, cell2);
		if (midpoint) {
			return midpoint.state === CellState.Wall;
		}
		return false;
	}

	private destroyWallBetween(cell1: Cell, cell2: Cell): void {
		const midpoint = this.getMidpoint(cell1, cell2);
		if (midpoint) {
			midpoint.state = CellState.Empty;
			midpoint.part.BrickColor = new BrickColor("Mid gray");
			midpoint.part.Transparency = 0;
		}
	}

	private getMidpoint(cell1: Cell, cell2: Cell): Cell | undefined {
		const pos1 = cell1.part.Position;
		const pos2 = cell2.part.Position;
		const midpointPos = pos1.add(pos2).div(2);
		const x = math.floor(midpointPos.X / 5);
		const y = math.floor(midpointPos.Y / 5);
		const z = math.floor(midpointPos.Z / 5);
		if (x >= 0 && x < this.MAZE_WIDTH && y >= 0 && y < this.MAZE_HEIGHT && z >= 0 && z < this.MAZE_LENGTH) {
			if (this.maze[y] && this.maze[y][x] && this.maze[y][x][z]) {
				return this.maze[y][x][z];
			}
		}

		return undefined;
	}

	private getNeighbors(cell: Cell): Cell[] {
		const neighbors: Cell[] = [];
		const x = cell.part.Position.X / 5;
		const y = cell.part.Position.Y / 5;
		const z = cell.part.Position.Z / 5;

		const directions = [
			{ dx: -1, dy: 0, dz: 0 }, // left
			{ dx: 1, dy: 0, dz: 0 }, // right
			{ dx: 0, dy: -1, dz: 0 }, // down
			{ dx: 0, dy: 1, dz: 0 }, // up
			{ dx: 0, dy: 0, dz: -1 }, // backward
			{ dx: 0, dy: 0, dz: 1 }, // forward
		];

		for (const direction of directions) {
			const newX = x + direction.dx;
			const newY = y + direction.dy;
			const newZ = z + direction.dz;

			if (
				newX >= 0 &&
				newX < this.MAZE_WIDTH &&
				newY >= 0 &&
				newY < this.MAZE_HEIGHT &&
				newZ >= 0 &&
				newZ < this.MAZE_LENGTH
			) {
				neighbors.push(this.maze[newY][newX][newZ]);
			}
		}

		return neighbors;
	}
}
