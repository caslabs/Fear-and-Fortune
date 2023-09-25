import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import { Context, Pages } from "ui/Context";
import { Panel } from "ui/Panels/Panel";
import { Players } from "@rbxts/services";
import Remotes from "shared/remotes";
import { Signals } from "shared/signals";
import IntroScreen from "systems/NarrartiveSystem/CutsceneSystem/scenes/introduction-scene/screens/intro-screen";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import { NotificationManager } from "mechanics/PlayerMechanics/UIMechanic/manager/NotificationManager";
import SprintBar from "ui/components/sprint-bar";

import { ContextActionService, TweenService, Workspace } from "@rbxts/services";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import HungerBar from "ui/components/Survival/hunger-bar";
import ThirstBar from "ui/components/Survival/thirst-bar";
import Morale from "ui/components/Survival/morale";
import ExposureBar from "ui/components/Survival/exposure-bar";
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

print("Initializing PLAYHUD");
const PlayHUD: Hooks.FC<PlayHUDPprops> = (props, { useState, useEffect }) => {
	const [sanity, setSanity] = useState(100);
	const [stamina, setStamina] = useState(100); // Add this line
	const [hunger, setHunger] = useState(100); // Add this line
	const [thirst, setThirst] = useState(100); // Add this line
	const [exposure, setExposure] = useState(100); // Add this line
	const [morale, setMorale] = useState(0); // Add this line
	const [elevation, setElevation] = useState(0); // New state for elevation
	const [isWearingMask, setIsWearingMask] = useState(false);

	//Bind G to toggle mask
	/*
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
	*/

	useEffect(() => {
		const connection2 = Signals.playerElevationChanged.Connect((player, newElevation) => {
			if (player === Players.LocalPlayer) {
				//Meters ?
				const elevationInMeters = newElevation * 0.508;
				const roundedElevationInMeters = math.round(elevationInMeters) / 10;
				setElevation(roundedElevationInMeters);
			}
		});
		const connection = Signals.StaminaUpdate.Connect((player, newStamina) => {
			if (player === Players.LocalPlayer) {
				setStamina(newStamina);
			}
		});

		//Hunger
		const hungerConnection = Signals.HungerUpdate.Connect((player, newHunger) => {
			if (player === Players.LocalPlayer) {
				setHunger(newHunger);
			}
		});

		//Thirst
		const thirstConnection = Signals.ThirstUpdate.Connect((player, newThirst) => {
			if (player === Players.LocalPlayer) {
				setThirst(newThirst);
			}
		});

		//Morale
		const moraleConnection = Signals.MoraleUpdate.Connect((player, newMorale) => {
			if (player === Players.LocalPlayer) {
				setMorale(newMorale);
			}
		});

		//Exposure
		const exposureConnection = Signals.ExposureUpdate.Connect((player, newExposure) => {
			if (player === Players.LocalPlayer) {
				setExposure(newExposure);
			}
		});

		return () => {
			connection.Disconnect();
			connection2.Disconnect();
			hungerConnection.Disconnect();
			thirstConnection.Disconnect();
			moraleConnection.Disconnect();
			exposureConnection.Disconnect();
		};
	}, []);

	UpdateSanityEvent.Connect((player, sanity) => {
		if (player === Players.LocalPlayer) {
			setSanity(sanity);
		}
	});

	return (
		<Panel index={Pages.play} visible={props.visible}>
			<imagelabel
				Size={new UDim2(1, 0, 1, 0)}
				Image={"rbxassetid://6127325184"}
				BackgroundTransparency={1}
				Visible={isWearingMask}
				ZIndex={-10}
			/>
			<SprintBar staminaD={stamina} />
			<HungerBar hunger={hunger} />
			<ThirstBar thirst={thirst} />
			<ExposureBar exposure={exposure} />
			<Morale morale={morale} />
		</Panel>
	);
};

export default new Hooks(Roact)(PlayHUD);
