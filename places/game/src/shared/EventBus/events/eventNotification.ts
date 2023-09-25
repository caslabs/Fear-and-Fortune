import { EventManager } from "../EventManager";
import { GameEventType } from "../eventTypes";
import { NotificationManager } from "shared/NotificationManager/NotificationManager";

interface EventNotificationData {
	title: string;
	description: string;
	image: string;
}

export class EventNotification {
	private notificationManager: NotificationManager;

	constructor(eventManager: EventManager) {
		this.notificationManager = NotificationManager.getInstance();
		eventManager.registerListener(GameEventType.Notification, (eventData: EventNotificationData) =>
			this.handleNotificationEvent(eventData),
		);
	}

	private handleNotificationEvent(eventData: EventNotificationData) {
		// Delegate the event data to the NotificationManager
		this.notificationManager.enqueueNotification(eventData);
	}
}
