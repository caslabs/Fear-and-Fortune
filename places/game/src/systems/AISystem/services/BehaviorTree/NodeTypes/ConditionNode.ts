import { BehaviorTreeNode } from "./BehaviorTreeNode";

export class ConditionNode extends BehaviorTreeNode {
	condition: () => boolean;

	constructor(condition: () => boolean) {
		super();
		this.condition = condition;
	}

	execute(): boolean {
		return this.condition();
	}
}
