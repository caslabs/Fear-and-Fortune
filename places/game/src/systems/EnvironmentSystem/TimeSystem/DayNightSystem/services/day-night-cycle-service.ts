import { RunService, Lighting } from "@rbxts/services";
import { Service, OnInit } from "@flamework/core";

//TODO: Should we have a day and night system?
// How would it be part of our game system? I don't see it...
@Service({})
export class DayNightCycleService implements OnInit {
	// Defines how long is a day
	private realMinutesPerInGameDay = 1500 / 60; // 1500 seconds ~= 25 minutes
	private inGameHoursPerRealSecond = 24 / (this.realMinutesPerInGameDay * 60);

	onInit() {
		print("DayNightCycleService started");
		// Only start the day/night cycle if this is running on the server
		if (RunService.IsServer()) {
			this.startDayNightCycle();
		}
	}

	private startDayNightCycle() {
		RunService.Heartbeat.Connect((deltaTime) => {
			// Update the in-game time based on how much real time has passed since the last frame
			const newTime = (Lighting.ClockTime + this.inGameHoursPerRealSecond * deltaTime) % 24;
			Lighting.ClockTime = newTime;
		});
	}
}
