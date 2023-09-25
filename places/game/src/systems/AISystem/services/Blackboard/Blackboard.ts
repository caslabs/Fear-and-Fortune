/*
    the Blackboard system's primary goal is flexibility.
    It allows different parts of your AI to share knowledge and
    make decisions based on shared or global data.
    For example, if a player is hidden (crouch), then all should
    AIs checks if a player is visible, unless overwrite (maybe AIs that can see hidden)
 */
export {};
class Blackboard {
	private data: Map<string, any> = new Map();

	public set(key: string, value: any): void {
		this.data.set(key, value);
	}

	public get<T>(key: string): T | undefined {
		return this.data.get(key) as T;
	}

	public has(key: string): boolean {
		return this.data.has(key);
	}

	public clear(key: string): void {
		this.data.delete(key);
	}
}
