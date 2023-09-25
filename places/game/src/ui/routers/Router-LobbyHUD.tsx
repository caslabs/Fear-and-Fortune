import Roact from "@rbxts/roact";
import { Context, Pages } from "../Context";
import PlayHUD from "../huds/play-hud";
import TitleScreen from "systems/NarrartiveSystem/CutsceneSystem/scenes/introduction-scene/screens/title-screen";

interface routerProps {}
interface routerState {
	viewIndex: number;
	setPage: (index: number) => void;
}

// Create a context router for opening pages
export class RouterLobbyHUD extends Roact.Component<routerProps, routerState> {
	constructor(props: {}) {
		super(props);
		this.setState({
			viewIndex: 4,
		});
	}

	setPage(index: number) {
		this.setState({
			viewIndex: index,
		});
	}

	render(): Roact.Element {
		return (
			<Context.Provider
				value={{
					viewIndex: this.state.viewIndex,
					setPage: (index: number) => this.setPage(index),
				}}
			>
				<TitleScreen />
			</Context.Provider>
		);
	}
}
