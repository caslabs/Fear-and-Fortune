import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Lighting } from "@rbxts/services";
import { Context, Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";
import { setIsCurrentlyOpen } from "../Shop/shop-manager";
import CloseShop from "ui/Panels/Close-Shop";

//TODO: Designing a Dialog Tree - Graph ADT
// see https://developer.roblox.com/en-us/articles/Designing-a-Dialog-Tree

interface DialogBoxProp {
	visible?: boolean;
}

const DialogBox: Hooks.FC<DialogBoxProp> = (props, { useState, useEffect }) => {
	const [text, setText] = useState("");
	const [fullText, setFullText] = useState("What can I do for you?");
	print("DialogBox initialized");

	//TODO: Polish text animation
	useEffect(() => {
		task.spawn(() => {
			fullText.split("").forEach((char) => {
				task.wait(0.015);
				setText((prev) => prev + char);
			});
		});
	}, []);
	return (
		<Context.Consumer
			render={(value: { viewIndex: number; setPage: (index: number) => void }) => {
				return (
					<Panel Key={"Shop"} index={Pages.dialog} visible={props.visible}>
						<frame
							Key="DialogBox"
							AnchorPoint={new Vector2(0.5, 0.5)}
							BackgroundColor3={Color3.fromRGB(70, 70, 70)}
							BorderSizePixel={0}
							Position={new UDim2(0.5, 0, 0.6, 0)}
							Size={new UDim2(0, 504, 0, 150)}
						>
							<uicorner Key="1" CornerRadius={new UDim(0, 6)} />
							<uipadding
								Key="2"
								PaddingBottom={new UDim(0, 12)}
								PaddingLeft={new UDim(0, 12)}
								PaddingRight={new UDim(0, 12)}
								PaddingTop={new UDim(0, 12)}
							/>
							<CloseShop />
							<frame
								Key="DialogText"
								AnchorPoint={new Vector2(0, 1)}
								BackgroundTransparency={1}
								Position={new UDim2(0, 0, 1, 0)}
								Size={new UDim2(1, 0, 1, -46)}
							>
								<scrollingframe
									Key="ScrollignFrame"
									BackgroundTransparency={1}
									CanvasPosition={new Vector2(0, 20)}
									CanvasSize={new UDim2(0, 468, 0, 150)}
									HorizontalScrollBarInset={Enum.ScrollBarInset.ScrollBar}
									LayoutOrder={1}
									ScrollBarThickness={10}
									ScrollingDirection={Enum.ScrollingDirection.Y}
									Size={new UDim2(1, 0, 0.8, 0)}
								>
									<textbutton
										Key="ShopDialog"
										BackgroundColor3={Color3.fromRGB(255, 255, 255)}
										Font={Enum.Font.SourceSans}
										LayoutOrder={0}
										Size={new UDim2(0, 200, 0, 30)}
										Text="Show me your goodies"
										TextColor3={Color3.fromRGB(0, 0, 0)}
										TextSize={14}
										Event={{
											MouseButton1Click: () => {
												//TODO: Clicking the shop toggle button should close the dialog box? Only makes the blurry effect.
												const index = Pages.merchant;
												value.setPage(index);
											},
										}}
									/>
									<textbutton
										Key="ChatDialog"
										BackgroundColor3={Color3.fromRGB(255, 255, 255)}
										Font={Enum.Font.SourceSans}
										LayoutOrder={1}
										Size={new UDim2(0, 200, 0, 30)}
										Text="What's the top news today?"
										Event={{
											MouseButton1Click: () => {
												//TODO: Prototype of chat box sequence. Double Click initializes and Spam Clicking results in a bug.
												task.spawn(() => {
													fullText.split("").forEach((char) => {
														task.wait(0.015);
														setText((prev) => prev + char);
													});
												});
											},
										}}
										TextColor3={Color3.fromRGB(0, 0, 0)}
										TextSize={14}
									/>
									<textbutton
										Key="AboutDialog"
										BackgroundColor3={Color3.fromRGB(255, 255, 255)}
										Font={Enum.Font.SourceSans}
										LayoutOrder={2}
										Size={new UDim2(0, 200, 0, 30)}
										Text="Who are you again?"
										TextColor3={Color3.fromRGB(0, 0, 0)}
										TextSize={14}
									/>
									<uilistlayout Padding={new UDim(0, 2)} SortOrder={Enum.SortOrder.LayoutOrder} />
									<textbutton
										Key="GoodbyeDialogue"
										BackgroundColor3={Color3.fromRGB(255, 255, 255)}
										Font={Enum.Font.SourceSans}
										LayoutOrder={999}
										Size={new UDim2(0, 200, 0, 30)}
										Text="Goodbye"
										TextColor3={Color3.fromRGB(0, 0, 0)}
										TextSize={14}
										Event={{
											MouseButton1Click: () => {
												value.setPage(Pages.none);
												setIsCurrentlyOpen(false);
												//sound.Play();
											},
										}}
									/>
								</scrollingframe>
								<textlabel
									BackgroundTransparency={1}
									Font={Enum.Font.SourceSans}
									Size={new UDim2(1, 0, 0.3, 0)}
									Text={text}
									TextColor3={Color3.fromRGB(0, 0, 0)}
									TextSize={25}
									TextXAlignment={Enum.TextXAlignment.Left}
								/>
								<uilistlayout SortOrder={Enum.SortOrder.LayoutOrder} />
							</frame>
						</frame>
					</Panel>
				);
			}}
		></Context.Consumer>
	);
};

export default new Hooks(Roact)(DialogBox);
