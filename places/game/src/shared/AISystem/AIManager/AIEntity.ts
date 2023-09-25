// AIEntity.ts
export interface AIEntity {
	isActive(): boolean;
	initialize(agent: Model): void;
	release(): void;
}
