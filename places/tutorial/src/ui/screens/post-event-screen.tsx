import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Remotes from "shared/remotes";
import { Context, Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";

interface TitleScreenProps {
	visible?: boolean;
}

//Post Event Screen

const PostEventScreen: Hooks.FC<TitleScreenProps> = (props, { useState }) => {
	const barHeightRatio = 0.1;
	print("Initiated Post Event Screen");

	return (
		<Context.Consumer
			render={(value: { viewIndex: number; setPage: (index: number) => void }) => {
				return (
					<Panel index={Pages.titleScreen} visible={props.visible}>
						<frame
							Size={new UDim2(1, 0, barHeightRatio, 0)}
							Position={new UDim2(0, 0, 0, 0)}
							BackgroundColor3={new Color3(0, 0, 0)}
							BorderSizePixel={0}
						/>
						<frame
							Size={new UDim2(1, 0, barHeightRatio, 0)}
							Position={new UDim2(0, 0, 1 - barHeightRatio, 0)}
							BackgroundColor3={new Color3(0, 0, 0)}
							BorderSizePixel={0}
						>
							<textbutton
								Text={"You Lost!"}
								Size={new UDim2(0.2, 0, 1, 0)}
								Position={new UDim2(0.4, 0, -1.5, 0)}
								Event={{
									MouseButton1Click: () => {
										value.setPage(Pages.play);
									},
								}}
							/>
						</frame>
					</Panel>
				);
			}}
		></Context.Consumer>
	);
};

export default new Hooks(Roact)(PostEventScreen);
