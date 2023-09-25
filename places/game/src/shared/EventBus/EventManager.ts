import { GameEventType } from "./eventTypes";
export { EventManager };

class EventManager {
	private static instance: EventManager;
	private listeners: Map<GameEventType, Set<(eventData: any) => void>>;

	constructor() {
		this.listeners = new Map();
	}

	public static getInstance(): EventManager {
		if (!EventManager.instance) {
			EventManager.instance = new EventManager();
		}
		return EventManager.instance;
	}

	registerListener(eventType: GameEventType, callback: (eventData: any) => void) {
		if (!this.listeners.has(eventType)) {
			this.listeners.set(eventType, new Set());
		}

		const listenerSet = this.listeners.get(eventType);
		listenerSet?.add(callback);
	}

	deregisterListener(eventType: GameEventType, callback: (eventData: any) => void) {
		const listenerSet = this.listeners.get(eventType);

		if (listenerSet) {
			listenerSet.delete(callback);
		}
	}

	dispatchEvent(eventType: GameEventType, eventData: any) {
		const listenerSet = this.listeners.get(eventType);

		if (listenerSet) {
			for (const callback of listenerSet) {
				callback(eventData);
			}
		}
	}
}
