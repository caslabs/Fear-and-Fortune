import Roact from "@rbxts/roact";
import { Players } from "@rbxts/services";
import Notification from "./notification";

const Player = Players.LocalPlayer;
const PlayerGui = Player.WaitForChild("PlayerGui");

interface NotificationData {
	title: string;
	description: string;
	image: string;
}

class NotificationManager {
	private static instance: NotificationManager;
	private notificationQueue: NotificationData[];
	private notificationActive: boolean;

	private constructor() {
		this.notificationQueue = [];
		this.notificationActive = false;
	}

	public static getInstance(): NotificationManager {
		if (!this.instance) {
			this.instance = new NotificationManager();
		}
		return this.instance;
	}

	public enqueueNotification(data: NotificationData) {
		this.notificationQueue.push(data); // Add incoming notification to the queue
		this.processQueue(); // Try to process the queue
	}

	// Function to process the notification queue
	private processQueue() {
		if (this.notificationActive || this.notificationQueue.size() === 0) return; // If a notification is active or the queue is empty, do nothing

		this.notificationActive = true; // Set flag to true as we are about to show a notification
		const data = this.notificationQueue.shift(); // Dequeue the first notification from the queue

		//TODO: port over QuestUpdatePopup component
		const handle: Roact.Tree = Roact.mount(
			<screengui Key={"ItemPopup"} IgnoreGuiInset={true} ResetOnSpawn={false}>
				<Notification
					title={data!.title}
					description={data!.description}
					image={"rbxassetid://" + data!.image}
				/>
			</screengui>,
			PlayerGui,
		);

		wait(5);
		Roact.unmount(handle);

		this.notificationActive = false; // Reset flag as the notification has been removed

		this.processQueue(); // Try to process the next item in the queue
	}
}

export { NotificationManager };
