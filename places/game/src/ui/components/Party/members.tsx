import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Players } from "@rbxts/services";

interface PartyMembersProps {
	memberCount: number;
}

async function GetUserThumbnailAsync(userId: string): Promise<string> {
	const thumbType = Enum.ThumbnailType.HeadShot;
	const thumbSize = Enum.ThumbnailSize.Size420x420;
	const result = await Players.GetUserThumbnailAsync(tonumber(userId)!, thumbType, thumbSize);
	return result[0];
}

//TODO: going 8 or more makes UI skulls out of place. thankfully it's max 7 for now, looks ok.

//should be an API that gets the party members ID's
const user_ids = ["11697914", "682379885", "1341618742", "2847222519"];

const PartyMembers: Hooks.FC<PartyMembersProps> = (props, { useState, useEffect }) => {
	// 1. State Management
	/*
    This will prevent blocking the main thread while we fetch the thumbnails.
    */
	const [thumbnails, setThumbnails] = useState<string[]>(user_ids.map(() => undefined as unknown as string));

	// 2. UseEffect for Asynchronous Data Fetching
	useEffect(() => {
		// Use a traditional for-loop to have better control over async operations
		const loadThumbnails = async () => {
			for (let i = 0; i < user_ids.size(); i++) {
				const id = user_ids[i];
				const thumbnail = await GetUserThumbnailAsync(id);
				// eslint-disable-next-line roblox-ts/lua-truthiness
				if (thumbnail) {
					setThumbnails((prev) => {
						const updated = [...prev];
						updated[i] = thumbnail;
						return updated;
					});
				}
			}
		};

		loadThumbnails();
	}, []);

	return (
		<frame
			Key={"PartyMembers"}
			Position={new UDim2(0, 0, 0.8, 0)}
			Size={new UDim2(0.15, 0, 0.5, 0)}
			AnchorPoint={new Vector2(0, 1)}
			BackgroundColor3={Color3.fromRGB(75, 75, 75)}
			BackgroundTransparency={1}
		>
			<uilistlayout FillDirection={Enum.FillDirection.Vertical} SortOrder={Enum.SortOrder.LayoutOrder} />
			{thumbnails.map((thumbnail, index) => {
				return (
					<imagelabel
						Size={UDim2.fromOffset(70, 70)}
						ZIndex={3}
						// eslint-disable-next-line roblox-ts/lua-truthiness
						Image={thumbnail || "rbxassetid://6127325184"}
						LayoutOrder={index}
					></imagelabel>
				);
			})}
		</frame>
	);
};

export default new Hooks(Roact)(PartyMembers);
