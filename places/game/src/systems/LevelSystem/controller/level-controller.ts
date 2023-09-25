// LevelSystemController.ts
import { Controller, OnInit, OnStart } from "@flamework/core";
import Remotes from "shared/remotes";
import * as segmentHandlers from "../manager/segment-handlers";
import { params } from "../manager/parameters-dev";

// Enabling Reflection to get the handlers from the segment-handlers.ts file
type HandlerFunction = (...args: unknown[]) => void;
type Handler = (segmentModel: Segment) => Promise<void>;
type ParamsType = { [key: string]: { sequential: Handler[]; concurrent: Handler[] } };
type SegmentHandlersType = {
	[Key in keyof typeof segmentHandlers]: HandlerFunction;
};

type Segment = {
	model: Model;
	regionPart: BasePart;
	players: Player[];
};

const playerLocationEvent = Remotes.Client.Get("PlayerLocationEvent");

@Controller()
export default class LevelSystemController implements OnInit, OnStart {
	constructor() {}

	onInit(): void {}
	onStart(): void {
		print("LevelSystem Controller started");
		// Print the params
		print(params); // TODO: our PCG system is scuffed
		// is client-sided, so EACH client has their own unique events...

		playerLocationEvent.Connect((player, location, segmentModel) => {
			print(`${player.Name} is in ${location}`);
			this.handleSegmentChange(location, segmentModel);
		});
	}

	//Viva la REFLECTION!!!

	private async handleSegmentChange(segment: string, segmentModel: Segment): Promise<void> {
		if ((params as ParamsType)[segment]) {
			const segmentParams = (params as ParamsType)[segment];

			// Handle sequential events first
			for (const handler of segmentParams.sequential) {
				await handler(segmentModel);
			}

			// Once sequential events are done, execute the remaining handlers simultaneously
			await Promise.all(segmentParams.concurrent.map((handler: Handler) => handler(segmentModel)));
		} else {
			print(`No parameter found for segment ${segment}`);
		}
	}
}
