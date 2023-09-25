import { OnStart, Service } from "@flamework/core";
import Remotes from "shared/remotes";

@Service({})
export default class MusicSystemService implements OnStart {
	public onStart() {
		print("MusicSystem Service Started");

		const playMusic = Remotes.Server.Get("PlayMusic");
		const requestMusicPlay = Remotes.Server.Get("RequestMusicPlay");

		// Send Music to all players
		requestMusicPlay.Connect((player) => {
			print("Playing requested music from player " + player.Name);
			//playMusic.SendToAllPlayers("9047504196");
		});
	}
}
