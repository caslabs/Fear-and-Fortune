import Roact from "@rbxts/roact";
import { Context } from "../Context";
import SpectateHUD from "../huds/spectate-hud";

interface routerProps {}
interface routerState {
	viewIndex: number;
	setPage: (index: number) => void;
}

// Create a context router for opening pages
export class RouterSpectateHUD extends Roact.Component<routerProps, routerState> {
	constructor(props: {}) {
		super(props);
		this.setState({
			viewIndex: 3,
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
				<SpectateHUD />
			</Context.Provider>
		);
	}
}
