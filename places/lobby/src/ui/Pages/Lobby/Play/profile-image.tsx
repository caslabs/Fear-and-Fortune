import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";

interface ItemsProps {
	data: Player;
}

function GetUserThumbnailAsync(userId: string) {
	const thumbType = Enum.ThumbnailType.HeadShot;
	const thumbSize = Enum.ThumbnailSize.Size420x420;
	return Players.GetUserThumbnailAsync(tonumber(userId)!, thumbType, thumbSize);
}

const ProfileImage: Hooks.FC<ItemsProps> = (props, { useEffect, useState }) => {
	return (
		<frame
			Key={`GridImageComponent-Image-4`}
			Size={UDim2.fromScale(0.1, 0.1)}
			BackgroundTransparency={0}
			BackgroundColor3={Color3.fromRGB(245, 245, 245)}
		>
			<imagelabel
				AnchorPoint={new Vector2(0.5, 0)}
				Size={UDim2.fromScale(0.85, 0.85)}
				Position={UDim2.fromScale(0.5, 0.05)}
				BackgroundTransparency={0}
				BackgroundColor3={new Color3(0.27, 0.23, 0.23)}
				BorderSizePixel={0}
				Image={GetUserThumbnailAsync(tostring(props.data.UserId))[0]}
			>
				<frame
					Size={UDim2.fromScale(1, 1)}
					BackgroundTransparency={0.8}
					BorderSizePixel={0}
					BackgroundColor3={Color3.fromRGB(60, 72, 0)}
				/>
			</imagelabel>
		</frame>
	);
};

export default new Hooks(Roact)(ProfileImage);
