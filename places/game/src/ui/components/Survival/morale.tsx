import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface MoraleProps {
	morale: number;
}

//TODO: going 8 or more makes UI skulls out of place. thankfully it's max 7 for now, looks ok.

const Morale: Hooks.FC<MoraleProps> = (props, { useState, useEffect }) => {
	const [prevMorale, setPrevMorale] = useState(props.morale);
	const [showOverlay, setShowOverlay] = useState(false);

	//might be useful later - morale checker
	useEffect(() => {
		// check if morale has been increased
		if (props.morale > prevMorale) {
			setShowOverlay(true);
			// set a timeout to hide the overlay after a short delay
			Promise.delay(2).then(() => setShowOverlay(false));
		}
		// update previous morale value
		setPrevMorale(props.morale);
	}, [props.morale]);

	const createMoraleIcons = () => {
		const minScale = 0.15; // minimum scale for the skulls
		const maxScale = 0.5; // maximum scale for the skulls
		let scale = 1 / props.morale;

		// make sure scale is within the min-max range
		if (scale > maxScale) scale = maxScale;
		if (scale < minScale) scale = minScale;

		const icons: JSX.Element[] = [];
		for (let i = 0; i < props.morale; i++) {
			icons.push(
				<imagelabel
					Key={`MoraleIcon-${i}`}
					Image="rbxassetid://6127325184" // replace with your actual asset id
					AnchorPoint={new Vector2(0, 0.5)}
					Position={new UDim2(i * scale, 0, 0.5, 0)}
					Size={new UDim2(scale, 0, 0.5, 0)} // adjust size as per your need
					BackgroundTransparency={1}
					ImageTransparency={0.5}
				/>,
			);
		}
		return icons;
	};

	return (
		<frame
			Key={"Morale"}
			Position={new UDim2(0.98, 0, 0.99, 0)}
			Size={new UDim2(0.15, 0, 0.15, 0)}
			AnchorPoint={new Vector2(1, 1)}
			BackgroundColor3={new Color3(1, 1, 1)}
			BackgroundTransparency={1}
		>
			{createMoraleIcons()}
		</frame>
	);
};

export default new Hooks(Roact)(Morale);
