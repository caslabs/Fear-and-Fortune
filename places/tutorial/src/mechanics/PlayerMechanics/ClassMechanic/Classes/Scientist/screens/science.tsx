import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Context, Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";
import { StaminaUpdate } from "mechanics/PlayerMechanics/SprintMechanic/controller/stamina-sprint-controller";
import { Signals } from "shared/signals";
import IntroScreen from "systems/NarrartiveSystem/CutsceneSystem/scenes/introduction-scene/screens/intro-screen";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { NotificationManager } from "mechanics/PlayerMechanics/UIMechanic/manager/NotificationManager";
import SprintBar from "ui/components/sprint-bar";

import { ContextActionService, TweenService, Workspace } from "@rbxts/services";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
interface PlayHUDPprops {
	visible?: boolean;
}

const UpdateSanityEvent = Remotes.Client.Get("UpdateSanityEvent");
const UpdateElevationEvent = Remotes.Client.Get("UpdateElevationEvent");

//TODO: Experimental Gas Mask Breahting
const gasMaskBreathing = new Instance("Sound");
gasMaskBreathing.SoundId = "rbxassetid://13868760171";
gasMaskBreathing.Volume = 0.5;
gasMaskBreathing.Looped = true;
gasMaskBreathing.Parent = game.GetService("SoundService");

const ScientistHUD: Hooks.FC<PlayHUDPprops> = (props, { useState, useEffect }) => {
	const [sanity, setSanity] = useState(100);
	const [stamina, setStamina] = useState(100); // Add this line
	const [elevation, setElevation] = useState(0); // New state for elevation
	const [isWearingMask, setIsWearingMask] = useState(true);

	//Bind G to toggle mask
	ContextActionService.BindAction(
		"toggleMask",
		(_, s) => {
			if (s === Enum.UserInputState.Begin) {
				if (isWearingMask) {
					setIsWearingMask(false);
					gasMaskBreathing.Stop();
				} else {
					setIsWearingMask(true);
					SoundSystemController.playSound(SoundKeys.SFX_DEPLOY_MASK);
					gasMaskBreathing.Play();
				}
			}
		},
		true,
		Enum.KeyCode.G,
	);

	useEffect(() => {
		const connection2 = Signals.playerElevationChanged.Connect((player, newElevation) => {
			if (player === Players.LocalPlayer) {
				//Meters ?
				const elevationInMeters = newElevation * 0.508;
				const roundedElevationInMeters = math.round(elevationInMeters) / 10;
				setElevation(roundedElevationInMeters);
			}
		});
		const connection = StaminaUpdate.Connect((player, newStamina) => {
			if (player === Players.LocalPlayer) {
				setStamina(newStamina);
			}
		});
		return () => {
			connection.Disconnect();
			connection2.Disconnect();
		};
	}, []);

	UpdateSanityEvent.Connect((player, sanity) => {
		if (player === Players.LocalPlayer) {
			setSanity(sanity);
		}
	});

	//TODO: Server-Sided Update
	/*
	UpdateElevationEvent.Connect((player, newElevation) => {
		if (player === Players.LocalPlayer) {
			setElevation(newElevation);
		}
	});

				<imagelabel
				Size={new UDim2(1, 0, 1, 0)}
				Image={"rbxassetid://13736545097"}
				BackgroundTransparency={1}
				Visible={isWearingMask}
			/>
	*/

	return (
		<Panel index={Pages.play} visible={props.visible}>
			<imagelabel
				Size={new UDim2(1, 0, 1, 0)}
				Image={"rbxassetid://13888497075"}
				BackgroundTransparency={1}
				Visible={isWearingMask}
				ZIndex={-10}
			/>
			<SprintBar staminaD={stamina} />
			<textlabel
				Text={"Elevation: " + tostring(elevation + 5354) + "m"}
				AnchorPoint={new Vector2(0.5, 0)}
				Size={new UDim2(0.2, 0, 0.2, 0)}
				Position={new UDim2(0.5, 0, 0, 0)}
				BackgroundTransparency={1}
				TextColor3={new Color3(1, 1, 1)}
				FontSize={Enum.FontSize.Size18}
				Font={Enum.Font.GothamBold}
				ZIndex={-5}
			/>
		</Panel>
	);
};

export default new Hooks(Roact)(ScientistHUD);
