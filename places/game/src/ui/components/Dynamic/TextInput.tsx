import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";

interface TextInputProps {
	someRef: Roact.Ref<TextBox>;
	onTextChange: Roact.JsxInstanceChangeEvents<TextBox>;
}

//TODO: Input State
const TextInput: Hooks.FC<TextInputProps> = (props, { useState }) => {
	const [input, setInput] = useState("");
	return (
		<textbox
			Ref={props.someRef}
			Change={props.onTextChange}
			PlaceholderText={"Enter Friend Name"}
			PlaceholderColor3={new Color3(0.4, 0.4, 0.4)}
		/>
	);
};

export default new Hooks(Roact)(TextInput);
