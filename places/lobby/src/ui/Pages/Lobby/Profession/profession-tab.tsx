import Roact from "@rbxts/roact";
import Hooks from "@rbxts/roact-hooks";
import Remotes from "shared/remotes";
import ProfessionItem from "ui/components/Items/ProfessionItem"; // Import ProfessionItem

export interface Data {
	name: string;
	desc: string;
	color: Color3;
	isLocked: boolean;
}

interface ProfessionProps {
	data: Array<Data>;
	visible: string;
}

enum PlayerClass {
	Mountaineer,
	Soldier,
	Engineer,
	Doctor,
	Scholar,
	Cameraman,
}

function PlayerClassToString(playerClass: PlayerClass) {
	switch (playerClass) {
		case PlayerClass.Mountaineer:
			return "Mountaineer";
		case PlayerClass.Soldier:
			return "Soldier";
		case PlayerClass.Engineer:
			return "Engineer";
		case PlayerClass.Doctor:
			return "Doctor";
		case PlayerClass.Scholar:
			return "Scholar";
		case PlayerClass.Cameraman:
			return "Cameraman";
	}
}

function StringToPlayerClass(playerClass: string) {
	switch (playerClass) {
		case "Mountaineer":
			return PlayerClass.Mountaineer;
		case "Soldier":
			return PlayerClass.Soldier;
		case "Engineer":
			return PlayerClass.Engineer;
		case "Doctor":
			return PlayerClass.Doctor;
		case "Scholar":
			return PlayerClass.Scholar;
		case "Cameraman":
			return PlayerClass.Cameraman;
	}
}

const RequestUpdateProfessionEvent = Remotes.Client.Get("RequestProfessionUpdate");
const RequestSendPartyMemberofClassEvent = Remotes.Client.Get("RequestPartyMemberofClassEvent");

const Profession: Hooks.FC<ProfessionProps> = (props, { useState }) => {
	const [selectedProfessionItem, setSelectedProfessionItem] = useState<Data | undefined>(props.data[0]); // Default to first item

	return (
		<frame
			Key={"Profession"}
			Size={new UDim2(1, 0, 1, 0)}
			Position={UDim2.fromScale(0, 1)}
			AnchorPoint={new Vector2(0, 1)}
			BorderSizePixel={0}
			BackgroundTransparency={1}
			Visible={props.visible === "profession"}
		>
			<frame
				Size={UDim2.fromScale(1, 0.4)} // Adjust to make room for Professioning info
				Position={UDim2.fromScale(0, 0)}
				BorderSizePixel={0}
				BackgroundTransparency={1}
			>
				<scrollingframe
					Size={UDim2.fromScale(1, 1)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
					ScrollBarThickness={3}
					AutomaticCanvasSize={"X"}
				>
					<uigridlayout CellPadding={UDim2.fromScale(0.03, 0)} CellSize={UDim2.fromScale(0.3, 0.5)} />
					{/* This will create a carousel */}
					{props.data.map((info, index) => (
						<ProfessionItem
							Key={info.name}
							title={info.name}
							desc={""} // Description is not shown in the carousel
							color={info.isLocked ? Color3.fromRGB(128, 128, 128) : info.color} // Gray color for locked professions
							layoutOrder={index}
							active={selectedProfessionItem === info} // Pass active state
							isLocked={info.isLocked} // Pass locked status
							onClick={() => {
								setSelectedProfessionItem(info);
								RequestUpdateProfessionEvent.SendToServer(info.name);
								/*
								SendPartyMemberofClassEvent.SendToServer(info.name);
								//TODO: interesting, doesn't show if true but be interesting to use for other mechanics
								/*
								if (!info.isLocked) {
									setSelectedProfessionItem(info); // Set this item as active
								}
								*/
							}}
						/>
					))}
				</scrollingframe>
			</frame>
			{selectedProfessionItem && (
				<frame
					// Professioning Info Panel
					Size={UDim2.fromScale(1, 0.6)}
					Position={UDim2.fromScale(0, 0.4)}
					BorderSizePixel={0}
					BackgroundTransparency={1}
				>
					<textlabel
						Text={selectedProfessionItem.name}
						Size={UDim2.fromScale(1, 0.2)} /* Rest of the properties */
						BackgroundTransparency={1}
						Font={Enum.Font.Gotham}
						TextColor3={Color3.fromRGB(230, 230, 230)}
						FontSize={Enum.FontSize.Size24}
					/>
					<textlabel
						Text={selectedProfessionItem.desc}
						Position={UDim2.fromScale(0, 0.2)}
						Size={UDim2.fromScale(1, 0.6)} /* Rest of the properties */
						BackgroundTransparency={1}
						TextXAlignment={Enum.TextXAlignment.Left}
						TextYAlignment={Enum.TextYAlignment.Top}
						Font={Enum.Font.Gotham}
						FontSize={Enum.FontSize.Size14}
						RichText={true}
						TextWrapped={true}
						TextColor3={Color3.fromRGB(230, 230, 230)}
					/>
					<textbutton
						Text={
							selectedProfessionItem === props.data[0]
								? "CURRENT"
								: selectedProfessionItem.isLocked
								? "LOCKED"
								: "CHOOSE PROFESSION"
						}
						Size={UDim2.fromScale(1, 0.2)}
						AnchorPoint={new Vector2(0, 1)}
						Position={UDim2.fromScale(0, 1)}
						Font={Enum.Font.Gotham}
						TextColor3={Color3.fromRGB(200, 200, 200)}
						BackgroundColor3={
							selectedProfessionItem === props.data[0]
								? Color3.fromRGB(75, 75, 75)
								: selectedProfessionItem.isLocked
								? Color3.fromRGB(128, 128, 128)
								: Color3.fromRGB(45, 45, 45)
						}
					/>
				</frame>
			)}
		</frame>
	);
};

export default new Hooks(Roact)(Profession);
