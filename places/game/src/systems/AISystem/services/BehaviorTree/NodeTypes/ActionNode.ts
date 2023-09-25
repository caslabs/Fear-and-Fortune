import { BehaviorTreeNode } from "./BehaviorTreeNode";

export class ActionNode extends BehaviorTreeNode {
	action: () => boolean;

	constructor(action: () => boolean) {
		super();
		this.action = action;
	}

	execute(): boolean {
		return this.action();
	}
}
