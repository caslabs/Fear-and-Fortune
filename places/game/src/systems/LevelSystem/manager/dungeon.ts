/**
 * Dungeon generator
 * Dungeon generator module for Roblox.
 * @author EgoMoose
 * @link N/A
 * @date 12/02/2016
 */

// Setup
export {};
const cardinal = {
	north: new Vector2(0, 1),
	east: new Vector2(1, 0),
	south: new Vector2(0, -1),
	west: new Vector2(-1, 0),
};

export const enums = {
	empty: 0,
	hall: 1,
	room: 2,
	junction: 3,
};

// Classes
class Tile {
	position: Vector2;
	enum: number;
	region: number;
	directions: { north: boolean; east: boolean; south: boolean; west: boolean; [key: string]: boolean };

	constructor(pos: Vector2, enumVal: number, region: number) {
		this.position = pos;
		this.enum = enumVal;
		this.region = region;
		this.directions = {
			north: false,
			east: false,
			south: false,
			west: false,
		};
	}
}

class Tiles {
	private tiles: { [key: string]: Tile } = {};

	setTiles(origin: Vector2, enumVal: number, region?: number, width?: number, height?: number) {
		// eslint-disable-next-line roblox-ts/lua-truthiness
		width = width || 0;
		// eslint-disable-next-line roblox-ts/lua-truthiness
		height = height || 0;
		for (let x = 0; x <= width; x++) {
			for (let y = 0; y <= height; y++) {
				const pos = origin.add(new Vector2(x, y));
				const key = tostring(pos);
				if (!this.tiles[key]) {
					this.tiles[key] = new Tile(pos, enumVal, region!);
				} else {
					const tile = this.tiles[key];
					tile.position = pos;
					tile.enum = enumVal;
					tile.region = region!;
					tile.directions = {
						north: false,
						east: false,
						south: false,
						west: false,
					};
				}
			}
		}
	}

	getEnum(pos: Vector2) {
		const tile = this.tiles[tostring(pos)];
		if (tile) {
			return tile.enum;
		}
	}

	getAllTiles(enumVal?: number) {
		const tiles = [];
		for (const [pos, tile] of pairs(this.tiles)) {
			// eslint-disable-next-line roblox-ts/lua-truthiness
			if ((tile instanceof Tile && tile.enum === enumVal) || !enumVal) {
				tiles.push(tile);
			}
		}
		return tiles;
	}

	getTiles(enumVal: number) {
		const tiles = [];
		for (const [pos, tile] of pairs(this.tiles)) {
			if (tile instanceof Tile && tile.enum === enumVal) {
				tiles.push(tile);
			}
		}
		return tiles;
	}

	getTile(pos: Vector2) {
		return this.tiles[tostring(pos)];
	}

	getAllTilesIgnore(enumVal: number) {
		const tiles = [];
		for (const [pos, tile] of pairs(this.tiles)) {
			if (tile instanceof Tile && tile.enum !== enumVal) {
				tiles.push(tile);
			}
		}
		return tiles;
	}
}

// Class Rectangle and DungeonGen will be converted in a subsequent step

class Rectangle {
	position: Vector2;
	size: Vector2;
	corners: Vector2[];

	constructor(x: number, y: number, width: number, height: number) {
		this.position = new Vector2(x, y);
		this.size = new Vector2(width, height);
		this.corners = [
			this.position,
			this.position.add(new Vector2(width, 0)),
			this.position.add(new Vector2(0, height)),
			this.position.add(this.size),
		];
	}

	private static dot2d(a: Vector2, b: Vector2) {
		return a.X * b.X + a.Y * b.Y;
	}

	private static getAxis(c1: Vector2[], c2: Vector2[]) {
		const axis: Vector2[] = [];
		axis[0] = c1[1].sub(c1[0]);
		axis[1] = c1[1].sub(c1[2]);
		axis[2] = c2[0].sub(c2[3]);
		axis[3] = c2[0].sub(c2[1]);
		return axis;
	}

	collidesWith(other: Rectangle) {
		const scalars: number[][] = [];
		const axis = Rectangle.getAxis(this.corners, other.corners);
		for (let i = 0; i < axis.size(); i++) {
			for (const set of [this.corners, other.corners]) {
				scalars[i] = [];
				for (const point of set) {
					const v = Rectangle.dot2d(point, axis[i]);
					scalars[i].push(v);
				}
			}

			//TODO: Dungeon Generation does not work; need more research
			const s1max = math.max(...scalars[0]),
				s1min = math.min(...scalars[0]);
			const s2max = math.max(...scalars[1]),
				s2min = math.min(...scalars[1]);
			if (s2min > s1max || s2max < s1min) {
				return false;
			}
		}
		return true;
	}
}

// DungeonGen will be converted in a subsequent step.
class DungeonGen {
	private currentRegion: number;
	private tiles: Tiles;
	roomSize: number;
	enums: typeof enums;
	lastSeed: number;
	windingPercent: number;
	attemptRoomNum: number;
	loadBuffer: number;
	genMapDirections: boolean;
	seed: () => number;
	bounds: { width: number; height: number };

	constructor() {
		this.roomSize = 3;
		this.enums = enums;
		this.lastSeed = 0;
		this.windingPercent = 0;
		this.attemptRoomNum = 20;
		this.loadBuffer = math.huge;
		this.genMapDirections = true;
		this.seed = () => tick();
		this.bounds = {
			width: 100,
			height: 100,
		};
		this.currentRegion = 0;
		this.tiles = new Tiles();
	}

	private newRegion() {
		this.currentRegion += 1;
	}

	private boundsContains(pos: Vector2) {
		return !(pos.X > this.bounds.width || pos.Y > this.bounds.height || pos.X < 0 || pos.Y < 0);
	}

	private canCarve(pos: Vector2, direction: Vector2) {
		return this.boundsContains(pos.add(direction.mul(3))) && this.tiles.getEnum(pos.add(direction.mul(2))) === 0;
	}

	/*
	Dungeon Room Creation

	TODO: DOES NOT WORK. FIX OVERLAP
	*/
	private createRooms() {
		const rooms: Rectangle[] = [];

		for (let i = 0; i < this.attemptRoomNum; i++) {
			const size = math.random(this.roomSize) * 2 + 1;
			const rectangularity = math.random(1 + math.floor(size / 2)) * 2;
			let width = size,
				height = size;
			if (math.random(2) === 1) {
				width += rectangularity;
			} else {
				height += rectangularity;
			}

			const x = math.random(math.floor((this.bounds.width - width) / 2)) * 2 + 1;
			const y = math.random(math.floor((this.bounds.height - height) / 2)) * 2 + 1;
			const room = new Rectangle(x, y, width, height);

			let overlapping = false;
			for (const other of rooms) {
				if (room.collidesWith(other)) {
					overlapping = true;
					break;
				}
			}

			if (!overlapping) {
				this.newRegion();
				rooms.push(room);
				this.tiles.setTiles(
					room.position,
					this.enums.room,
					this.currentRegion,
					room.size.X - 1,
					room.size.Y - 1,
				);
			}
		}
	}

	// other methods will be continued in the next step

	private growMaze(pos: Vector2) {
		this.tiles.setTiles(pos, this.enums.hall, this.currentRegion);
		let lastDirection: Vector2 | undefined;
		const cells: Tile[] = [this.tiles.getTile(pos)];

		// spanning tree algorithm
		while (cells.size() > 0) {
			const cell = cells[cells.size() - 1];
			const potential: Vector2[] = [];

			for (const direction of pairs(cardinal)) {
				if (this.canCarve(cell.position, direction as unknown as Vector2)) {
					potential.push(direction as unknown as Vector2);
				}
			}

			if (potential.size() > 0) {
				let direction: Vector2;
				if (lastDirection && potential.includes(lastDirection) && math.random() * 100 > this.windingPercent) {
					direction = lastDirection;
				} else {
					direction = potential[math.floor(math.random() * potential.size())];
				}

				this.tiles.setTiles(cell.position.add(direction), this.enums.hall, this.currentRegion);
				this.tiles.setTiles(cell.position.add(direction.mul(2)), this.enums.hall, this.currentRegion);
				cells.push(this.tiles.getTile(cell.position.add(direction.mul(2))));

				lastDirection = direction;
			} else {
				cells.pop();
				lastDirection = undefined;
			}
		}
	}

	private connectRegions() {
		const connectors: { [key: string]: number[] } = {};
		let connectedPoints: Tile[] = [];

		// collect regions that can be connected
		for (const tile of this.tiles.getAllTiles(this.enums.empty)) {
			const regions: { [key: number]: boolean } = {};
			for (const [name, direction] of pairs(cardinal)) {
				const ntile = this.tiles.getTile(tile.position.add(direction));
				if (ntile && ntile.enum > 0 && ntile.region) {
					regions[ntile.region] = true;
				}
			}

			const open: number[] = [];
			for (const [k, v] of pairs(regions)) {
				open.push(k);
			}
			if (open.size() === 2) {
				connectedPoints.push(tile);
				connectors[tostring(tile.position)] = open;
			}
		}

		// place our connections/smooth
		while (connectedPoints.size() > 1) {
			const index = math.floor(math.random() * connectedPoints.size());
			const tile = connectedPoints[index];
			const region = connectors[tostring(tile.position)];

			this.tiles.setTiles(tile.position, this.enums.junction);
			connectedPoints = connectedPoints.filter((_, i) => i !== index);

			for (let i = 0; i < connectedPoints.size(); i++) {
				if (i !== index) {
					const open = connectors[tostring(connectedPoints[i].position)];
					if (open.includes(region[0]) && open.includes(region[1])) {
						connectedPoints = connectedPoints.filter((_, i) => i !== index);
					}
				}
			}

			for (const otile of this.tiles.getAllTiles(this.enums.junction)) {
				if (tile.position === tile.position) {
					if (otile.position.sub(tile.position).Magnitude < 1.1) {
						this.tiles.setTiles(otile.position, this.enums.empty);
					}
				}
			}
		}
	}

	private removeDeadEnds() {
		let done = false;
		let c = 0;
		let maze = this.tiles.getAllTiles(this.enums.hall);

		while (!done) {
			done = true;
			for (let i = 0; i < maze.size(); i++) {
				const tile = maze[i];
				c += 1;
				let exits = 0;

				for (const [, directionVector] of pairs(cardinal)) {
					const ntile = this.tiles.getTile(tile.position.add(directionVector));
					// eslint-disable-next-line roblox-ts/lua-truthiness
					if (ntile && ntile.enum !== this.enums.empty) {
						exits += 1;
					}
				}

				if (c % this.loadBuffer === 0) {
					// equivalent of Lua's wait function might be needed here
				}

				if (exits <= 1) {
					maze = maze.filter((_, i) => i !== i);
					this.tiles.setTiles(tile.position, this.enums.empty, undefined);
					done = false;
					break;
				}
			}
		}
	}

	private mapDirections() {
		for (const tile of this.tiles.getAllTilesIgnore(this.enums.empty)) {
			for (const [name, direction] of pairs(cardinal)) {
				const ntile = this.tiles.getTile(tile.position.add(direction));
				// eslint-disable-next-line roblox-ts/lua-truthiness
				if (ntile && ntile.enum !== this.enums.empty) {
					tile.directions[tostring(name)] = true;
				}
			}
		}
	}

	public generate() {
		// Set random seed
		this.lastSeed = this.seed();
		math.randomseed(this.lastSeed);

		// Generate initial
		this.tiles.setTiles(new Vector2(0, 0), enums.empty, this.currentRegion, this.bounds.width, this.bounds.height);
		this.createRooms();
		this.newRegion();

		// Start maze
		for (const tile of this.tiles.getAllTiles(enums.empty)) {
			// Must be odd number position
			const pos = tile.position;
			if (pos.X % 2 === 1 && pos.Y % 2 === 1 && tile.enum === enums.empty) {
				this.growMaze(pos);
			}
		}

		// Smooth and find final
		this.connectRegions();
		this.removeDeadEnds();
		if (this.genMapDirections) {
			this.mapDirections();
		}

		// Return tile set
		return this.tiles;
	}
}

export default DungeonGen;
