import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { Players, RunService } from "@rbxts/services";

interface Attributes {}
const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

@Component({
	tag: "FloatingSkull",
})
export class StatueComponent extends BaseComponent<Attributes> implements OnStart {
	private flipState = false;
	private flipTimer = 0;
	private flipInterval = 5; // Time between flips in seconds

	public getFloatHeight(
		time: number,
		amplitude: number,
		frequency: number,
		phase: number,
		startPosition: Vector3,
	): number {
		return amplitude * math.sin(frequency * time + phase) + startPosition.Y;
	}

	public updateModel(
		model: Model,
		time: number,
		startPosition: Vector3,
		startOrientation: Vector3,
		amplitude: number,
		frequency: number,
		phase: number,
	): void {
		const newPosition = new Vector3(
			startPosition.X,
			this.getFloatHeight(time, amplitude, frequency, phase, startPosition),
			startPosition.Z,
		);

		const yAngle = this.flipState ? math.pi : 0;
		model.SetPrimaryPartCFrame(new CFrame(newPosition).mul(CFrame.fromOrientation(0, yAngle, 0)));
	}

	onStart() {
		print("Statue Component Started");
		if (this.instance.IsA("Model")) {
			const model = this.instance!;
			print("Starting animation");
			const amplitude = 5; // The maximum height of the float
			const frequency = 1; // The number of cycles per second
			const phase = 0; // The starting phase of the float
			const startPosition = model.PrimaryPart!.Position; // The starting position of the model
			const startOrientation = new Vector3(0, 0, 0); // The starting orientation of the model

			while (true) {
				// Get the current time
				const time = tick();

				// Check if it's time to flip
				if (time - this.flipTimer >= this.flipInterval) {
					this.flipState = !this.flipState;
					this.flipTimer = time;
				}

				// Update the model's position and orientation
				this.updateModel(model, time, startPosition, startOrientation, amplitude, frequency, phase);

				// Wait for the next frame
				RunService.Heartbeat.Wait();
			}
		}
	}
}
