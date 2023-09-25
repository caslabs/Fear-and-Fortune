import Roact from "@rbxts/roact";

interface tabState {}
interface tabProps {
	text: string;
}

// Tab component used for swapping tabs in pages
export class Tab extends Roact.Component<tabProps, tabState> {
	constructor(props: tabProps) {
		super(props);
	}

	render() {
		return (
			<textbutton
				Key={"Div"}
				Text={this.props.text}
				Size={UDim2.fromOffset(100, 40)}
				BorderSizePixel={0}
				TextSize={24}
				Font={Enum.Font.SourceSansBold}
			>
				<uicorner CornerRadius={new UDim(0, 6)} />
			</textbutton>
		);
	}
}
