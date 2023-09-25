import Roact from "@rbxts/roact";
import { Context } from "../Context";
import Shop from "ui/Pages/Shop";
import DialogBox from "ui/Pages/DialogBox";

interface routerProps {}
interface routerState {
	viewIndex: number;
	setPage: (index: number) => void;
}

//TODO: Make this component a functional hook. Blocker: setPage on routerState
// Create a context router for opening pages
export class RouterMerchantHUD extends Roact.Component<routerProps, routerState> {
	constructor(props: {}) {
		super(props);
		this.setState({
			viewIndex: 5,
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
				<Shop />
			</Context.Provider>
		);
	}
}
