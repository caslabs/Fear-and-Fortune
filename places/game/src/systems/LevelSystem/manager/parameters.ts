import { handlers } from "../manager/segment-handlers";

const slice = <T>(arr: T[], start: number, endPos: number): T[] => {
	const result: T[] = [];
	for (let i = start; i < endPos; i++) {
		result.push(arr[i]);
	}
	return result;
};

const randomizeHandlers = (handlers: Array<() => Promise<void>>) => {
	let currentIndex = handlers.size(),
		randomIndex;

	while (currentIndex !== 0) {
		randomIndex = math.floor(math.random() * currentIndex);
		currentIndex--;

		[handlers[currentIndex], handlers[randomIndex]] = [handlers[randomIndex], handlers[currentIndex]];
	}

	return handlers;
};

export const params: {
	[segment: string]: { sequential: Array<() => Promise<void>>; concurrent: Array<() => Promise<void>> };
} = {};

for (const segment of ["LevelSegment1", "LevelSegment2"]) {
	const randomizedHandlers = randomizeHandlers([...handlers]);
	const halfWayThrough = math.floor(randomizedHandlers.size() / 2);
	params[segment] = {
		sequential: slice(randomizedHandlers, 0, halfWayThrough),
		concurrent: slice(randomizedHandlers, halfWayThrough, randomizedHandlers.size()),
	};
}
