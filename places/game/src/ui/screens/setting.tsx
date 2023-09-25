import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Players } from "@rbxts/services";
import { Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";
import Remotes from "shared/remotes";

interface SettingProps {
	visible?: boolean;
}

/*
Load from SettingMechanic

*/
const Setting: Hooks.FC<SettingProps> = (props, { useState, useEffect }) => {
	const [soundVolume, setSoundVolume] = useState<string>("10");
	const [ambienceVolume, setAmbienceVolume] = useState<string>("10");
	const [musicVolume, setMusicVolume] = useState<string>("10");
	const [fov, setFov] = useState<string>("70");

	const textboxRef = Roact.createRef<TextBox>();

	return (
		<Panel Key={"Setting"} index={Pages.setting} visible={props.visible}>
			<textbutton Modal={true} BackgroundTransparency={1} Size={new UDim2(0, 0, 0, 0)} />
			<frame
				Key={"Setting"}
				Size={new UDim2(0.4, 0, 0.7, 0)}
				Position={UDim2.fromScale(0.5, 0.5)}
				AnchorPoint={new Vector2(0.5, 0.5)}
				BorderSizePixel={0}
				BackgroundTransparency={0}
				BackgroundColor3={Color3.fromRGB(26, 26, 26)}
			>
				<scrollingframe
					Size={UDim2.fromScale(1, 1)} // Adjust to make room for crafting info
					Position={UDim2.fromScale(0, 0)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
					ScrollBarThickness={6}
					BackgroundColor3={Color3.fromRGB(0, 0, 0)}
				>
					<uilistlayout
						FillDirection={Enum.FillDirection.Vertical}
						HorizontalAlignment={Enum.HorizontalAlignment.Center}
						SortOrder={Enum.SortOrder.LayoutOrder}
						VerticalAlignment={Enum.VerticalAlignment.Top}
						Padding={new UDim(0, 4)}
					/>

					<textlabel Text="Audio" Size={new UDim2(1, 0, 0, 30)} FontSize={Enum.FontSize.Size24} />

					<frame Size={new UDim2(1, 0, 0, 30)} Position={new UDim2(0, 0, 0.1, 0)}>
						<textlabel
							Text="Music"
							Size={new UDim2(0.6, 0, 1, 0)}
							TextXAlignment={Enum.TextXAlignment.Left}
						/>
						<textbox
							Text={musicVolume}
							Size={UDim2.fromScale(0.2, 0.12)}
							Position={UDim2.fromScale(0.3, 0.4)}
							TextSize={12}
							Font={Enum.Font.SourceSansBold}
							TextColor3={Color3.fromRGB(200, 200, 200)}
							BackgroundTransparency={0.5}
							BackgroundColor3={Color3.fromRGB(40, 40, 40)}
							ClearTextOnFocus={true}
							Ref={textboxRef} // Add this
							TextWrapped={true}
						/>
					</frame>

					<frame Size={new UDim2(1, 0, 0, 30)} Position={new UDim2(0, 0, 0.1, 0)}>
						<textlabel
							Text="Sound"
							Size={new UDim2(0.6, 0, 1, 0)}
							TextXAlignment={Enum.TextXAlignment.Left}
						/>
						<textbox
							Text={soundVolume}
							Size={UDim2.fromScale(0.2, 0.12)}
							Position={UDim2.fromScale(0.3, 0.4)}
							TextSize={12}
							Font={Enum.Font.SourceSansBold}
							TextColor3={Color3.fromRGB(200, 200, 200)}
							BackgroundTransparency={0.5}
							BackgroundColor3={Color3.fromRGB(40, 40, 40)}
							ClearTextOnFocus={true}
							Ref={textboxRef} // Add this
							TextWrapped={true}
						/>
					</frame>

					<frame Size={new UDim2(1, 0, 0, 30)} Position={new UDim2(0, 0, 0.1, 0)}>
						<textlabel
							Text="Ambience"
							Size={new UDim2(0.6, 0, 1, 0)}
							TextXAlignment={Enum.TextXAlignment.Left}
						/>
						<textbox
							Text={ambienceVolume}
							Size={UDim2.fromScale(0.2, 0.12)}
							Position={UDim2.fromScale(0.3, 0.4)}
							TextSize={12}
							Font={Enum.Font.SourceSansBold}
							TextColor3={Color3.fromRGB(200, 200, 200)}
							BackgroundTransparency={0.5}
							BackgroundColor3={Color3.fromRGB(40, 40, 40)}
							ClearTextOnFocus={true}
							Ref={textboxRef} // Add this
							TextWrapped={true}
						/>
					</frame>

					<textlabel Text="Game" Size={new UDim2(1, 0, 0, 30)} FontSize={Enum.FontSize.Size24} />

					<frame Size={new UDim2(1, 0, 0, 30)} Position={new UDim2(0, 0, 0.1, 0)}>
						<textlabel
							Text="FOV"
							Size={new UDim2(0.6, 0, 1, 0)}
							TextXAlignment={Enum.TextXAlignment.Left}
						/>
						<textbox
							Text={fov}
							Size={UDim2.fromScale(0.2, 0.12)}
							Position={UDim2.fromScale(0.3, 0.4)}
							TextSize={12}
							Font={Enum.Font.SourceSansBold}
							TextColor3={Color3.fromRGB(200, 200, 200)}
							BackgroundTransparency={0.5}
							BackgroundColor3={Color3.fromRGB(40, 40, 40)}
							ClearTextOnFocus={true}
							Ref={textboxRef} // Add this
							TextWrapped={true}
						/>
					</frame>
				</scrollingframe>
			</frame>
		</Panel>
	);
};

export default new Hooks(Roact)(Setting);
