import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { TweenService } from "@rbxts/services";
import { Signals } from "shared/signals";

interface WakeUpSceneProps {}

const WakeUpScene: Hooks.FC<WakeUpSceneProps> = (props, { useState, useEffect }) => {
	const [topBar, setTopBar] = useState<Frame | undefined>(undefined);
	const [bottomBar, setBottomBar] = useState<Frame | undefined>(undefined);

	const animationSpeed = 0.1;
	const initialDelay = 2.5; // Delay in seconds

	useEffect(() => {
		Promise.delay(initialDelay).then(() => {
			if (topBar && bottomBar) {
				const topTween = animateBar(topBar, new UDim2(0, 0, -0.5, 0));
				const bottomTween = animateBar(bottomBar, new UDim2(0, 0, 1.5, 0));

				Promise.delay(animationSpeed).then(() => {
					print("Waking up is done");
					Signals.finishedWakingUp.Fire();
				});

				// Return a cleanup function that will be called when the component is unmounted
				return () => {
					if (topTween) topTween.Cancel();
					if (bottomTween) bottomTween.Cancel();
				};
			}
		});
	}, [topBar, bottomBar]);

	const animateBar = (bar: Frame, targetPosition: UDim2) => {
		const tweenInfo = new TweenInfo(animationSpeed);
		const goal = { Position: targetPosition };
		const tween = TweenService.Create(bar, tweenInfo, goal);
		tween.Play();
		return tween;
	};

	return (
		<frame Key={"WakeUpSceneFrame"} Size={new UDim2(1, 0, 1, 0)} BackgroundTransparency={1}>
			<frame
				Key={"TopBar"}
				Size={new UDim2(1, 0, 0.5, 0)}
				Position={new UDim2(0, 0, 0, 0)}
				BackgroundColor3={new Color3(0, 0, 0)}
				Ref={setTopBar}
			/>
			<frame
				Key={"BottomBar"}
				Size={new UDim2(1, 0, 0.5, 0)}
				Position={new UDim2(0, 0, 0.5, 0)}
				BackgroundColor3={new Color3(0, 0, 0)}
				Ref={setBottomBar}
				BorderMode={Enum.BorderMode.Outline}
				BorderSizePixel={0}
			/>
		</frame>
	);
};

export = new Hooks(Roact)(WakeUpScene);
