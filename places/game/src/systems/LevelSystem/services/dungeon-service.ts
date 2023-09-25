/*
import { OnStart, Service, OnInit } from "@flamework/core";
import { Workspace, ServerStorage } from "@rbxts/services";
import DungeonGen from "../manager/dungeon";

const multiplier = 30;
const model = new Instance("Model", Workspace);
const pmodel = ServerStorage.WaitForChild("Model");

function v3(v2: Vector2) {
	return new Vector3(v2.X, 0, v2.Y);
}

function transformModel(model: Model, newCf: CFrame, center?: CFrame) {
	const center1 = center ?? model.GetModelCFrame();

	for (const child of model.GetChildren()) {
		if (child.IsA("BasePart")) {
			child.CFrame = newCf.ToWorldSpace(center1.ToObjectSpace(child.CFrame));
		}
		transformModel(child as Model, newCf, center1);
	}
}

function CFrameFromCorner(size: CFrame, cf: CFrame) {
	const s = size;
	const x = 1;
	const y = 1;
	const z = 1;
	return cf.mul(new CFrame(s.X * x, s.Y * y, s.Z * z));
}

@Service({})
export default class DungeonService implements OnStart, OnInit {
	public onInit(): void | Promise<void> {}

	public onStart() {
		this.generate();
		print("Maze generation complete!");
	}

	private generate() {
		print("Maze generation complete!");
		const dungeon = new DungeonGen();
		dungeon.loadBuffer = 500;
		dungeon.bounds.width = 30;
		dungeon.bounds.height = 30;
		dungeon.windingPercent = 100;
		dungeon.roomSize = 3;
		dungeon.attemptRoomNum = 100;

		const tiles = dungeon.generate();
		// eslint-disable-next-line roblox-ts/no-array-pairs
		for (const [n, index] of pairs([1, 2, 3])) {
			for (const tile of tiles.getAllTiles(index)) {
				const m = pmodel.Clone() as Model;
				m.SetPrimaryPartCFrame(
					CFrameFromCorner(m.GetBoundingBox()[0], new CFrame(v3(tile.position).mul(multiplier))),
				);
				m.Parent = model;
				for (const [name, direction] of pairs(tile.directions)) {
					const child = m.FindFirstChild(name);
					if (child && direction) {
						child.Destroy();
					}
				}
			}
		}
		transformModel(model, new CFrame());
	}
}
*/
export {};
