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

//TODO: We haven't used this yet, but we will need to use this to queue notifications
// As it will overlap the notifications. We should queue them and then display them one at a time
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

	public enqueueNotification() {
		this.notificationQueue.push(); // Add incoming notification to the queue
		this.processQueue(); // Try to process the queue
	}

	private processQueue() {
		// If a notification is active or the queue is empty, do nothing
		if (this.notificationActive || this.notificationQueue.size() === 0) return;

		// Set the flag to true as we are about to display a notification
		this.notificationActive = true;
		// Get the next notification in the queue
		const data = this.notificationQueue.shift();

		//Play the current notification
		const handle: Roact.Tree = Roact.mount(
			<screengui Key={"Land"} IgnoreGuiInset={true} ResetOnSpawn={false}>
				<Notification title={"Sherpa's Village"} />
			</screengui>,
			PlayerGui,
		);
		wait(5);
		Roact.unmount(handle);

		// Process the next item in the queue
		this.notificationActive = false; // Reset flag
		this.processQueue();
	}
}

export { NotificationManager };
