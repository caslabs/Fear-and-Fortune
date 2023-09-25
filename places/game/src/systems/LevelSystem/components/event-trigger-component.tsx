// client/components/LandmarkComponent.ts
import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import { Players, Workspace } from "@rbxts/services";
import Roact from "@rbxts/roact";
import Notification from "mechanics/PlayerMechanics/UIMechanic/manager/notification";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";
import CameraShaker from "@caslabs/roblox-modified-camera-shaker";
import DialogueBox from "systems/NarrartiveSystem/DialogueSystem/manager/dialogue-box";
import { SoundKeys } from "systems/AudioSystem/SoundSystem/manager/SoundData";
import { MusicKeys } from "systems/AudioSystem/MusicSystem/manager/MusicData";
import { Signals } from "shared/signals";

const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");
const camera = Workspace.CurrentCamera!;
const camShake = new CameraShaker(
	Enum.RenderPriority.Camera.Value,
	(shakeCFrame) => (camera.CFrame = camera.CFrame.mul(shakeCFrame)),
);

interface Attributes {
	ID: string;
}

@Component({
	tag: "EventTrigger",
	attributes: {},
	instanceGuard: t.instanceIsA("BasePart"),
})
export class EventTriggerComponent extends BaseComponent<Attributes, BasePart> implements OnStart {
	private playersInZone: Set<Player> = new Set();
	private notifiedPlayers: Set<Player> = new Set();
	private debounce = false;

	constructor() {
		super();
	}

	onStart() {
		print("EventTrigger Component Initiated");
		this.instance.Touched.Connect((part: BasePart) => this.onTouch(part));
		this.instance.TouchEnded.Connect((part: BasePart) => this.onTouchEnd(part));
	}

	onTouch(part: BasePart) {
		const player = Players.GetPlayerFromCharacter(part.Parent);
		if (player && !this.playersInZone.has(player) && !this.notifiedPlayers.has(player)) {
			this.playersInZone.add(player);
			this.notifiedPlayers.add(player);
			if (!this.debounce) {
				this.debounce = true;
				this.onEvent(player);
				print("Triggering Event");
				Promise.delay(1).then(() => (this.debounce = false));
			}
		}
	}

	onTouchEnd(part: BasePart) {
		const player = Players.GetPlayerFromCharacter(part.Parent);
		if (player) {
			this.playersInZone.delete(player);
		}
	}

	async onEvent(player: Player) {
		//TODO: TEMP, need an event manager to handle these if statements
		if (this.attributes.ID === "JUMPSCARE") {
			camShake.Start();

			//TODO: temporarily hack - cannot access SoundSystem, must use remote events.
			SoundSystemController.playSound(SoundKeys.SFX_EARTHQUAKE, 10);

			//TODO: Should use the NotificationManager
			//?!?! Dialogue
			const handle: Roact.Tree = Roact.mount(
				<screengui Key={"DialogueBoxScreen"} IgnoreGuiInset={true} ResetOnSpawn={false}>
					<DialogueBox title={""} description={"You: I'm not alone here...."} image={""} />
				</screengui>,
				PlayerGui,
			);

			camShake.Shake(CameraShaker.Presets.Explosion);
			await Promise.delay(5);
			camShake.Stop();
		} else if (this.attributes.ID === "WHISPHER") {
			SoundSystemController.playSound(SoundKeys.SFX_WHISPHER, 10);
			print("WHISPHER");
			Signals.enableJumpScareEvent.Fire();
		} else if (this.attributes.ID === "TIK_TOK") {
			MusicSystemController.playMusic(MusicKeys.TIK_TOK);
		}
	}
}
