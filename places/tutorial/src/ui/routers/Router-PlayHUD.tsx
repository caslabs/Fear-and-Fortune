import Roact from "@rbxts/roact";
import { Context, Pages } from "../Context";
import PlayHUD from "../huds/play-hud";
import spectateHud from "ui/huds/spectate-hud";
import Inventory from "ui/screens/inventory";
import Toggles from "ui/screens/toggles";
import { inventoryList } from "ui/screens/_inventoryData";

// Add the new HUDs to the routerProps
interface routerProps {
	profession: string;
}
interface routerState {
	viewIndex: number;
	setPage: (index: number) => void;
}

export class RouterPlayHUD extends Roact.Component<routerProps, routerState> {
	constructor(props: routerProps) {
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
		let HUDComponent;

		//TODO: Create Class System then load the HUD
		switch (this.props.profession) {
			case "Soldier":
				HUDComponent = PlayHUD;
				print("Switched to Soldier HUD");
				break;
			default:
				HUDComponent = PlayHUD;
				print("Switched to Default HUD");
				break;
		}

		return (
			<Context.Provider
				value={{
					viewIndex: this.state.viewIndex,
					setPage: (index: number) => this.setPage(index),
				}}
			>
				<HUDComponent />
				<Toggles />
				<Inventory data={inventoryList} />
			</Context.Provider>
		);
	}
}
