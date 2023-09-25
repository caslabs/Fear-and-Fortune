import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import RoactSpring from "@rbxts/roact-spring";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";

interface IntroProp {}

const SplashScreen: Hooks.FC<IntroProp> = (props, hooks) => {
	const logoStyle = RoactSpring.useSpring(hooks, {
		from: { transparency: 0 } as any,
		to: { transparency: 1 } as any,
		delay: 5 as any,
		config: { mass: 1, tension: 280, friction: 60 } as any,
	});

	const warningStyle = RoactSpring.useSpring(hooks, {
		from: { transparency: 0 } as any,
		to: { transparency: 1 } as any,
		delay: 10 as any,
		config: { mass: 1, tension: 280, friction: 60 } as any,
	});

	hooks.useEffect(() => {
		//Plays the snow storm ambience
		SoundSystemController.playSound(SoundKeys.SFX_SNOW_AMBIENCE);
	}, []);
	return (
		<frame Key={"IntroScene"} Size={UDim2.fromScale(1, 1)} BackgroundTransparency={1} LayoutOrder={99999}>
			<imagelabel
				Key="Logo"
				Size={UDim2.fromScale(1, 1)}
				BackgroundColor3={Color3.fromRGB(0, 0, 0)}
				BackgroundTransparency={logoStyle.transparency as any}
				Image="rbxassetid://13425295067"
				ImageTransparency={logoStyle.transparency as any}
				ZIndex={11}
			/>
			<frame
				Key="WarningFrame"
				Size={UDim2.fromScale(1, 1)}
				BackgroundTransparency={warningStyle.transparency as any}
				ZIndex={10}
				BackgroundColor3={Color3.fromRGB(0, 0, 0)}
			>
				<textlabel
					Key="WarningText"
					Size={UDim2.fromScale(1, 1)}
					AnchorPoint={new Vector2(0, 0)}
					Position={UDim2.fromScale(0, 0)}
					BorderSizePixel={0}
					BackgroundTransparency={warningStyle.transparency as any}
					Text="Jam a man of fortune, and J must seek my fortune. -Henry Aeveries, 1994"
					TextColor3={new Color3(1, 1, 1)}
					FontSize={Enum.FontSize.Size10}
					TextWrapped={true}
					TextTransparency={warningStyle.transparency as any}
					BackgroundColor3={Color3.fromRGB(0, 0, 0)}
					ZIndex={11}
				/>
			</frame>
		</frame>
	);
};

export = new Hooks(Roact)(SplashScreen);
