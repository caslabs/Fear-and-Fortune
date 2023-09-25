import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { UserInputService, RunService } from "@rbxts/services";
import { Signals } from "shared/signals";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";
import { MusicKeys } from "systems/AudioSystem/MusicSystem/manager/MusicData";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";

interface CreditProps {}

const CreditScreen: Hooks.FC<CreditProps> = (props, hooks) => {
	const credits: Array<[string, string[]]> = [
		["Programmers", ["@qwertyman10"]],
		[
			"Beta Testers",
			[
				"@Umderstood",
				"- Game is fun",
				"@ItsSmolKin",
				"@wugglebuggle",
				"@stewie",
				"@Tigerflossss",
				"@ogmurasaki",
				"@koriii",
				"@RisaiahYT",
			],
		],
		["Voice Actors", ["@akaLVX"]],
		["Game Designers", ["@qwertyman10"]],
		["Lead Artists", ["@qwertyman10"]],
		["Music Composer", ["@qwertyman10"]],
		["Sound Designers", ["@qwertyman10"]],
		["Story and Screenplay", ["@qwertyman10"]],
		["Quality Assurance", ["@qwertyman10"]],
		["Technical Director", ["@qwertyman10"]],
		["Animation Director", ["@qwertyman10"]],
		["Art Director", ["@qwertyman10"]],
		["Project Manager", ["@qwertyman10"]],
		["Level Designers", ["@qwertyman10"]],
		["Community Manager", ["@qwertyman10"]],
		["Marketing Director", ["@qwertyman10"]],
		["Customer Support", ["@qwertyman10"]],
		["UX Designer", ["@qwertyman10"]],
		["UI Designer", ["@qwertyman10"]],
		["Gameplay Programmer", ["@qwertyman10"]],
		["Localization", ["@qwertyman10"]],
		["Legal", ["@qwertyman10"]],
		["Public Relations", ["@qwertyman10"]],
		["Twitter Code:", ["THANKYOU"]],
	];

	const [offset, setOffset] = hooks.useState(-0.1);
	const [creditMusicState, setCreditMusicState] = hooks.useState(false);
	const creditsText = "Fear and Fortune\n \n \n The Yeti of Mount Everest \n .gg/qtree";
	const delay = 0.5; // Delay in seconds

	hooks.useEffect(() => {
		const inputChangedConnection = UserInputService.InputBegan.Connect((input) => {
			if (
				input.UserInputType === Enum.UserInputType.MouseButton1 ||
				input.UserInputType === Enum.UserInputType.Touch
			) {
				Signals.OnCreditScreenExit.Fire();
				MusicSystemController.stopMusic(MusicKeys.CREDIT_MUSIC);
				MusicSystemController.playMusic(MusicKeys.LOBBY_MUSIC);
			}
		});

		return () => {
			inputChangedConnection.Disconnect();
		};
	}, []);

	hooks.useEffect(() => {
		if (creditMusicState) {
			return;
		}
		//Stop Lobby Music
		MusicSystemController.pauseMusic(MusicKeys.LOBBY_MUSIC);

		// Play the credits music
		MusicSystemController.playMusic(MusicKeys.CREDIT_MUSIC);
		setCreditMusicState(true);
	});

	hooks.useEffect(() => {
		let active = true;
		const connection = RunService.RenderStepped.Connect(() => {
			if (active) {
				setOffset((prevOffset) => prevOffset - 0.001); // Adjust the value to control the speed
			}
		});
		return () => {
			active = false;
			if (connection) {
				connection.Disconnect();
			}
		};
	}, []);

	const creditElements: Roact.Element[] = [];

	creditElements.push(
		<textlabel
			Key="CreditsText"
			Size={UDim2.fromScale(1, 0.1)}
			Text={creditsText}
			TextScaled={false}
			TextSize={30}
			Font={Enum.Font.SourceSansBold}
			TextColor3={Color3.fromRGB(255, 255, 255)}
			BackgroundTransparency={1}
			Position={new UDim2(0, 0, 0, 0)}
		/>,
	);

	let position = 0;
	const delayIncrement = 0.1;

	for (const [role, contributors] of credits) {
		creditElements.push(
			<textlabel
				Key={role}
				Size={UDim2.fromScale(1, 0.01)}
				Text={role}
				TextScaled={false}
				TextSize={24}
				Font={Enum.Font.SourceSansBold}
				TextColor3={Color3.fromRGB(255, 255, 255)}
				BackgroundTransparency={1}
				Position={new UDim2(0, 0, 0, position)}
				TextYAlignment={"Bottom"}
			/>,
		);

		position += delayIncrement;

		for (const name of contributors) {
			creditElements.push(
				<textlabel
					Key={`${role}_${name}`}
					Size={UDim2.fromScale(1, 0.005)}
					Text={name}
					TextScaled={false}
					TextSize={18}
					Font={Enum.Font.SourceSans}
					TextColor3={Color3.fromRGB(255, 255, 255)}
					BackgroundTransparency={1}
					Position={new UDim2(0, 0, 0, position)}
					TextYAlignment={"Top"}
				/>,
			);

			position += delayIncrement;
		}

		position += delayIncrement;
	}

	return (
		<screengui>
			<textlabel
				BackgroundTransparency={1}
				TextColor3={Color3.fromRGB(255, 255, 255)}
				Text={"Click to exit"}
				Position={UDim2.fromScale(0, 1)}
				AnchorPoint={new Vector2(0, 1)}
				ZIndex={5}
				Size={UDim2.fromScale(0.1, 0.1)}
			/>
			<frame
				Key={"CreditScreenFrame"}
				Size={UDim2.fromScale(1, 10)} // Adjust the Y value as needed
				BackgroundColor3={Color3.fromRGB(0, 0, 0)}
				BorderSizePixel={0}
				Position={new UDim2(0, 0, offset, 0)}
				ClipsDescendants={true} // Clip the contents within the frame
			>
				<uilistlayout
					FillDirection={Enum.FillDirection.Vertical}
					HorizontalAlignment={Enum.HorizontalAlignment.Center}
					SortOrder={Enum.SortOrder.LayoutOrder}
					Padding={new UDim(0, 0)}
				/>
				{creditElements}
			</frame>
		</screengui>
	);
};

export = new Hooks(Roact)(CreditScreen);
