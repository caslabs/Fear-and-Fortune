import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
//TODO: This component uses Context from lobby. Needs to be independent.
import { Context, Pages } from "../Context";
interface CloseProps {}

// Close the page with this button, sets the value to 0 (0 = none)

const Close: Hooks.FC<CloseProps> = (props, { useState }) => {
	return (
		<Context.Consumer
			render={(value: { viewIndex: number; setPage: (index: number) => void }) => {
				return (
					<textbutton
						Key={"Close"}
						Text={""}
						Size={UDim2.fromOffset(40, 40)}
						AnchorPoint={new Vector2(1, 0)}
						Position={UDim2.fromScale(1, 0)}
						Event={{
							MouseButton1Click: () => {
								value.setPage(Pages.none);
								//TODO: Blur should be created here, and not be called in Lighting?
							},
						}}
					>
						<uicorner CornerRadius={new UDim(0, 6)} />
						<uipadding
							PaddingTop={new UDim(0, 6)}
							PaddingBottom={new UDim(0, 6)}
							PaddingLeft={new UDim(0, 6)}
							PaddingRight={new UDim(0, 6)}
						/>
						<imagelabel
							Key={"Icon"}
							Image={"http://www.roblox.com/asset/?id=5107150301"}
							Size={UDim2.fromScale(1, 1)}
							AnchorPoint={new Vector2(0.5, 0.5)}
							Position={UDim2.fromScale(0.5, 0.5)}
							BackgroundTransparency={1}
						/>
					</textbutton>
				);
			}}
		></Context.Consumer>
	);
};

export default new Hooks(Roact)(Close);
