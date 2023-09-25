/*
import { OnStart, Service, OnInit } from "@flamework/core";
import { RunService, Workspace, Players } from "@rbxts/services";
import Remotes from "shared/remotes";
import { params } from "../manager/parameters";

type Segment = {
	model: Model;
	regionPart: BasePart;
	players: Player[];
};

const playerLocationEvent = Remotes.Server.Get("PlayerLocationEvent");

// Checks if a point is in a region
function isPointInRegion3(point: Vector3, region: Region3): boolean {
	const min = region.CFrame.Position.sub(region.Size.div(2));
	const max = region.CFrame.Position.add(region.Size.div(2));

	return (
		point.X >= min.X &&
		point.X <= max.X &&
		point.Y >= min.Y &&
		point.Y <= max.Y &&
		point.Z >= min.Z &&
		point.Z <= max.Z
	);
}

const characterHeightWithJumpBuffer = 50; // Ignore when the player jumps, still in bounds

@Service({})
export default class LevelSystemService implements OnStart, OnInit {
	private playerCurrentSegment: Map<Player, string> = new Map();

	private segments: Segment[] = [];

	public onInit(): void | Promise<void> {
		const LevelSegmentModel = game.GetService("ServerStorage").FindFirstChild("LevelSegment");
		if (!LevelSegmentModel) {
			warn("LevelSegmentModel not found in ServerStorage");
			return;
		}

		//TODO: very hacky, fix later - had to hard-code the positions for now.
		// Will change when I have a assets for the levels
		let currentPosition = new Vector3(-368.221, 285.817, 1595.267);
		const segmentDepth = 698.999 - 584.438;
		const overlap = 10; // Overlap of 10 units in the Z direction

		// TODO: Make this data-driven. For now, it creates 10 LevelSegments in a row.
		for (let i = 0; i < 10; i++) {
			// Add Level Segments to the workspace
			const newSegment = LevelSegmentModel.Clone() as Model;
			newSegment.Name = `LevelSegment${i + 1}`;
			newSegment.SetPrimaryPartCFrame(new CFrame(currentPosition));
			newSegment.Parent = Workspace;
			const [cframe, size] = newSegment.GetBoundingBox();

			// Create a region part 'Partitioning' per LevelSegment
			const regionPart = new Instance("Part");
			regionPart.Size = new Vector3(size.X, size.Y + characterHeightWithJumpBuffer, size.Z + overlap);
			regionPart.Position = new Vector3(
				cframe.Position.X,
				cframe.Position.Y + characterHeightWithJumpBuffer / 2,
				cframe.Position.Z + overlap / 2,
			);
			regionPart.Transparency = 1;
			regionPart.Anchored = true;
			regionPart.CanCollide = false;
			regionPart.Parent = newSegment;

			// Add the LevelSegment and regionPart to the segments array
			this.segments.push({ model: newSegment, regionPart: regionPart, players: [] });

			// Update the current position, to create the next LevelSegment
			currentPosition = currentPosition.add(new Vector3(0, 0, segmentDepth));

			//TODO: A bit of a hack, but we also define a region 'partioning' for our built in Tutorial Node
			const TutorialNodeModel = Workspace.FindFirstChild("TutorialNode") as Model;

			if (!TutorialNodeModel) {
				warn("TutorialNodeModel not found in Workspace");
				return;
			}

			//TODO: A bit of a hack, but we also define a region 'partioning' for our built in Tutorial Node
			const BaseCampNodeModel = Workspace.FindFirstChild("BaseCampNode") as Model;

			if (!TutorialNodeModel) {
				warn("BaseCampNodeModel not found in Workspace");
				return;
			}

			// Add TutorialNode Region Partioning to the segments array
			const [cframe1, size2] = TutorialNodeModel.GetBoundingBox();
			const tutorialNode = new Instance("Part");
			tutorialNode.Size = new Vector3(size2.X, size2.Y + characterHeightWithJumpBuffer, size2.Z);
			tutorialNode.Position = cframe1.Position;
			tutorialNode.Transparency = 1;
			tutorialNode.Anchored = true;
			tutorialNode.CanCollide = false;
			tutorialNode.Parent = TutorialNodeModel;
			this.segments.push({ model: TutorialNodeModel, regionPart: tutorialNode, players: [] });

			// Add BaseCamp Region
			const [cframe2, size3] = BaseCampNodeModel.GetBoundingBox();
			const baseCampNode = new Instance("Part");
			baseCampNode.Size = new Vector3(size3.X, size3.Y + characterHeightWithJumpBuffer, size3.Z);
			baseCampNode.Position = cframe2.Position;
			baseCampNode.Transparency = 1;
			baseCampNode.Anchored = true;
			baseCampNode.CanCollide = false;
			baseCampNode.Parent = BaseCampNodeModel;
			this.segments.push({ model: BaseCampNodeModel, regionPart: baseCampNode, players: [] });
		}
	}

	public onStart() {
		// Check if the player is in a segment via a simple space partioning system using states
		RunService.Heartbeat.Connect(() => {
			for (const player of Players.GetPlayers()) {
				const character = player.Character;
				if (!character) {
					continue;
				}

				const humanoidRootPart = character.FindFirstChild("HumanoidRootPart") as BasePart;
				if (!humanoidRootPart) {
					continue;
				}

				// Track the current segment for the player
				let newSegment: string | undefined = undefined;

				// Space Partioning System
				// Check if the player is in any of the segments
				for (const segment of this.segments) {
					// Create a region for the segment
					const region = new Region3(
						segment.regionPart.Position.sub(segment.regionPart.Size.div(2)),
						segment.regionPart.Position.add(segment.regionPart.Size.div(2)),
					);

					// Check if the player is in the region via our collision point box check
					if (isPointInRegion3(humanoidRootPart.Position, region)) {
						newSegment = segment.model.Name; // Set the new segment
						if (!segment.players.includes(player)) {
							segment.players.push(player);
						}
						break;
					} else {
						if (segment.players.includes(player)) {
							// If the player was in the segment, but is no longer, remove them from the segment
							segment.players = segment.players.filter((p) => p !== player);
						}
					}
				}

				//TODO: A bit hard coded, but works for playtesting
				// If the player is not in any segment, check the tutorial node
				if (newSegment === undefined) {
					// If player is not in any segment, check the tutorial node
					const tutorialNode = Workspace.FindFirstChild("TutorialNode") as Model | undefined;
					if (tutorialNode) {
						const [cframe, size] = tutorialNode.GetBoundingBox();
						const tutorialRegion = new Region3(
							cframe.Position.sub(size.div(2)),
							cframe.Position.add(size.div(2)),
						);
						if (isPointInRegion3(humanoidRootPart.Position, tutorialRegion)) {
							newSegment = tutorialNode.Name;
						}
					}
				}

				// eslint-disable-next-line roblox-ts/lua-truthiness
				newSegment = newSegment || "None"; // If no segment was found, set it to "None"

				// Send the player location event to the player, to which handles any events
				if (this.playerCurrentSegment.get(player) !== newSegment) {
					this.playerCurrentSegment.set(player, newSegment);
					const segmentModel = this.segments.find((s) => s.model.Name === newSegment);

					if (segmentModel !== undefined) {
						playerLocationEvent.SendToPlayer(player, player, newSegment, segmentModel);
						print(this.playerCurrentSegment);
					}

					print(this.playerCurrentSegment);
				}
			}
		});
		print("LevelSystem Service started");
	}
}
*/
export {};
