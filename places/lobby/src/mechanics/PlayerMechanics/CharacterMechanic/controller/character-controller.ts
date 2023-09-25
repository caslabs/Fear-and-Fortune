import { Controller, OnInit, OnStart } from "@flamework/core";
import { Players, RunService } from "@rbxts/services";
import Signal from "@rbxts/signal";
import yieldForR15CharacterDescendants, { CharacterRigR15 } from "@rbxts/yield-for-character";

const player = Players.LocalPlayer;

@Controller({
	loadOrder: 0, // This controller might need to run after others
})
export default class CharacterMechanic implements OnStart {
	public readonly onCharacterAdded = new Signal<(character: CharacterRigR15) => void>();
	public onCharacterRemoved = new Signal<(character: CharacterRigR15) => void>();

	private currentCharacter?: CharacterRigR15;

	public onStart(): void {
		print("CharacterMechanic started");
		if (player.Character) this.onCharacterAddedCallback(player.Character);
		player.CharacterAdded.Connect((c) => this.onCharacterAddedCallback(c));

		player.CharacterRemoving.Connect((c) => this.onCharacterRemoving(c));
	}

	public getCurrentCharacter() {
		return this.currentCharacter;
	}

	private async onCharacterAddedCallback(model: Model) {
		const character = await yieldForR15CharacterDescendants(model);
		this.currentCharacter = character;
		this.onCharacterAdded.Fire(character); // Emit an event when a new character is added
	}

	private onCharacterRemoving(model: Model) {
		if (this.currentCharacter !== undefined && model === this.currentCharacter) {
			this.currentCharacter = undefined;
			if (!model.Parent) {
				this.onCharacterRemoved.Fire(model as CharacterRigR15);
			}
		}
	}
}
