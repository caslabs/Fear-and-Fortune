import Roact from "@rbxts/roact";

interface TabProps {
	onClick: (page: string) => void;
	page: string;
	text: string;
	active: boolean;
}

class Tab extends Roact.Component<TabProps, {}> {
	//Study this mathematical formulae
	calculateTextSize(text: string): number {
		const minFontSize = 14;
		const maxFontSize = 24;
		const scaleFactor = 10;
		const fontSize = minFontSize + scaleFactor / text.size();
		return math.clamp(fontSize, minFontSize, maxFontSize);
	}

	render() {
		const textSize = this.calculateTextSize(this.props.text);

		return (
			<textbutton
				Key={"Tab"}
				Text={this.props.text}
				Size={UDim2.fromScale(1, 0.13)} // set to be 100% of parent width and 20% of parent height
				BackgroundColor3={this.props.active ? Color3.fromRGB(60, 60, 60) : Color3.fromRGB(40, 40, 40)}
				BorderSizePixel={0}
				TextColor3={this.props.active ? Color3.fromRGB(255, 255, 255) : Color3.fromRGB(200, 200, 200)}
				ZIndex={2}
				Font={Enum.Font.SourceSansBold}
				TextSize={textSize}
				TextXAlignment={Enum.TextXAlignment.Center} // center the text horizontally
				Event={{
					MouseButton1Click: () => {
						this.props.onClick(this.props.page);
					},
				}}
			>
				<uicorner CornerRadius={new UDim(0, 6)} />
			</textbutton>
		);
	}
}

export default Tab;
