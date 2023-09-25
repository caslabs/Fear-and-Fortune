import { RunService, Lighting } from "@rbxts/services";
import { Service, OnInit } from "@flamework/core";

// Game state for atmosphere
@Service({
	loadOrder: 0,
})
export class AtmosphereService implements OnInit {
	//TODO: Make this data-driven
	fogDensity = 0.6;

	onInit() {
		print("AtmosphereService started");

		// Only start the fog if this is running on the server
		if (RunService.IsServer()) {
			this.startFog();
		}
	}

	//Set the default fog density
	private startFog() {
		const atmosphere = Lighting.WaitForChild("Atmosphere") as Atmosphere;
		atmosphere.Density = this.fogDensity;
		atmosphere.Offset = 0.095;
	}
}
