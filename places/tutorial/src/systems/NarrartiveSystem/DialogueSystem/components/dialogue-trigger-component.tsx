// client/components/LandmarkComponent.ts
import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import { Players } from "@rbxts/services";
import Roact from "@rbxts/roact";
import Notification from "mechanics/PlayerMechanics/UIMechanic/manager/notification";
import DialogueBox from "../manager/dialogue-box";
import SoundSystemController from "systems/AudioSystem/SoundSystem/controller/sound-system-controller";
import MusicSystemController from "systems/AudioSystem/MusicSystem/controller/music-controller";

const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

interface Attributes {
	dialogue: string;
}

@Component({
	tag: "DialogueTrigger",
	attributes: {},
	instanceGuard: t.instanceIsA("BasePart"),
})
export class DialogueTriggerComponent extends BaseComponent<Attributes, BasePart> implements OnStart {
	private playersInZone: Set<Player> = new Set();
	private notifiedPlayers: Set<Player> = new Set();
	private debounce = false;

	constructor() {
		super();
	}

	onStart() {
		print("DialogueTrigger Component Initiated");
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
				this.showNotification(player);
				print("Dialogue Box Showing Notification");
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

	showNotification(player: Player) {
		//TODO: TEMP, need an event manager to handle these if statements
		if (this.attributes.dialogue === "?!?!") {
			//SoundSystemController.playSoundVolume("9114224721", 10);
			//MusicSystemController.playLocalMusic("test", "1835342628");
		}
		Promise.delay(0.1).then(() => {
			const handle: Roact.Tree = Roact.mount(
				<screengui Key={"DialogueBoxScreen"} IgnoreGuiInset={true} ResetOnSpawn={false}>
					<DialogueBox title={""} description={this.attributes.dialogue} image={""} />
				</screengui>,
				PlayerGui,
			);
			wait(5);
			Roact.unmount(handle);
		});
	}
}
