import Roact from "@rbxts/roact";
import LobbyHUD from "ui/huds/lobby-hud";
import TwitterHUD from "ui/huds/twitter-hud";
import TutorialHUD from "ui/huds/tutorial-hud";
import { Context } from "./Context-LobbyHUD";

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
			viewIndex: 1,
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
				<LobbyHUD />
				<TwitterHUD />
				<TutorialHUD />
			</Context.Provider>
		);
	}
}
