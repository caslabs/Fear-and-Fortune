import { BehaviorTreeNode } from "./BehaviorTreeNode";

export class SelectorNode extends BehaviorTreeNode {
	children: BehaviorTreeNode[];

	constructor(children: BehaviorTreeNode[]) {
		super();
		this.children = children;
	}

	execute(): boolean {
		for (const child of this.children) {
			if (child.execute()) {
				return true;
			}
		}
		return false;
	}
}
