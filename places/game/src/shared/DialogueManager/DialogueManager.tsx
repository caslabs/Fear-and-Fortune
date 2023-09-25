import { GameDialogue } from "./dialogue-model";
import { Players } from "@rbxts/services";
import Roact from "@rbxts/roact";
import ItemPopup from "../NotificationManager/notification";
import DialogueBox from "./dialogue-box";
import { Dialogue, SoundManager } from "../sound-manager";

const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

interface DialogueManagerData {
	dialogue: string;
}

export class DialogueManager {
	private dialogues: GameDialogue[];
	private currentDialogue: GameDialogue | undefined;
	private currentLineIndex: number;
	soundManager: SoundManager;

	constructor(dialogues: GameDialogue[]) {
		this.dialogues = dialogues;
		this.currentDialogue = undefined;
		this.currentLineIndex = -1;
		// Initialize any necessary resources
		this.soundManager = SoundManager.getInstance();
	}

	startDialogue(dialogueId: string): void {
		const dialogue = this.dialogues.find((d) => d.id === dialogueId);
		if (dialogue) {
			this.currentDialogue = dialogue;
			this.currentLineIndex = 0;
			const character = dialogue.character1!.name;
			const line = dialogue.lines[this.currentLineIndex];
			print("About to be Mounted");
			const CHARACTERS_PER_SECOND = 10; // Since each character takes 0.1 seconds, you can display 10 characters in 1 second.
			const unmountDelay = this.currentDialogue.lines[this.currentLineIndex].size() / CHARACTERS_PER_SECOND;
			const totalDelay = unmountDelay + 5;

			//TODO: Poorly Optimized. Keeps calling it!

			const handle: Roact.Tree = Roact.mount(
				<screengui Key={"DialogPopup"} IgnoreGuiInset={true} ResetOnSpawn={false}>
					<DialogueBox title={character} description={line} image={""} />
				</screengui>,
				PlayerGui,
			);
			print("Mounted");

			this.soundManager.LoadSound({ fileName: Dialogue[dialogueId], soundName: dialogueId, volume: 10 });
			this.soundManager.PlaySound(dialogueId);
			Promise.delay(totalDelay).then(() => {
				Roact.unmount(handle);
			});
			const advanceLines = () => {
				if (this.currentLineIndex < (this.currentDialogue?.lines.size() ?? 0) - 1) {
					this.currentLineIndex++;
					const line = this.currentDialogue!.lines[this.currentLineIndex];
					Promise.delay(1).then(advanceLines);
					const handle: Roact.Tree = Roact.mount(
						<screengui Key={"DialogPopup"} IgnoreGuiInset={true} ResetOnSpawn={false}>
							<ItemPopup title={"Test"} description={line} image={""} />
						</screengui>,
						PlayerGui,
					);
					print("Mounted");
					Promise.delay(5).then(() => {
						Roact.unmount(handle);
					});
				} else {
					this.endDialogue();
				}
			};

			Promise.delay(1).then(advanceLines);
		} else {
			warn(`Dialogue with id '${dialogueId}' not found.`);
		}
	}

	advanceDialogue(): void {
		if (this.currentDialogue && this.currentLineIndex < (this.currentDialogue.lines.size() ?? 0) - 1) {
			this.currentLineIndex++;
			const line = this.currentDialogue.lines[this.currentLineIndex];
			const handle: Roact.Tree = Roact.mount(
				<screengui Key={"DialogPopup"} IgnoreGuiInset={true} ResetOnSpawn={false}>
					<ItemPopup title={"Test"} description={line} image={""} />
				</screengui>,
				PlayerGui,
			);
			print("Mounted");
			Promise.delay(5).then(() => {
				Roact.unmount(handle);
			});
		} else {
			print("No dialogue to advance or already at the end of the dialogue.");
		}
	}

	endDialogue(): void {
		if (this.currentDialogue) {
			print("Dialogue ended.");
			this.currentDialogue = undefined;
			this.currentLineIndex = -1;
		} else {
			print("No dialogue to end.");
		}
	}
}
